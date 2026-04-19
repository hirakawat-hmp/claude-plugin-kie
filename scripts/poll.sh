#!/usr/bin/env bash
# poll.sh — Poll a kie.ai task until it completes or fails.
#
# Usage: poll.sh <taskId> [endpoint-path]
# Defaults:
#   endpoint-path: /api/v1/jobs/recordInfo (Market models)
# Other known polling endpoints:
#   /api/v1/generate/record-info        (Suno)
#   /api/v1/runway/record-detail        (Runway)
#   /api/v1/veo/record-info             (Veo3)
#   /api/v1/flux/record-info            (Flux Kontext)
#   /api/v1/gpt4o-image/record-info     (4o image)
#
# Environment overrides:
#   KIE_POLL_MAX_SECONDS  (default 600)
#   KIE_POLL_INTERVAL     (default 3)
#   KIE_BASE_URL          (default https://api.kie.ai)
#
# Stdout on success: the `data` object from ApiResponse (JSON, compact).
# Exit codes:
#   0 success
#   2 bad arguments
#   3 missing API key / env file
#   5 task failed
#   6 timeout

set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <taskId> [endpoint-path]" >&2
    exit 2
fi

TASK_ID="$1"
ENDPOINT="${2:-/api/v1/jobs/recordInfo}"

ENV_FILE="${KIE_ENV_FILE:-$HOME/.config/kie/env}"
if [ ! -f "$ENV_FILE" ]; then
    echo "Missing env file: $ENV_FILE" >&2
    exit 3
fi
# shellcheck disable=SC1090
source "$ENV_FILE"

if [ -z "${KIE_API_KEY:-}" ]; then
    echo "KIE_API_KEY not set in $ENV_FILE" >&2
    exit 3
fi

BASE_URL="${KIE_BASE_URL:-https://api.kie.ai}"
MAX_SECONDS="${KIE_POLL_MAX_SECONDS:-600}"
INTERVAL="${KIE_POLL_INTERVAL:-3}"

START=$(date +%s)
LAST_STATE=""

while true; do
    RESPONSE=$(curl -sS -X GET "${BASE_URL}${ENDPOINT}?taskId=${TASK_ID}" \
        -H "Authorization: Bearer ${KIE_API_KEY}") || {
        echo "Network error while polling" >&2
        sleep "$INTERVAL"
        continue
    }

    STATE=$(echo "$RESPONSE" | jq -r '.data.state // .data.status // .data.successFlag // empty' | tr '[:upper:]' '[:lower:]')

    case "$STATE" in
        success|succeed|succeeded|1)
            echo "$RESPONSE" | jq -c '.data'
            exit 0
            ;;
        fail|failed|error|2)
            REASON=$(echo "$RESPONSE" | jq -r '.data.failReason // .data.failMsg // .data.errorMessage // .msg // "unknown"')
            echo "Task failed: $REASON" >&2
            echo "Full response: $RESPONSE" >&2
            exit 5
            ;;
    esac

    if [ "$STATE" != "$LAST_STATE" ] && [ -n "$STATE" ]; then
        echo "  [state=$STATE, taskId=$TASK_ID]" >&2
        LAST_STATE="$STATE"
    fi

    NOW=$(date +%s)
    if [ $((NOW - START)) -gt "$MAX_SECONDS" ]; then
        echo "Timeout after ${MAX_SECONDS}s. Last state: ${STATE:-unknown}. taskId=$TASK_ID" >&2
        exit 6
    fi

    sleep "$INTERVAL"
done

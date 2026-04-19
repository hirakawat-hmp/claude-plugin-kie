#!/usr/bin/env bash
# call.sh — POST a JSON body to a kie.ai endpoint, return the taskId.
#
# Usage: call.sh <endpoint-path> <body-file>
# Example: call.sh /api/v1/jobs/createTask /tmp/req.json
#
# Auth: sources ~/.config/kie/env which must export KIE_API_KEY.
# Stdout on success: the taskId (string).
# Exit codes:
#   0 success
#   2 bad arguments
#   3 missing API key / env file
#   4 HTTP error or non-200 code in ApiResponse
#   5 taskId not found in response

set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <endpoint-path> <body-file>" >&2
    exit 2
fi

ENDPOINT="$1"
BODY_FILE="$2"

ENV_FILE="${KIE_ENV_FILE:-$HOME/.config/kie/env}"
if [ ! -f "$ENV_FILE" ]; then
    echo "Missing env file: $ENV_FILE" >&2
    echo "Create it with: echo 'export KIE_API_KEY=your_key' > $ENV_FILE && chmod 600 $ENV_FILE" >&2
    exit 3
fi
# shellcheck disable=SC1090
source "$ENV_FILE"

if [ -z "${KIE_API_KEY:-}" ]; then
    echo "KIE_API_KEY not set in $ENV_FILE" >&2
    exit 3
fi

if [ ! -f "$BODY_FILE" ]; then
    echo "Body file not found: $BODY_FILE" >&2
    exit 2
fi

BASE_URL="${KIE_BASE_URL:-https://api.kie.ai}"

RESPONSE=$(curl -sS -X POST "${BASE_URL}${ENDPOINT}" \
    -H "Authorization: Bearer ${KIE_API_KEY}" \
    -H "Content-Type: application/json" \
    --data @"${BODY_FILE}")

CODE=$(echo "$RESPONSE" | jq -r '.code // 0')
if [ "$CODE" != "200" ]; then
    MSG=$(echo "$RESPONSE" | jq -r '.msg // .message // "unknown error"')
    echo "API error (code=$CODE): $MSG" >&2
    echo "Full response: $RESPONSE" >&2
    exit 4
fi

TASK_ID=$(echo "$RESPONSE" | jq -r '.data.taskId // .data.task_id // .data.id // empty')
if [ -z "$TASK_ID" ]; then
    echo "No taskId in response: $RESPONSE" >&2
    exit 5
fi

echo "$TASK_ID"

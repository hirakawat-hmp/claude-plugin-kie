#!/usr/bin/env bash
# upload.sh — Upload a local file to kie.ai, return the public URL.
#
# Usage: upload.sh <file-path> [upload-path]
#
# Uses multipart stream upload (~33% more efficient than base64, per kie.ai docs).
# Uploaded files are temporary — auto-deleted after 3 days by kie.ai.
#
# Stdout on success: the public download URL (string).
# Exit codes:
#   0 success
#   2 bad arguments / file not found
#   3 missing API key / env file
#   4 HTTP error or non-200 ApiResponse
#   5 downloadUrl not found in response

set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <file-path> [upload-path]" >&2
    exit 2
fi

FILE_PATH="$1"
UPLOAD_PATH="${2:-uploads/kie-agent}"

if [ ! -f "$FILE_PATH" ]; then
    echo "File not found: $FILE_PATH" >&2
    exit 2
fi

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

UPLOAD_URL="${KIE_UPLOAD_URL:-https://kieai.redpandaai.co/api/file-stream-upload}"

RESPONSE=$(curl -sS -X POST "$UPLOAD_URL" \
    -H "Authorization: Bearer ${KIE_API_KEY}" \
    -F "file=@${FILE_PATH}" \
    -F "uploadPath=${UPLOAD_PATH}")

CODE=$(echo "$RESPONSE" | jq -r '.code // .success // 0')
if [ "$CODE" != "200" ] && [ "$CODE" != "true" ]; then
    MSG=$(echo "$RESPONSE" | jq -r '.msg // .message // "unknown error"')
    echo "Upload error (code=$CODE): $MSG" >&2
    echo "Full response: $RESPONSE" >&2
    exit 4
fi

DOWNLOAD_URL=$(echo "$RESPONSE" | jq -r '.data.downloadUrl // .data.url // .downloadUrl // empty')
if [ -z "$DOWNLOAD_URL" ]; then
    echo "No downloadUrl in response: $RESPONSE" >&2
    exit 5
fi

echo "$DOWNLOAD_URL"

#!/usr/bin/env bash
# query_graph.sh — Query the bundled kie.ai knowledge graph.
#
# Usage: query_graph.sh <question...> [--budget N] [--dfs] [--depth N]
#
# Runs scripts/query_graph.py under the Python environment of the
# `graphifyy` uv tool (which provides networkx). If graphifyy is not
# installed, this script attempts to install it once via `uv tool install`.
#
# Requires: uv (https://docs.astral.sh/uv/)
#
# Exit codes:
#   0 success
#   2 bad args / graph file missing
#   3 uv not installed
#   4 graphifyy install failed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY_SCRIPT="${SCRIPT_DIR}/query_graph.py"

if [ ! -f "$PY_SCRIPT" ]; then
    echo "error: query_graph.py not found at $PY_SCRIPT" >&2
    exit 2
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "error: uv not found in PATH." >&2
    echo "Install uv first: https://docs.astral.sh/uv/getting-started/installation/" >&2
    echo "Then run: uv tool install graphifyy" >&2
    exit 3
fi

# Locate graphifyy's python interpreter (installed via `uv tool install graphifyy`)
GRAPHIFYY_PY="${HOME}/.local/share/uv/tools/graphifyy/bin/python"
if [ ! -x "$GRAPHIFYY_PY" ]; then
    echo "graphifyy not installed. Installing via 'uv tool install graphifyy'..." >&2
    if ! uv tool install graphifyy >&2; then
        echo "error: failed to install graphifyy" >&2
        exit 4
    fi
fi

if [ ! -x "$GRAPHIFYY_PY" ]; then
    echo "error: graphifyy python not found at $GRAPHIFYY_PY after install" >&2
    exit 4
fi

exec "$GRAPHIFYY_PY" "$PY_SCRIPT" "$@"

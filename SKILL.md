---
name: kie
description: Generate music / video / image / audio via kie.ai API. Claude reads bundled model docs and dispatches the right request.
---

# /kie

**WIP.** This skill is a stub — the dispatch logic is not implemented yet.

## Planned usage

```
/kie "natural language description of what to generate"
/kie --model <model-id> "<prompt>"
/kie list                    # show available models
/kie refresh-docs            # re-crawl docs.kie.ai and rebuild the knowledge graph
```

## Planned flow

1. Parse user intent.
2. Query `graph/graph.json` to find the best matching endpoint, or filter by `--model`.
3. Read the specific doc under `docs/` for that endpoint (OpenAPI YAML inside markdown).
4. Build the request body from the schema.
5. Call `scripts/call.sh <endpoint> <body-json>` → `taskId`.
6. Call `scripts/poll.sh <taskId>` → final result URL.
7. Return the URL to the user.

## API key

Scripts `source ~/.config/kie/env` which must export `KIE_API_KEY`. The key is never handled by Claude directly.

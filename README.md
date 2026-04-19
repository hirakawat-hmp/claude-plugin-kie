# claude-plugin-kie

Claude Code skill for [kie.ai](https://kie.ai) — a unified API platform for AI models (Suno, Runway, Veo3, Flux, Ideogram, ElevenLabs, Claude, Gemini, GPT-5, Kling, Wan, Sora2, and more).

## What it does

Lets you generate music, video, images, and audio via kie.ai's API from inside Claude Code, without hand-writing HTTP requests. Claude reads the appropriate model's documentation (bundled as a knowledge graph) and builds the right request for you.

```
/kie "2分のジャズBGM、明るい雰囲気"      → Suno でmusic生成
/kie "夕焼けの海辺を歩く人、5秒"         → Runway で動画生成
/kie "サイバーパンク都市の夜景"          → Flux で画像生成
```

## How it works

1. **Bundled documentation** (`docs/`) — a snapshot of [docs.kie.ai](https://docs.kie.ai) (194 markdown files) covering every model's OpenAPI schema.
2. **Pre-built knowledge graph** (`graph/graph.json`) — a NetworkX graph generated via [graphify](https://github.com/safishamsi/graphify) that encodes relationships between endpoints, parameters, models, and shared schemas. Enables ~69x token-efficient lookups.
3. **Shared runtime scripts** (`scripts/`) — auth, `createTask` POST, `recordInfo` polling, file upload. All models share these because kie.ai normalizes responses into a single `ApiResponse` schema.
4. **Claude as dispatcher** — given your natural-language intent, Claude queries the graph to find the right model, reads the specific endpoint doc, builds the request body, and calls the shared scripts.

## Setup

### 1. Install graphify (optional — only needed to refresh the graph)

```bash
uv tool install graphifyy
```

### 2. Store your kie.ai API key outside the plugin

```bash
mkdir -p ~/.config/kie
echo 'export KIE_API_KEY=your_key_here' > ~/.config/kie/env
chmod 600 ~/.config/kie/env
```

The plugin's scripts `source` this file — the API key is never committed to the repo.

### 3. Clone the plugin

```bash
git clone git@github.com:hirakawat-hmp/claude-plugin-kie.git ~/.claude/plugins/kie
```

_(Plugin registration details TBD — this is a work in progress.)_

## Refreshing the documentation

kie.ai adds new models frequently. To refresh the bundled docs and rebuild the knowledge graph:

```bash
/kie refresh-docs
```

## Design notes

See `reports/api-response-schema-analysis.md` for analysis of why kie.ai's unified `ApiResponse` schema makes this plugin architecture possible with shared runtime code.

## Status

Work in progress. See `SKILL.md` for the current Skill specification.

## License

MIT

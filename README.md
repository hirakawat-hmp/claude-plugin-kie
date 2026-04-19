# claude-plugin-kie

A Claude Code plugin that installs a **kie.ai concierge agent**. When the conversation naturally arrives at "let's generate this with kie.ai", Claude delegates to this specialist — it recommends models, checks credits, builds the request from bundled docs, calls the API, and returns the result.

[kie.ai](https://kie.ai) is a unified API platform for 100+ AI models: Suno (music), Runway/Veo3/Kling/Wan/Sora2 (video), Flux/Ideogram/Seedream (image), ElevenLabs (audio), Claude/Gemini/GPT-5 (chat), and more.

## How it works

This plugin is **not** a slash command. It installs a specialist subagent (`kie-agent`) that Claude delegates to when appropriate:

```
User: "この動画にBGMほしいな"
Claude: "kie.aiで作れますね、候補を確認します"
  └─ (internally: Claude → kie-agent "suggest models for BGM")
Claude: "Suno V5 と ElevenLabs sound-effect があります…"

User: "Sunoで、2分、ジャズ系、歌詞なし"
Claude: "残クレジット確認しますね"
  └─ (internally: Claude → kie-agent "check credits")
Claude: "5,243 credits 残っています。実行していい？"

User: "うん"
  └─ (internally: Claude → kie-agent "execute Suno generate-music with ...")
Claude: "生成完了: https://..."
```

## What's inside

```
claude-plugin-kie/
├── .claude-plugin/plugin.json  # plugin manifest
├── agents/kie-agent.md          # the concierge subagent
├── scripts/                     # shared runtime
│   ├── call.sh                  # POST /api/v1/jobs/createTask
│   ├── poll.sh                  # poll recordInfo until done
│   ├── upload.sh                # file upload helper
│   ├── query_graph.sh           # query knowledge graph (wrapper)
│   └── query_graph.py           # NetworkX-based BFS/DFS over graph.json
├── docs/                        # snapshot of docs.kie.ai (194 markdown files)
├── graph/                       # pre-built knowledge graph via graphify
│   ├── graph.json               # 1,107 nodes / 1,341 edges
│   └── GRAPH_REPORT.md
└── reports/                     # architecture analysis
```

## Why bundle docs + graph?

kie.ai adds new models frequently. The bundled `docs/` is a pinned snapshot, and `graph/graph.json` is a pre-computed knowledge graph (via [graphify](https://github.com/safishamsi/graphify)) that lets the agent find the right endpoint ~69x more token-efficiently than reading raw docs.

See `reports/api-response-schema-analysis.md` for why kie.ai's unified `ApiResponse` schema enables shared runtime scripts across all 100+ models.

## Setup

### 1. Install prerequisites

- **`uv`** — required for the graph query helper to auto-install its Python dependency (graphifyy/networkx). See [uv installation guide](https://docs.astral.sh/uv/getting-started/installation/).
- **`jq`** and **`curl`** — used by the runtime scripts for API calls and JSON parsing.

On first use, `scripts/query_graph.sh` will auto-run `uv tool install graphifyy` if graphifyy is missing. No manual step required.

### 2. Install the plugin in Claude Code

```
/plugin marketplace add https://github.com/hirakawat-hmp/claude-plugin-kie
/plugin install kie@claude-plugin-kie
/reload-plugins
```

### 3. Store your kie.ai API key outside the plugin

```bash
mkdir -p ~/.config/kie
echo 'export KIE_API_KEY=your_key_here' > ~/.config/kie/env
chmod 600 ~/.config/kie/env
```

The agent's scripts `source` this file — the API key never enters the Claude context and is never committed to the repo.

## Refreshing the documentation

kie.ai adds new models frequently. To refresh the bundled docs and rebuild the knowledge graph, the agent includes a `refresh-docs` procedure (TBD — likely triggered by explicit user request like "kie.aiのドキュメント更新して").

## Status

**Work in progress.** Current state:
- ✅ Docs snapshot (194 files) bundled
- ✅ Knowledge graph built
- ⏳ `agents/kie-agent.md` (implementation)
- ⏳ `scripts/call.sh` and `scripts/poll.sh`
- ⏳ End-to-end testing

## License

MIT

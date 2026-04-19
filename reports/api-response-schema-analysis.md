# kie.ai の設計思想 — `ApiResponse schema` が示す「全モデル横断の統一レスポンス」

**生成日**: 2026-04-20
**ソース**: `~/kie-docs/graphify-out/graph.json` (194ドキュメント / 1,107ノード / 1,341エッジ)
**問い**: なぜ `ApiResponse schema` が Wan / Ideogram / ElevenLabs を跨ぐブリッジになっているのか？

---

## 結論

kie.ai は、**内部で動かすAIモデルが何であっても（Wan, Suno, Runway, Veo3, Kling, Ideogram, ElevenLabs, Claude, Gemini, GPT-5...）、レスポンス形式を1つの `ApiResponse schema` に統一する**という設計を貫いている。これがグラフ上で「異なるモデル群のコミュニティを繋ぐブリッジノード」として現れる理由。

`ApiResponse schema` はドキュメント上の重複記述ではなく、**プラットフォーム全体の契約（contract）**として機能している。

---

## グラフ上の証拠

### 1. 中心ノード `ApiResponse schema` の接続範囲

- **単一のハブノード** (`common_schema_apiresponse`): degree = 20
- **接続先**: 9つの異なるコミュニティに跨る35種類のオペレーション
- **媒介中心性 (betweenness centrality)**: 0.050 — グラフ全体で最上位クラスのブリッジ

### 2. `returns` 関係の集中度

| Source ノード | `returns` エッジ数 | 意味 |
|---|---:|---|
| `ApiResponse schema` | 20 | 全モデルの createTask 応答 |
| `GET /api/v1/veo/record-info` | 5 | Veo3 のポーリング応答 |
| `ApiResponseWithRecordId schema` | 5 | record_id 付き応答 |
| `GET /api/v1/runway/record-detail` | 3 | Runway のポーリング応答 |
| `GET /api/v1/generate/record-info` | 3 | Suno のポーリング応答 |

→ グラフ内の全 `returns` 関係77件のうち**26件（約34%）が `ApiResponse` 系の2ノードに集中**している。

### 3. 跨ぐコミュニティ

`ApiResponse schema` が直接接続するコミュニティ：

| Community | ラベル | 接続オペレーション数 |
|---:|---|---:|
| 0 | Wan Video Models | 16 |
| 1 | Ideogram & ElevenLabs | 8 |
| 7 | Flux-2 & Kling Avatar | 4 |
| 10 | Gemini & Kling Standard | 2 |
| 6 | Seedream & Recraft Images | 1 |
| 8 | Qwen2 Image Generation | 1 |
| 9 | Claude Chat Models | 1 |
| 3 | Kling Motion Control | 1 |
| 17 | Ideogram V3 Remix | 1 |

→ 9/19コミュニティ、つまり**グラフの約半分の領域に手が届いている**。

### 4. 共通フィールドの波及

ApiResponse を構成するフィールドのうち、特に `taskId` は14の異なるエンドポイントのレスポンスに出現する。これは単なるスキーマ定義の重複ではなく、**「非同期タスクIDを必ず返す」という設計契約の現れ**。

---

## 設計上の含意

### a. 統一レスポンスは kie.ai の「最も安定した地層」

各AIプロバイダ（OpenAI, Anthropic, Google, ByteDance, ElevenLabs, Suno...）はそれぞれ独自のレスポンス形式を持つが、kie.ai はそれを**一切通さず**、内部で正規化して：

```json
{
  "code": 200,
  "msg": "success",
  "data": { "taskId": "task_xxx_123456" }
}
```

という形で返す。モデルが増えても、壊れても、差し替わっても、この契約は変わらない。

### b. 「非同期 + taskId + recordInfo」の三位一体

グラフを見ると、ほぼ全てのモデルで同じパターンが繰り返されている：

1. `POST /api/v1/jobs/createTask` → `ApiResponse schema` を返す（`taskId` を含む）
2. クライアントは `taskId` を保持してポーリング
3. `GET /api/v1/jobs/recordInfo` → `ApiResponseWithRecordId schema` を返す（`progress`, `resultJson`）

モデルに依存する差分は `input` オブジェクトの中だけに閉じ込められている。

### c. クライアント実装への含意

この統一性が意味することは：

- **1つのクライアントラッパーで全モデルを扱える**（`ApiResponse` のパースロジックを1箇所に書けば済む）
- **モデルの差し替えが trivial**（`model` フィールドと `input` の中身だけ変えればいい）
- **エラーハンドリングを共通化できる**（`code != 200` を一括処理）

---

## Skill設計への反映

このグラフが示す設計を、今後作る `/kie` Skillに活かすなら：

1. **共通レイヤ**: `ApiResponse` パーサ、`taskId` → `recordInfo` ポーリングループ、認証ヘッダー、エラーマッピングは**一度だけ書いて全モデル共用**
2. **モデル固有レイヤ**: 各モデルドキュメントから `input` スキーマだけを動的に取得（Glob `~/kie-docs/market/**/*.md` → 該当ファイル特定 → OpenAPI YAML をパース → リクエスト組み立て）
3. **実装ファイル構成案**:

    ```
    ~/.claude/skills/kie/
    ├── SKILL.md               # スラッシュコマンド定義
    └── scripts/
        ├── common.sh          # ApiResponse/taskId/poll/auth — ここが再利用される
        └── dispatch.sh        # docs/ から YAML 読んで input 組み立て
    ```

グラフ上のブリッジノード構造が、そのまま**コード上の共通モジュール境界**と一致する。

---

## 派生する追加の問い

このレポートを作る過程で浮かんだ、さらに掘れそうな問い：

- **818の弱接続ノード**は何を意味するか？ドキュメント内のクロスリファレンス欠落？単純な孤立語？
- `BearerAuth (API Key)` が3つの別コミュニティ (Kling Motion / Gemini / Seedream) を繋ぐのも類似パターン。**認証もまた統一契約**であることの証左か？
- Suno API だけは `ApiResponse` を経由せず `Suno API` ノード自身が hub になっている（degree=38）。**Sunoは独自のレスポンス設計を持つのか？** それとも単に抽出時の粒度の違いか？

---

**生成元**: `/graphify ~/kie-docs` の出力 + ネットワーク探索
**再現方法**: `graphify-out/graph.json` を NetworkX で読み込み、`ApiResponse` 系ノードから2-hop BFS + `returns` 関係のドメイン集計

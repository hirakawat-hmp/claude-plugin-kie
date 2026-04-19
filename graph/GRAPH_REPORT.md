# Graph Report - /home/reibniz/kie-docs  (2026-04-20)

## Corpus Check
- 194 files · ~253,036 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1107 nodes · 1341 edges · 19 communities detected
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 49 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Wan Video Models|Wan Video Models]]
- [[_COMMUNITY_Ideogram & ElevenLabs|Ideogram & ElevenLabs]]
- [[_COMMUNITY_Suno Audio Callbacks|Suno Audio Callbacks]]
- [[_COMMUNITY_Kling Motion Control|Kling Motion Control]]
- [[_COMMUNITY_Suno Vocals & Music|Suno Vocals & Music]]
- [[_COMMUNITY_Common API & Auth|Common API & Auth]]
- [[_COMMUNITY_Seedream & Recraft Images|Seedream & Recraft Images]]
- [[_COMMUNITY_Flux-2 & Kling Avatar|Flux-2 & Kling Avatar]]
- [[_COMMUNITY_Qwen2 Image Generation|Qwen2 Image Generation]]
- [[_COMMUNITY_Claude Chat Models|Claude Chat Models]]
- [[_COMMUNITY_Gemini & Kling Standard|Gemini & Kling Standard]]
- [[_COMMUNITY_Wan Speech-to-Video|Wan Speech-to-Video]]
- [[_COMMUNITY_Suno Task Details|Suno Task Details]]
- [[_COMMUNITY_Runway Aleph Video|Runway Aleph Video]]
- [[_COMMUNITY_GPT Codex Models|GPT Codex Models]]
- [[_COMMUNITY_Flux Kontext Callbacks|Flux Kontext Callbacks]]
- [[_COMMUNITY_Wan Video Edit|Wan Video Edit]]
- [[_COMMUNITY_Ideogram V3 Remix|Ideogram V3 Remix]]
- [[_COMMUNITY_Flux Callback Mechanism|Flux Callback Mechanism]]

## God Nodes (most connected - your core abstractions)
1. `Suno API` - 38 edges
2. `GET /api/v1/jobs/recordInfo (Get Task Details)` - 29 edges
3. `POST /api/v1/jobs/createTask` - 23 edges
4. `BearerAuth (Bearer API Key)` - 22 edges
5. `BearerAuth (API Key)` - 21 edges
6. `ApiResponse schema` - 20 edges
7. `POST /api/v1/veo/generate` - 19 edges
8. `POST /api/v1/jobs/createTask` - 17 edges
9. `Wan 2.7 Image operation` - 17 edges
10. `POST /api/v1/generate/extend` - 17 edges

## Surprising Connections (you probably didn't know these)
- `Runway API` --part_of--> `KIE API Platform`  [INFERRED]
  /home/reibniz/kie-docs/runway-api/quickstart.md → /home/reibniz/kie-docs/1973359m0.md
- `POST /api/v1/jobs/createTask (Qwen2 Text To Image EN)` --translation_of--> `POST /api/v1/jobs/createTask (Qwen2 文生图)`  [INFERRED]
  /home/reibniz/kie-docs/30861522e0.md → /home/reibniz/kie-docs/30861823e0.md
- `CallbackUrl schema` --defines--> `callBackUrl`  [INFERRED]
  /home/reibniz/kie-docs/market/wan/2-7-image.md → /home/reibniz/kie-docs/market/qwen2/image-edit.md
- `POST /api/v1/generate/add-vocals` --belongs_to_api--> `Suno API`  [INFERRED]
  /home/reibniz/kie-docs/suno-api/add-vocals.md → /home/reibniz/kie-docs/suno-api/quickstart.md
- `Veo 3.1 API` --part_of--> `KIE API Platform`  [INFERRED]
  /home/reibniz/kie-docs/veo3-api/quickstart.md → /home/reibniz/kie-docs/1973359m0.md

## Communities

### Community 0 - "Wan Video Models"
Cohesion: 0.02
Nodes (157): wan/2-2-a14b-image-to-video-turbo, Wan 2.2 A14B Image to Video Turbo operation, acceleration, enable_prompt_expansion, image_url, prompt, resolution, seed (+149 more)

### Community 1 - "Ideogram & ElevenLabs"
Cohesion: 0.02
Nodes (133): Model: elevenlabs/audio-isolation, elevenlabs/audio-isolation, audio_url, Model: ideogram/character, Ideogram - Character, prompt, reference_image_urls, Model: ideogram/character-edit (+125 more)

### Community 2 - "Suno Audio Callbacks"
Cohesion: 0.02
Nodes (110): Add Instrumental Callbacks, Add Instrumental to Music, callBackUrl, model, negativeTags, tags, title, uploadUrl (+102 more)

### Community 3 - "Kling Motion Control"
Cohesion: 0.02
Nodes (94): BearerAuth (API Key), POST /api/v1/jobs/createTask (Kling 2.6 motion-control), kling-2.6/motion-control, character_orientation, input_urls, mode, prompt, video_urls (+86 more)

### Community 4 - "Suno Vocals & Music"
Cohesion: 0.03
Nodes (89): Add Vocals to Music, POST /api/v1/generate/add-vocals, audioWeight, callBackUrl, model (V4_5PLUS/V5/V5_5), negativeTags, prompt, style (+81 more)

### Community 5 - "Common API & Auth"
Cohesion: 0.03
Nodes (80): https://api.kie.ai (base URL), BearerAuth (API Key), Common API Quickstart, 20-minute link validity, POST /api/v1/common/download-url, download-url, url (request body param), GET /api/v1/chat/credit (+72 more)

### Community 6 - "Seedream & Recraft Images"
Cohesion: 0.03
Nodes (79): POST /api/v1/jobs/createTask (Seedream4.5 Edit), seedream/4.5-edit, POST /api/v1/jobs/createTask (Seedream4.5 Text to Image), seedream/4.5-text-to-image, POST /api/v1/jobs/createTask (Seedream5.0 Lite Text to Image), seedream/5-lite-text-to-image, POST /api/v1/jobs/createTask (Recraft Crisp Upscale), recraft/crisp-upscale (+71 more)

### Community 7 - "Flux-2 & Kling Avatar"
Cohesion: 0.03
Nodes (70): POST /api/v1/jobs/createTask (Kling AI Avatar Pro), kling/ai-avatar-pro, input.audio_url, input.image_url, input.prompt, POST /api/v1/jobs/createTask (Flux-2 flex image-to-image), flux-2/flex-image-to-image, input.aspect_ratio (+62 more)

### Community 8 - "Qwen2 Image Generation"
Cohesion: 0.04
Nodes (69): Getting Started with KIE API, POST /api/v1/jobs/createTask (Qwen2 Text To Image EN), callBackUrl, POST /api/v1/jobs/createTask (Qwen2 文生图), image_size (1:1,3:4,4:3,9:16,16:9), input (prompt,image_size,seed,output_format,nsfw_checker), model (qwen2/image-edit), nsfw_checker (+61 more)

### Community 9 - "Claude Chat Models"
Cohesion: 0.04
Nodes (56): POST /claude/v1/messages (Claude Haiku 4.5), claude-haiku-4-5, messages, stream, tools, POST /claude/v1/messages (Claude Opus 4.5), claude-opus-4-5, messages (+48 more)

### Community 10 - "Gemini & Kling Standard"
Cohesion: 0.04
Nodes (45): POST /api/v1/jobs/createTask (Kling AI Avatar Standard), kling/ai-avatar-standard, audio_url, callBackUrl, image_url, prompt, ApiResponse schema, https://api.kie.ai (+37 more)

### Community 11 - "Wan Speech-to-Video"
Cohesion: 0.08
Nodes (24): wan/2-2-a14b-speech-to-video-turbo, Wan 2.2 A14B Speech to Video Turbo operation, audio_url, frames_per_second (4-60), guidance_scale (1-10), image_url, negative_prompt, num_frames (40-120, step 4) (+16 more)

### Community 12 - "Suno Task Details"
Cohesion: 0.09
Nodes (22): Music Generation Callbacks, Get Music Task Details, GET /api/v1/generate/record-info, callbackType: complete, callbackType: error, callbackType: first, callbackType: text, operationType (generate/extend/upload_cover/upload_extend) (+14 more)

### Community 13 - "Runway Aleph Video"
Cohesion: 0.14
Nodes (21): aspectRatio (Aleph 16:9,9:16,4:3,3:4,1:1,21:9), referenceImage (Aleph), seed (Aleph), uploadCn (boolean), videoUrl (Aleph input), Runway Aleph Video Generation Callbacks, POST /api/v1/aleph/generate, Runway API (+13 more)

### Community 14 - "GPT Codex Models"
Cohesion: 0.13
Nodes (16): BearerAuth (API Key), POST /api/v1/responses (GPT Codex), gpt-5.1-codex, gpt-5.2-codex, gpt-5.3-codex, gpt-5.4-codex, gpt-5-codex, input (+8 more)

### Community 15 - "Flux Kontext Callbacks"
Cohesion: 0.12
Nodes (16): code (status), data.info.originImageUrl, data.info.resultImageUrl, data.taskId, callBackUrl, Flux Image Generation/Editing Callbacks, Flux Kontext API, https://api.kie.ai (+8 more)

### Community 16 - "Wan Video Edit"
Cohesion: 0.15
Nodes (13): wan/2-7-videoedit, Wan 2.7 - Video Edit operation, aspect_ratio, audio_setting (auto/origin), duration (0/2-10), negative_prompt, prompt, prompt_extend (+5 more)

### Community 17 - "Ideogram V3 Remix"
Cohesion: 0.17
Nodes (12): Model: ideogram/v3-remix, Ideogram V3 Remix, expand_prompt, image_size, image_url, negative_prompt, num_images, prompt (max 5000) (+4 more)

### Community 18 - "Flux Callback Mechanism"
Cohesion: 1.0
Nodes (1): Flux Image Callback Mechanism

## Knowledge Gaps
- **818 isolated node(s):** `https://api.kie.ai`, `https://kieai.redpandaai.co`, `ApiResponse schema (code/msg/data)`, `model (qwen2/image-edit)`, `callBackUrl` (+813 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Flux Callback Mechanism`** (1 nodes): `Flux Image Callback Mechanism`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ApiResponse schema` connect `Wan Video Models` to `Ideogram & ElevenLabs`, `Ideogram V3 Remix`?**
  _High betweenness centrality (0.050) - this node is a cross-community bridge._
- **Why does `Suno API` connect `Suno Audio Callbacks` to `Suno Vocals & Music`, `Suno Task Details`, `Flux Kontext Callbacks`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Why does `BearerAuth (API Key)` connect `Kling Motion Control` to `Gemini & Kling Standard`, `Seedream & Recraft Images`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **What connects `https://api.kie.ai`, `https://kieai.redpandaai.co`, `ApiResponse schema (code/msg/data)` to the rest of the system?**
  _818 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Wan Video Models` be split into smaller, more focused modules?**
  _Cohesion score 0.02 - nodes in this community are weakly interconnected._
- **Should `Ideogram & ElevenLabs` be split into smaller, more focused modules?**
  _Cohesion score 0.02 - nodes in this community are weakly interconnected._
- **Should `Suno Audio Callbacks` be split into smaller, more focused modules?**
  _Cohesion score 0.02 - nodes in this community are weakly interconnected._
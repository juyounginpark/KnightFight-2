# Agent instructions

## KnightFighter2 open-source tools

- Before map, character, sprite, VFX or platformer work, read `docs/OPEN_SOURCE_TOOLS.ko.md` and use the relevant installed tool.
- The single reference document is `docs/OPEN_SOURCE_TOOLS.ko.md`; keep installation status, commands and validation results there current when changing tools.
- Run tools from the project root through `powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 <Tool> ...`. See the guide for the supported names.
- `tools/` contains local third-party checkouts and applications and is excluded from Godot importing and game source control. Keep editable game inputs in `art/` and approved exports in `assets/`.
- Gaea and SpriteKiln integrations are installed under `addons/`. LDtk and Ogmo are external editors; their Godot level importers are not implemented yet.
- Apply the generated SpriteKiln instructions below when using SpriteKiln; use Pixelbolt or pixelfx directly when those tools fit the requested asset.
- Preserve upstream license notices. SpriteKiln showcase characters with reserved rights are references only; use its CC0 templates/examples or original specs for production.
- The SpriteKiln pose under `tools/verification/` is only an installation check. No game art style has been approved; `spritekiln.toml` defaults are provisional.

<!-- spritekiln:begin (generated from docs/agent by spritekiln; edit the sources, not this block) -->
## SpriteKiln assets
Sprites in this project are made with SpriteKiln: a YAML spec (skeleton, SDF primitives, materials, palette,
animations) is rendered into animated 8-direction pixel art (atlas + JSON + normal/emissive maps).

Read before working on an asset: `.spritekiln/agent/workflow.md` (commands and the working loop), `.spritekiln/agent/style.md` (the
project's art style) and `.spritekiln/agent/spec.md` (the spec format). Then, as needed: `.spritekiln/agent/modeling.md`,
`.spritekiln/agent/splash-to-model.md`, `.spritekiln/agent/animation.md`, `.spritekiln/agent/art-direction.md` and `.spritekiln/agent/recipe.md` (the modeler → art
director → animator recipe).

Rules that matter:
- Art style first: run `spritekiln style` before the first asset of a session. If no style is recorded,
  interview the user with the questions of `.spritekiln/agent/style.md` and record the answers before generating
  anything. Follow the recorded style in every asset; change it only when the user explicitly asks.
- Run `spritekiln validate <spec>` after every edit; problems come with file:line:column.
- Iterate with `spritekiln pose <spec> --dirs all` (about 1 s per direction); `spritekiln render` only at the end.
- A character's head and hair are decided in its `brief.head` and judged up close with
  `spritekiln pose <spec> --focus head --dirs all`: on a normal preview a face is a few pixels.
- Never call something visual good without looking at the PNG. If you cannot see images, use the numbers of
  `spritekiln review` (value, contrast, pixels per material, IoU) and `qa.json`.
- Keep the camera pitch, light and `camera.scale` shared by every asset of the game.
- Outputs under `out/` are generated: never edit them.
- `spritekiln export <spec>` hands a render to the engine configured in `spritekiln.toml`.
- With an MCP client, `spritekiln mcp` serves these operations as tools that return images and JSON.
<!-- spritekiln:end -->

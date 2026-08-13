# Belt Models & Execution (Asset Generation/Editing)

Generate and edit images via the [inference.sh](https://inference.sh) CLI (`belt`). This is the asset-generation role: any role's gate rules and the shared quality gates in `quality.md` still apply.

## Setup

- `belt` must already be on PATH. If missing, report and stop — no silent install.
- Authenticate once, never silently: `belt login` (device flow; non-interactive: `belt login --key <API_KEY>`, `--no-input` for CI).
- Generation is remote and paid: use `belt app run --estimate` to show predicted cost before running when the user has not authorized spend.

## Catalog discovery (always dynamic)

The app catalog changes frequently. Never rely on a static list — browse the installed catalog:

```bash
belt app list --category image      # image apps
belt app list                       # all apps
```

Pick the app by task (quality/text rendering vs. speed/cost vs. editing) from the live list.

## Run examples

```bash
# Text-to-image
belt app run openai/gpt-image-2 --input '{
  "prompt": "professional product photo of sneakers, studio lighting",
  "quality": "high"
}'

# Editing (pass reference image URLs)
belt app run openai/gpt-image-2 --input '{
  "prompt": "change the background to a beach at sunset",
  "images": ["https://your-image.jpg"]
}'

# Upscaling
belt app run falai/topaz-image-upscaler --input '{"image_url": "https://..."}'

# Save result and preview cost
belt app run <app-id> --input '{"prompt": "..."}' --save result.json --estimate
```

## Deep dives

- Running apps: https://inference.sh/docs/apps/running
- Image generation guide: https://inference.sh/docs/examples/image-generation
- Optional platform skills: `npx skills add inference-sh/skills@gpt-image`, `@flux-image`, `@image-upscaling`

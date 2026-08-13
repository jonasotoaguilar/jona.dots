# jona.dots

Personal development environment — terminal-first, AI-agent-oriented dotfiles.

This repo is my daily driver as a developer: a coherent setup where the shell,
the terminal, the editor, and the coding agents all speak the same language. It
is designed to be used by humans and AI agents alike, with shared conventions,
discoverable skills, and no hidden magic.

## Components

| Directory   | What it is                                                       |
| ----------- | ---------------------------------------------------------------- |
| `fish/`     | Fish shell configuration: prompt, completions, functions, themes |
| `ghostty/`  | Ghostty terminal config with GLSL shaders                        |
| `git/`      | Global Git configuration and defaults                            |
| `herdr/`    | herdr (agentic terminal) setup: keybindings, plugins, UI theme   |
| `nvim/`     | Neovim (LazyVim) config: editor plugins, keymaps, integrations   |
| `opencode/` | OpenCode config: agents, slash commands, helper scripts          |
| `skills/`   | Agent skill library for code, reviews, CI/CD, docs and more      |
| `.atl/`     | Skill registry index used by agents to resolve skills by name    |

## Highlights

- **Shell-first workflow**: Fish with curated completions and functions, plus
  secret loading via `local.secrets.example.fish` as the template.
- **Terminal as IDE**: herdr keybindings turn the terminal into a multiplexer
  with an nvim popup, lazygit sidebar, file picker, and agent panes.
- **AI-native editor**: Neovim wired for AI workflows (CodeCompanion, Obsidian,
  DAP) and OpenCode with a tailored `general` agent and project commands.
- **Skill-driven agents**: `skills/` plus `.atl/skill-registry.md` make agent
  capabilities discoverable and versioned alongside the setup.

## Structure

The repo is organized so each tool owns its directory. Configs are generic
enough to be portable; anything environment-specific lives in per-tool
`local.*` files that are ignored by default.

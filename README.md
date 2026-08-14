# jona.dots

Personal development environment — terminal-first, AI-agent-oriented dotfiles.

This repo is my daily driver as a developer: a coherent setup where the shell,
the terminal, the editor, and the coding agents all speak the same language. It
is designed to be used by humans and AI agents alike, with shared conventions,
discoverable skills, and no hidden magic. AI workflows are orchestrated by
[Gentle AI](https://github.com/Gentleman-Programming/gentle-ai), the ecosystem
configurator behind the persistent memory, SDD workflow, skill registry, and
bounded native review used in this setup.

## Components

| Directory   | What it is                                                       |
| ----------- | ---------------------------------------------------------------- |
| `fish/`     | Fish shell configuration: prompt, completions, functions, themes |
| `ghostty/`  | Ghostty terminal config with GLSL shaders                        |
| `git/`      | Global Git configuration and defaults                            |
| `herdr/`    | herdr (agentic terminal) setup: keybindings, plugins, UI theme   |
| `nvim/`     | Neovim (LazyVim) config: editor plugins, keymaps, integrations   |
| `opencode/` | OpenCode config: agents, slash commands, helper scripts          |
| `skills/`   | Gentle AI skill library for code, reviews, CI/CD, docs and more  |
| `.atl/`     | Gentle AI skill registry index used by agents to resolve skills  |

## Highlights

- **Shell-first workflow**: Fish with curated completions and functions, plus
  secret loading via `local.secrets.example.fish` as the template.
- **Terminal as IDE**: herdr keybindings turn the terminal into a multiplexer
  with an nvim popup, lazygit sidebar, file picker, and agent panes.
- **AI-native editor**: Neovim wired for AI workflows (CodeCompanion, Obsidian,
  DAP) and OpenCode with a tailored `general` agent and project commands.
- **Gentle AI orchestration**: Spec-Driven Development with the
  `gentle-orchestrator`, Engram persistent memory across sessions, bounded
  native review (receipt-driven development), and MCP wiring for the agents in
  use.
- **Skill-driven agents**: `skills/` plus `.atl/skill-registry.md` make agent
  capabilities discoverable and versioned alongside the setup.

## Structure

The repo is organized so each tool owns its directory. Configs are generic
enough to be portable; anything environment-specific lives in per-tool
`local.*` files that are ignored by default.

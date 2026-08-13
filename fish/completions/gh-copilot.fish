# fish completions for gh copilot
# Delegates to the standalone copilot binary completions

# Subcommands (when no subcommand of copilot is seen yet)
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'login' -d 'Authenticate with Copilot'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'help' -d 'Display help information'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'init' -d 'Initialize Copilot instructions'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'update' -d 'Download the latest version'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'version' -d 'Display version information'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'plugin' -d 'Manage plugins'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'mcp' -d 'Manage MCP servers'
complete -c gh -n '__fish_seen_subcommand_from copilot; and not __fish_seen_subcommand_from login help init update version plugin mcp completion' \
    -f -a 'completion' -d 'Generate a shell completion script'

# Flags (always available under copilot)
complete -c gh -n '__fish_seen_subcommand_from copilot' -l version -s v -f -d 'Show version information'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l interactive -s i -r -d 'Start interactive mode with this prompt'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l prompt -s p -r -d 'Execute a prompt in non-interactive mode'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l silent -s s -f -d 'Output only the agent response'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l model -r -d 'Set the AI model to use'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l effort -l reasoning-effort -r -d 'Set reasoning effort level' -a 'low medium high xhigh'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l agent -r -d 'Specify a custom agent to use'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l resume -r -d 'Resume from a previous session'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l continue -f -d 'Resume the most recent session'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l name -s n -r -d 'Set a name for the new session'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l allow-all-tools -f -d 'Allow all tools without confirmation'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l allow-all-paths -f -d 'Allow access to any path'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l yolo -f -d 'Enable all permissions'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l autopilot -f -d 'Start in autopilot mode'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l plan -f -d 'Start in plan mode'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l no-color -f -d 'Disable all color output'
complete -c gh -n '__fish_seen_subcommand_from copilot' -s C -r -d 'Change working directory'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l mode -r -d 'Set the initial agent mode' -a 'interactive plan autopilot'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l allow-tool -r -d 'Tools the CLI has permission to use'
complete -c gh -n '__fish_seen_subcommand_from copilot' -l remote -f -d 'Enable remote control from GitHub web and mobile'

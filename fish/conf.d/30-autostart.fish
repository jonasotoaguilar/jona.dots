# -----------------------------------------------------
# AUTOSTART
# -----------------------------------------------------

# -----------------------------------------------------
# Herdr
# -----------------------------------------------------
if status is-interactive
    if test "$TERM_PROGRAM" = "ghostty"
        if not set -q HERDR_ENV; and not set -q TMUX; and not set -q ZELLIJ; and command -q herdr
            herdr; or echo "⚠️  Herdr failed to start; continuing in Fish."
        end
    end
end

# -----------------------------------------------------
# Fastfetch
# -----------------------------------------------------
if status is-interactive
    if command -sq fastfetch; and not set -q TMUX; and not set -q HERDR_ENV; and not set -q ZELLIJ
        fastfetch
    end
end

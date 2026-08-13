# -----------------------------------------------------
# INIT
# -----------------------------------------------------

set -g fish_greeting ""

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path --global /usr/lib/ccache/bin
fish_add_path --global $HOME/.cargo/bin
fish_add_path --global $HOME/go/bin
fish_add_path --global $HOME/.local/bin

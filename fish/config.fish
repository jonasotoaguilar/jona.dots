# Intencionalmente mínimo.
# La configuración modular vive en conf.d/*.fish.

# npm global
fish_add_path /home/jona/.npm-global/bin

# opencode
fish_add_path /home/jona/.opencode/bin

# pnpm
set -gx PNPM_HOME "/home/jona/.local/share/pnpm"
fish_add_path $PNPM_HOME

# seguridad via npq (npm + pnpm): auditoría pre-install (avisa, auto-continue 15s)
# npq@3.25.0 gestionado por npm global (~/.npm-global/bin)
# Ruta absoluta para evitar shadowing del npq@3.19.5 stale en ~/.bun/bin
# socket desactivado 2026-08-10 (socket wrapper off); escaneo a demanda con `socket scan create`
alias npm="/home/jona/.npm-global/bin/npq-hero"
alias pnpm="NPQ_PKG_MGR=pnpm /home/jona/.npm-global/bin/npq-hero"


# Added by Antigravity CLI installer
set -gx PATH "/home/jona/.local/bin" $PATH

# qlty
set --export QLTY_INSTALL "$HOME/.qlty"
set --export PATH $QLTY_INSTALL/bin $PATH

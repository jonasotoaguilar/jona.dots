# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------

# -----------------------------------------------------
# General
# -----------------------------------------------------
alias ..='cd ..'
alias c='clear'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
alias vim='$EDITOR'
abbr h tldr
alias wifi='nmtui'
alias arch-cleanup='~/.config/ml4w/scripts/arch/cleanup.sh'
alias apps='~/.config/ml4w/bin/ml4w-apps'
alias screenshot='~/.config/ml4w/bin/ml4w-screenshot'
alias updates='~/.config/ml4w/scripts/ml4w-install-system-updates'
alias filemanager='~/.config/ml4w/settings/filemanager'
alias lock='hyprlock'
alias clock='tty-clock'
alias system='~/.config/ml4w/settings/systemmonitor'
alias quick='~/.config/ml4w/bin/ml4w-quicklinks'
alias wallpaper='~/.config/ml4w/bin/ml4w-wallpaper'
alias settings='ml4w-dotfiles-settings com.ml4w.dotfiles'

# -----------------------------------------------------
# ML4W Apps
# -----------------------------------------------------
alias ml4w='qs ipc call welcome toggle'
alias ml4w-settings='qs -p ~/.local/share/ml4w-dotfiles-settings/quickshell ipc call settings toggle'
alias ml4w-calendar='qs ipc call calendar toggle'
alias ml4w-hyprland='flatpak run com.ml4w.hyprlandsettings'
alias ml4w-sidebar='qs ipc call sidebar toggle'

# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gfo="git fetch origin"
alias gcheck="git checkout"
# Credenciales en el keyring del sistema (libsecret), no en texto plano
alias gcredential="git config credential.helper /usr/lib/git-core/git-credential-libsecret"

# Convención: genera mensaje de commit conventional con IA (Ollama local)
function gcc
    if not git diff --cached --quiet 2>/dev/null
        git diff --staged | mods -m llama3.2:1b -a ollama -q -f "write a conventional commit message following the spec: type(scope): description. Types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert. Keep it under 72 chars for the first line. Output ONLY the commit message, no explanations."
    else
        echo "No hay cambios staged. Usá 'ga' o 'git add' primero."
    end
end

# -----------------------------------------------------
# Scripts
# -----------------------------------------------------
alias ascii='~/.config/ml4w/scripts/figlet.sh'

# -----------------------------------------------------
# Paquetes
# -----------------------------------------------------
alias upkgs='update-packages'

# -----------------------------------------------------
# System
# -----------------------------------------------------
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# -----------------------------------------------------
# ENVIRONMENT
# -----------------------------------------------------

if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

# -----------------------------------------------------
# Android SDK & Emulator
# -----------------------------------------------------
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_AVD_HOME $HOME/.config/.android/avd

fish_add_path --global $ANDROID_HOME/emulator
fish_add_path --global $ANDROID_HOME/platform-tools

# -----------------------------------------------------
# Bun
# -----------------------------------------------------
set -gx BUN_INSTALL $HOME/.bun
fish_add_path --global $BUN_INSTALL/bin

# -----------------------------------------------------
# GitHub Copilot CLI
# -----------------------------------------------------
fish_add_path --global $HOME/.local/share/gh/copilot

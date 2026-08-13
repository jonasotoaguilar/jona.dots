# Carapace completions
if command -q carapace
    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'

    set -l completions_dir ~/.config/fish/completions
    mkdir -p $completions_dir

    if not test -f $completions_dir/.carapace-initialized
        carapace --list | awk '{print $1}' | xargs -I{} touch $completions_dir/{}.fish
        touch $completions_dir/.carapace-initialized
    end

    carapace _carapace | source
end

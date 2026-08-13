# -----------------------------------------------------
# atuin: historial unificado con búsqueda interactiva
# Toma Ctrl-R (carga después de fzf.fish, su bind gana).
# fzf.fish conserva Ctrl-F / Ctrl-L / Ctrl-S.
# -----------------------------------------------------
if command -q atuin
    atuin init fish | source
end

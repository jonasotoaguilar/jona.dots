# Integración nvim ↔ lazygit: socket para editar en la misma sesión
# lazygit detecta $NVIM y abre los archivos en el nvim activo
# (sin subproceso, sin "Press enter to return to lazygit")
set -gx NVIM "$HOME/.cache/nvim/nvim.pipe"

function nvim
    command nvim --listen "$NVIM" $argv
end

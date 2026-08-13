# -----------------------------------------------------
# zoxide: navegación inteligente por historial de directorios
# z / zi / zq — reemplaza cd + fuzzy
# -----------------------------------------------------
if command -q zoxide
    zoxide init fish | source
end

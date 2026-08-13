# -----------------------------------------------------
# CUSTOMIZATION
# -----------------------------------------------------

# -----------------------------------------------------
# Prompt
# -----------------------------------------------------
if status is-interactive
    set -l term_program (string lower -- "$TERM_PROGRAM")

    # Superset está filtrando mal respuestas ANSI/OSC (como OSC 11 y CPR),
    # y Starship termina disparando basura visual en el prompt. Ahí caemos
    # al prompt por defecto de fish para evitar los artefactos.
    if command -sq starship; and test "$term_program" != "superset"
        set -l starship_init (starship init fish)
        if test -n "$starship_init"
            eval "$starship_init"
        end
    end
end

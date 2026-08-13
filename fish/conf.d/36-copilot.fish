# -----------------------------------------------------
# GitHub Copilot CLI — asistente de comandos estilo IDE
#
# - `ai <pregunta>`      : one-shot, imprime la respuesta
# - Ctrl-G               : te pregunta qué querés hacer y
#                          inserta el comando sugerido en tu línea
# - `copilot`            : modo agente interactivo completo
# -----------------------------------------------------

function ai
    copilot -p (string join ' ' -- $argv)
end

function copilot_suggest
    read -l -P 'Que queres hacer: ' query
    if test -z "$query"
        return
    end
    set -l cmd (copilot -p "Write ONLY the exact shell command to accomplish this task. No explanation, no markdown, no surrounding text, no quotes: $query" 2>/dev/null | string collect | string trim)
    if test -n "$cmd"
        commandline -r -- $cmd
    else
        echo "Copilot no devolvio ningun comando." >&2
    end
end

if status is-interactive
    # Compatible con vi key bindings (default + insert)
    bind -M default \cg copilot_suggest
    bind -M insert \cg copilot_suggest
end

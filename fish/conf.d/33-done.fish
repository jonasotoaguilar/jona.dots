# -----------------------------------------------------
# done: notificación cuando un comando largo termina
# Reemplazo local de jorgebucaran/done (repo eliminado de GitHub).
# Requiere notify-send (libnotify) — funciona con niri + swaync/mako/dunst.
# -----------------------------------------------------
set -g done_min_cmd_duration 5000

function _done_notify --on-event fish_postexec
    if test "$CMD_DURATION" -ge "$done_min_cmd_duration"
        notify-send -a fish "Comando terminado" (string escape -- $argv[1]) 2>/dev/null
    end
end

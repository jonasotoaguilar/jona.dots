function dictado-on --description 'Enciende el daemon de dictado'
    systemctl --user start stt-daemon.service

    if test $status -eq 0
        echo '✅ Dictado encendido'
        systemctl --user is-active stt-daemon.service
    else
        echo '❌ No se pudo encender el dictado'
        return 1
    end
end

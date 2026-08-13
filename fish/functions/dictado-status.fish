function dictado-status --description 'Muestra estado del dictado y modelo de Ollama'
    set -l socket "$XDG_RUNTIME_DIR/stt_ptt.sock"

    if test -z "$XDG_RUNTIME_DIR"
        set socket /tmp/stt_ptt.sock
    end

    echo 'STT service:'
    systemctl --user is-active stt-daemon.service

    echo ''
    echo 'STT model:'
    if test -S "$socket"
        uv run python ~/.local/bin/stt_ptt.py status
    else
        echo 'daemon-not-running'
    end

    echo ''
    echo 'STT processes:'
    ps -ef | rg 'stt_daemon.py' | rg -v 'rg stt_daemon.py' >/dev/null; and echo 'running'; or echo 'none'

    if command -q ollama
        echo ''
        echo 'Ollama:'
        ollama ps
    end
end

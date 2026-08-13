function dictado-off --description 'Apaga el daemon de dictado y descarga Ollama del dictado'
    set -l model gemma3:4b
    set -l socket "$XDG_RUNTIME_DIR/stt_ptt.sock"

    if test -z "$XDG_RUNTIME_DIR"
        set socket /tmp/stt_ptt.sock
    end

    if set -q DICTADO_OLLAMA_MODEL
        set model $DICTADO_OLLAMA_MODEL
    end

    if test -S "$socket"
        uv run python ~/.local/bin/stt_ptt.py shutdown >/dev/null 2>/dev/null
    end

    systemctl --user stop stt-daemon.service
    pkill -f '/home/jona/.local/bin/stt_daemon.py' >/dev/null 2>/dev/null
    rm -f "$socket"

    if command -q ollama
        ollama stop $model >/dev/null 2>/dev/null
    end

    echo '🛑 Dictado apagado'
end

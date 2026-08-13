function openclaw
    sshfs yui@yui:/home/yui ~/openclaw
    if test $status -eq 0
        echo "✅ Montado correctamente en ~/openclaw"
    else
        echo "❌ Error al montar"
    end
end

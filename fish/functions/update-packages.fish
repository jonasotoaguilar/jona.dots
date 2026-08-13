function update-packages --description "Actualiza paquetes globales de npm, uv y cargo"
    echo "📦 Paquetes globales"
    echo ""

    # ─── npm ───────────────────────────────────────────
    if command -q npm
        echo "🔷 npm"
        set -l npm_before (mktemp)
        set -l npm_after (mktemp)
        npm ls -g --depth=0 --json > "$npm_before" 2>/dev/null
        echo "   Actualizando paquetes globales..."
        # Fail-closed: respeta ignore-scripts=true de la config global (sin allowlist de scripts)
        npm update -g || echo "   ⚠️  hubo errores con npm"
        npm ls -g --depth=0 --json > "$npm_after" 2>/dev/null
        node -e '
const fs = require("fs")
const [beforePath, afterPath] = process.argv.slice(1)
const readDeps = (file) => {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8")).dependencies || {}
  } catch {
    return {}
  }
}
const before = readDeps(beforePath)
const after = readDeps(afterPath)
const names = [...new Set([...Object.keys(before), ...Object.keys(after)])].sort()
const changes = []
for (const name of names) {
  const prev = before[name]?.version || "(sin versión)"
  const next = after[name]?.version || "(sin versión)"
  if (!(name in before) && (name in after)) changes.push(`   • ${name}: instalado ${next}`)
  else if ((name in before) && !(name in after)) changes.push(`   • ${name}: eliminado (antes ${prev})`)
  else if (prev !== next) changes.push(`   • ${name}: ${prev} → ${next}`)
}
if (changes.length) {
  console.log("   Cambios npm:")
  console.log(changes.join("\n"))
} else {
  console.log("   Sin cambios de versión en npm.")
}
' "$npm_before" "$npm_after"
        rm -f "$npm_before" "$npm_after"
        echo ""
    else
        echo "🔷 npm: no disponible"
        echo ""
    end

    # ─── uv ────────────────────────────────────────────
    if command -q uv
        echo "🔷 uv"
        set -l uv_before (mktemp)
        set -l uv_after (mktemp)
        uv tool list --show-python > "$uv_before" 2>/dev/null
        echo "   Actualizando herramientas globales..."
        uv tool upgrade --all 2>/dev/null || echo "   ⚠️  hubo errores con uv"
        uv tool list --show-python > "$uv_after" 2>/dev/null
        python3 -c '
import re, sys

def parse(path):
    tools = {}
    try:
        with open(path, "r", encoding="utf-8") as f:
            for raw in f:
                line = raw.strip()
                if not line or line.startswith("-"):
                    continue
                m = re.match(r"^(\S+) v([^\s]+)", line)
                if m:
                    tools[m.group(1)] = m.group(2)
    except FileNotFoundError:
        return {}
    return tools

before = parse(sys.argv[1])
after = parse(sys.argv[2])
names = sorted(set(before) | set(after))
changes = []
for name in names:
    prev = before.get(name)
    nxt = after.get(name)
    if prev is None and nxt is not None:
        changes.append(f"   • {name}: instalado {nxt}")
    elif prev is not None and nxt is None:
        changes.append(f"   • {name}: eliminado (antes {prev})")
    elif prev != nxt:
        changes.append(f"   • {name}: {prev} → {nxt}")

if changes:
    print("   Cambios uv:")
    print("\n".join(changes))
else:
    print("   Sin cambios de versión en uv.")
' "$uv_before" "$uv_after"
        rm -f "$uv_before" "$uv_after"
        echo ""
    else
        echo "🔷 uv: no disponible"
        echo ""
    end

    # ─── cargo ─────────────────────────────────────────
    if command -q cargo
        echo "🔷 cargo"
        # Parsear cargo install --list
        set -l cargo_list (cargo install --list 2>/dev/null)
        set -l cratesio_pkgs
        set -l git_pkgs      # tripletas: nombre version repo_url
        set -l local_pkgs    # pares: nombre path
        for line in $cargo_list
            if string match -qr '^\S.*:$' -- $line
                set -l line_clean (string replace -r ':$' '' -- $line)
                set -l name (string match -r '^\S+' -- $line_clean)
                if string match -qr '\(https?://' -- $line_clean
                    # Git: extraer versión y URL base (sin #commit)
                    set -l ver (string match -r --groups-only '\s(v?\S+)\s\(' -- $line_clean)
                    set -l url (string match -r --groups-only '\((https?://[^)#]+)' -- $line_clean)
                    set -a git_pkgs "$name" "$ver" "$url"
                else if string match -qr '\(\s*/' -- $line_clean
                    # Local path
                    set -l path (string match -r --groups-only '\((\s*/[^)]+)\)' -- $line_clean)
                    set path (string trim -- "$path")
                    set -a local_pkgs "$name" "$path"
                else
                    set -a cratesio_pkgs "$line_clean"
                end
            end
        end

        echo "   Paquetes encontrados:"
        if set -q cratesio_pkgs[1]
            echo "   📦 crates.io:"
            for pkg in $cratesio_pkgs
                echo "     $pkg"
            end
        end
        if set -q git_pkgs[1]
            echo "   🔗 Git:"
            set -l gi 1
            while test $gi -le (count $git_pkgs)
                set -l gv (math $gi + 1)
                set -l gu (math $gi + 2)
                echo "     $git_pkgs[$gi] $git_pkgs[$gv] — $git_pkgs[$gu]"
                set gi (math $gi + 3)
            end
        end
        if set -q local_pkgs[1]
            echo "   📁 Local path (actualización manual):"
            set -l li 1
            while test $li -le (count $local_pkgs)
                set -l lnext (math $li + 1)
                echo "     $local_pkgs[$li] — $local_pkgs[$lnext]"
                set li (math $li + 2)
            end
        end
        echo ""

        # Instalar cargo-update si no está
        if not command -q cargo-install-update
            echo "   cargo-update no encontrado. Instalando..."
            cargo install cargo-update 2>/dev/null || begin
                echo "   ⚠️  no se pudo instalar cargo-update. Saltando cargo."
                echo ""
                echo "✅ npm y uv actualizados (cargo omitido)."
                return 0
            end
        end

        # Actualizar crates.io
        if set -q cratesio_pkgs[1]
            echo "   Actualizando crates.io..."
            cargo install-update -a 2>/dev/null || echo "   ⚠️  hubo errores con cargo install-update"
        end

        # Actualizar paquetes Git (solo si el remote tiene versión más nueva)
        if set -q git_pkgs[1]
            set -l gi 1
            while test $gi -le (count $git_pkgs)
                set -l pkg_name $git_pkgs[$gi]
                set -l pkg_ver  $git_pkgs[(math $gi + 1)]
                set -l pkg_url  $git_pkgs[(math $gi + 2)]

                # Obtener último tag de release del remote (filtra solo vX.Y.Z estables)
                set -l latest_tag (git ls-remote --tags "$pkg_url" 2>/dev/null \
                    | string match -r 'refs/tags/(v?\d+\.\d+\.\d+)(\^\{\})?$' \
                    | string replace -r '.*refs/tags/' '' \
                    | string replace -r '\^\{\}$' '' \
                    | sort -uV | tail -1)

                if test -z "$latest_tag"
                    echo "   ⚠️  $pkg_name: no se pudieron obtener tags de $pkg_url"
                    set gi (math $gi + 3)
                    continue
                end

                # Comparar versiones
                set -l sorted (printf '%s\n' "$pkg_ver" "$latest_tag" | sort -V)
                set -l newer $sorted[-1]

                if test "$newer" = "$latest_tag" -a "$pkg_ver" != "$latest_tag"
                    echo "   🔄 $pkg_name: $pkg_ver → $latest_tag"
                    cargo install --git "$pkg_url" "$pkg_name" --force 2>/dev/null \
                        && echo "     ✅ $pkg_name $latest_tag instalado" \
                        || echo "     ⚠️  falló $pkg_name"
                else
                    echo "   ✅ $pkg_name $pkg_ver (al día)"
                end
                set gi (math $gi + 3)
            end
        end
        echo ""
    else
        echo "🔷 cargo: no disponible"
        echo ""
    end

    echo "✅ Todo actualizado."
end

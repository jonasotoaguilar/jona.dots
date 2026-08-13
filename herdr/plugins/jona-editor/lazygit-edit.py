#!/usr/bin/env python3
"""Open nvim on a file in a herdr popup (lazygit os.edit bridge).

lazygit runs this with the template argument (``path`` or ``path:line``).
We ask the herdr socket to open the jona.editor popup pane and exit
immediately so lazygit never blocks. If the popup cannot open (server
unreachable, wrong view), fall back to nvim inline in the current pane —
the classic lazygit behavior.

Usage: lazygit-edit.py <path>[:<line>]
"""

import json
import os
import socket
import sys

DEFAULT_SOCKET = os.path.expanduser("~/.config/herdr/herdr.sock")


def open_inline(prog: str, path: str, line: str) -> None:
    """Replace this process with the editor in the current pane."""
    argv = [prog]
    if line:
        argv.append(f"+{line}")
    argv += ["--", path]
    os.execvp(argv[0], argv)


def main() -> int:
    arg = sys.argv[1] if len(sys.argv) > 1 else ""
    path, line = arg, ""
    if ":" in arg:
        head, _, tail = arg.rpartition(":")
        if tail.isdigit():
            path, line = head, tail

    prog = os.environ.get("EDIT_PROG", "nvim")
    env = {"EDIT_FILE": path, "EDIT_ARGS": f"+{line}" if line else ""}
    if "EDIT_PROG" in os.environ:
        env["EDIT_PROG"] = prog

    sock_path = os.environ.get("HERDR_SOCKET_PATH") or DEFAULT_SOCKET
    params = {
        "plugin_id": "jona.editor",
        "entrypoint": "edit",
        "placement": "popup",
        "width": "80%",
        "height": "80%",
        "focus": True,
        "env": env,
    }
    request = {"id": "lazygit-edit", "method": "plugin.pane.open", "params": params}

    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
            sock.connect(sock_path)
            sock.sendall((json.dumps(request) + "\n").encode())
            buf = b""
            while b"\n" not in buf:
                chunk = sock.recv(4096)
                if not chunk:
                    break
                buf += chunk
        response = json.loads(buf.decode())
        error = response.get("error")
        if error:
            # A popup is a singleton: one already open is fine, keep it.
            if error.get("code") == "plugin_pane_open_failed":
                return 0
            print(
                f"lazygit-edit: popup failed ({error.get('message', error)}); opening inline",
                file=sys.stderr,
            )
            open_inline(prog, path, line)
    except Exception as exc:  # noqa: BLE001 - any failure degrades to inline
        print(
            f"lazygit-edit: popup unavailable ({exc}); opening inline", file=sys.stderr
        )
        open_inline(prog, path, line)

    # Popup runs detached; lazygit must not wait on it.
    return 0


if __name__ == "__main__":
    sys.exit(main())

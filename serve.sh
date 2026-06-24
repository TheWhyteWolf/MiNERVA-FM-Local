#!/bin/bash
# Serve the demo over http (required: fetch/decodeAudioData/wasm won't work on file://)
cd "$(dirname "$0")"
PORT="${1:-8000}"
echo "MiNERVA RADIO (CRT) → http://localhost:$PORT/"
echo "Open that in a browser, then click POWER ON."
exec python3 -m http.server "$PORT"

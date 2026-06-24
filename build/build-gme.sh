#!/bin/bash
# Build game-music-emu to a browser wasm module exposing GME's C API.
# Covers SPC / VGM (and NSF/AY/KSS/GBS...). VGZ is gunzipped in JS before
# being handed to gme_open_data, so we deliberately disable zlib here.
set -e
cd "$(dirname "$0")"
SRC="game-music-emu"
OUT="../assets/engines"

# Arch installs the emscripten tools here but doesn't always add them to PATH.
command -v emcc >/dev/null 2>&1 || export PATH="/usr/lib/emscripten:$PATH"
command -v emcc >/dev/null 2>&1 || { echo "emcc not found. Install with: sudo pacman -S emscripten"; exit 1; }
echo "Using: $(command -v emcc)"

# 1. Configure + build the static library with emscripten.
emcmake cmake -S "$SRC" -B build-wasm \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DENABLE_UBSAN=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=ON
emmake make -C build-wasm gme_static -j"$(nproc)"
[ -f build-wasm/gme/libgme.a ] || { echo "ERROR: libgme.a not built"; exit 1; }

# 2. Link the wasm module, exporting just the slice of the C API we drive.
emcc build-wasm/gme/libgme.a -I "$SRC" -O3 \
  -o "$OUT/libgme.js" \
  -s MODULARIZE=1 \
  -s EXPORT_NAME=createGME \
  -s ENVIRONMENT=web \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s EXPORTED_RUNTIME_METHODS='ccall,cwrap,getValue,setValue,UTF8ToString,HEAP16,HEAPU8' \
  -s EXPORTED_FUNCTIONS='_malloc,_free,_gme_open_data,_gme_start_track,_gme_play,_gme_track_count,_gme_track_ended,_gme_set_fade,_gme_delete'

echo "Built: $OUT/libgme.js + $OUT/libgme.wasm"
ls -la "$OUT"/libgme.*

# MiNERVA-FM — Local Player

A single-page, audio-reactive chiptune player styled like an old CRT terminal
(à la [cool-retro-term](https://github.com/Swordfish90/cool-retro-term)). Point it at
your own retro game-music files and watch them play on a virtual cathode-ray tube —
spectrum analyser, scrolling ticker, phosphor glow, and a dot→line→fill power-on.

> **Bring your own music.** This repo ships **no audio** by design. Load your own
> `.sid .spc .vgm .vgz .mp3 .flac .wav` files — you are responsible for the rights to anything you play.

## Run

```bash
./serve.sh            # → http://localhost:8000   (serve over http, not file://)
```

Open it, click **POWER ON**, then press **O** to choose a folder of your music
(or drag files straight onto the screen).

## Controls
| key | action |
|-----|--------|
| `O` | open a folder of your music |
| `N` / `P` | next / previous track |
| `Space` | pause / resume |
| `M` | colour ↔ amber-phosphor (mono) CRT |
| `S` | scanlines on/off |
| `↑ ↓` | volume |

You can also **drag files onto the tube**.

## Formats & engines (all decoded in-browser)
| format | engine |
|--------|--------|
| `.sid` | [jsSID](https://github.com/og2t/jsSID) |
| `.spc` `.vgm` `.vgz` | [game-music-emu](https://github.com/libgme/game-music-emu) → WebAssembly |
| `.mp3` `.flac` `.wav` | native browser decode |

The prebuilt `assets/engines/libgme.{js,wasm}` is bundled, so SPC/VGM work out of the box.
To rebuild it yourself (needs `emscripten` + `cmake`; clones game-music-emu):

```bash
build/build-gme.sh
```

## How it works
- Content is drawn to a 640×480 virtual tube — three panes (now-playing / spectrum / ticker).
- A single-pass **WebGL CRT shader** applies curvature, scanlines, aperture mask, RGB shift,
  bloom, flicker, noise and vignette, plus the power-on ignition. Falls back to a flat 2D blit
  if WebGL is unavailable.
- A Web Audio `AnalyserNode` drives the spectrum, so the bars react to whatever's actually playing.

Set `DEBUG = true` near the top of `index.html`'s script for verbose audio/engine console logs.

## Credits & licensing
- **jsSID** — SID emulation by Mihály Horváth (Hermit).
- **game-music-emu** — Blargg's library (maintained by libgme); LGPL.
- CRT aesthetic inspired by **cool-retro-term** (Filippo Scognamiglio).

The bundled engine components retain their upstream licenses — review them before redistributing.

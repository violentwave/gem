# Gemma Voice Mode

Local push-to-talk voice agent for the Bazzite Local AI Operations Stack.

## Overview

Voice mode wraps local STT (speech-to-text) and TTS (text-to-speech) around Gemma. Gemma itself is text-only; voice mode transcribes your speech, sends the text to Gemma via Ollama, and speaks the response.

**Design principles:**
- Push-to-talk only. No always-listening.
- No wake word. No daemon.
- No cloud APIs. No LiveKit.
- Audio deleted after transcription (unless `--keep-audio`).
- Does not bypass `gemma-ui` or `gemma-security-chat` gates.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Microphone │────▶│  pw-record  │────▶│whisper-cli  │────▶│   Gemma     │
│  (6s clip)  │     │  (WAV file) │     │   (STT)     │     │  (Ollama)   │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                  │
                                                                  ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Speaker   │◀────│  pw-play    │◀────│    piper    │◀────│  Text reply │
│             │     │  (WAV play) │     │   (TTS)     │     │             │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

## Components

| Component | Tool | Location | Size |
|-----------|------|----------|------|
| Recorder | pw-record (PipeWire) | System | — |
| STT | whisper-cli (whisper.cpp) | `~/.local/share/bazzite-security/voice/whisper.cpp/` | ~75MB model |
| TTS | piper | `~/.local/share/bazzite-security/voice/piper/` | ~50MB model |
| Model | ggml-tiny.bin | `~/.local/share/bazzite-security/voice/ggml-tiny.bin` | ~75MB |
| Voice | en_US-lessac-medium | `~/.local/share/bazzite-security/voice/piper/en_US-lessac-medium.onnx` | ~50MB |

## Installation

Run the setup command:

```bash
gemma-voice-chat --setup
```

This downloads:
- whisper.cpp tiny model (~75MB)
- piper binary + voice model (~50MB)

No sudo required. No system changes.

## Usage

### Standalone

```bash
gemma-voice-chat                    # Start voice session
gemma-voice-chat --status           # Show component status
gemma-voice-chat --test-output      # Test TTS output
gemma-voice-chat --setup            # Download/build voice components
gemma-voice-chat --keep-audio       # Keep recordings after session
```

### Via gemma-ui

```bash
gemma-ui --mode voice               # Enter voice mode
gemma-ui --mode voice status        # Show voice status
gemma-ui --mode voice start         # Start voice session
gemma-ui --mode voice test-output   # Test TTS
gemma-ui --mode voice help          # Show voice help
gemma-ui --voice-status             # Quick status check
```

### Interactive Commands

Inside `gemma-ui`:

```
/voice              Show status and prompt to start
/voice status       Show component status
/voice start        Start voice session
/voice test-output  Test TTS output
/voice help         Show voice help
/voice stop         Stop voice session
```

## Voice Session Flow

1. Press **Enter** to record (6 seconds)
2. Audio saved to temp WAV file
3. whisper-cli transcribes WAV to text
4. Text sent to Gemma via Ollama
5. Gemma's text response received
6. piper converts text to speech
7. WAV played through speakers
8. Raw audio deleted (unless `--keep-audio`)

## Configuration

Environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `GEMMA_MODEL` | `gemma4-e4b-bazzite` | Ollama model to use |
| `OLLAMA_HOST` | `http://127.0.0.1:11434` | Ollama API endpoint |

Config file: `~/.config/bazzite-security/gemma-ui.json`

```json
{
  "features": {
    "voice": true
  }
}
```

## Troubleshooting

### No audio recorder found
Install PipeWire or PulseAudio:
```bash
brew install pipewire  # or use system package manager
```

### whisper-cli not found
```bash
gemma-voice-chat --setup
```
Or install via homebrew:
```bash
brew install whisper.cpp
```

### piper not found
```bash
gemma-voice-chat --setup
```

### TTS sounds robotic
Piper uses neural TTS but the tiny model is fast. For better quality, download a larger piper voice model.

### Transcription is poor
The tiny whisper model is fast but less accurate. For better accuracy, download a larger whisper model (base, small).

## Security Notes

- Audio is processed locally. No cloud STT/TTS.
- Raw recordings are deleted after transcription.
- Use `--keep-audio` to retain for debugging.
- Voice mode does not bypass security gates.

## Files

- `~/.local/bin/gemma-voice-chat` — Voice agent script
- `~/.local/bin/gemma-ui` — Unified UI with voice integration
- `~/.local/share/bazzite-security/voice/` — Voice components
- `~/.cache/bazzite-security/voice/` — Temporary audio files
- `~/.local/state/bazzite-security/logs/voice/` — Session logs

## See Also

- `docs/gemma-ui.md` — Main UI documentation
- `docs/maintenance/GEMMA_UI_FRONT_DOOR.md` — Front door guide
- `~/.local/bin/gemma-voice-chat --help`

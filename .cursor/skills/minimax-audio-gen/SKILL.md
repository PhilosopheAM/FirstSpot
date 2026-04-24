---
name: minimax-audio-gen
description: Use this skill whenever the user wants to generate music, sound effects, voice lines, mascot sounds, UI audio, ambient loops, or audio prompt packs with MiniMax MCP. Also use it when the user asks to turn product scenes, interaction specs, or markdown sound libraries into production-ready MiniMax prompts and audio generation steps.
---

# MiniMax Audio Generation

Use this skill for music and sound design tasks that should go through the MiniMax MCP integration.

## Preconditions

Before using this skill, make sure the `MiniMax` MCP server is available in the client and the API key has been filled in.

- Cursor MCP config path: `C:\Users\harry\.cursor\mcp.json`
- Output directory: `F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\generated_by_minimax`

If the MCP is not available yet, tell the user that the config is prepared and they need to:

1. Fill in `MINIMAX_API_KEY`
2. Restart Cursor or reload MCP tools
3. Confirm the `MiniMax` server appears in MCP tools

## What to use

Prefer these MCP tools:

- `music_generation`: for songs, BGM, loops, stingers, and many stylized sound effects
- `text_to_audio`: for narration, mascot voice lines, and spoken prompts
- `voice_design`: for designing a custom voice before synthesis
- `list_voices`: for selecting existing voices
- `voice_clone`: only when the user explicitly wants cloning and provides a source file

## Workflow

### 1. Classify the request

Decide which of these buckets the user wants:

- `sound-effect`: UI click, reward cue, mascot chirp, fire ignition, badge unlock, whoosh
- `music-loop`: onboarding BGM, home BGM, ambient loop, soft background layer
- `song`: full musical piece with lyrics and sections
- `voice-line`: spoken line, mascot dialogue, narration, announcement

### 2. Normalize the spec

Extract or infer:

- purpose
- duration
- loudness target in dB when the user provides one
- mood
- instrumentation or texture
- pacing
- output format
- whether the file should loop cleanly
- whether vocals are needed

If the user gives an existing markdown prompt library, reuse its exact constraints rather than rewriting the whole creative direction.

### 3. Build the MiniMax prompt

Keep prompts concrete and production-oriented. Good prompts usually include:

- what the audio is for
- mood and energy
- key textures or instruments
- pacing and articulation
- what to avoid
- loop requirement if relevant

For songs, structure lyrics with tags like:

```text
[Intro]
[Verse]
[Chorus]
[Bridge]
[Outro]
```

### 4. Generate with MCP

Preferred defaults:

- sound effects / UI / short cues: use `music_generation` with a focused prompt and minimal lyrics
- BGM / loops: use `music_generation`
- voice lines: use `text_to_audio`
- custom voice creation first: `voice_design` then `text_to_audio`

Prefer local file output into:

`F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\generated_by_minimax`

### 5. Report back clearly

When generation is done, report:

- tool used
- final prompt
- output file path
- any parameters that matter, such as format, sample rate, bitrate, or voice id

## Prompt templates

### Sound effect

```text
Create a short sound effect for [purpose].
Mood: [mood].
Texture/instrumentation: [texture].
Timing: [duration].
Loudness target: [dB].
Use case: mobile app UI / mascot feedback / onboarding interaction.
Avoid: [avoid list].
```

### Music loop

```text
Create a seamless loop for [scene].
Mood: [mood].
Instrumentation: [instruments].
Energy: [energy].
Length: [duration].
Loudness target: [dB].
Should loop cleanly with no abrupt attack or tail.
Avoid: [avoid list].
```

### Voice line

```text
Generate a voice line for [character/use case].
Voice style: [style].
Emotion: [emotion].
Speed: [speed].
Text: [exact text].
Output requirements: [format / sample rate / bitrate].
```

## FirstSpot-specific guidance

For FirstSpot, bias toward:

- youthful but not childish
- warm and modern, not casino-like
- clean UI-friendly transients
- restrained reward cues
- gentle finance-education tone
- mascot audio that feels playful, short, and repeat-safe

Avoid:

- jackpot sounds
- overly aggressive EDM risers
- horror textures
- exaggerated anime comedy sounds unless the user explicitly wants that

## Reference files

Read these when useful:

- `F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\AI_Sound_Prompts.md`
- `F:\Do_Some_Great_Things\FirstSpot\Design_Resource\Sound_design_resource\MiniMax_MCP_Setup.md`

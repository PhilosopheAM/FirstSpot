# testapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Myo Launch Animation

The app launch animation is currently implemented as a transparent PNG frame sequence instead of a transparent `.webm`.

- Player entry: `lib/features/onboarding/pages/avatar_launch_page.dart`
- Frame assets: `assets/animations/myo_wave_frames/`
- Frame generator: `../tools/generate_myo_wave_frames.ps1`
- Source character image: `../remotion-avatar/public/cat-avatar-transparent.png`

Why this exists:

- Transparent `.webm` playback previously produced a black square background on Flutter/Android.
- The frame-sequence approach is more stable and keeps only the Myo line art plus pink tongue visible over the launch background.

If you want to tweak the waving motion, regenerate the PNG frames first, then keep `avatar_launch_page.dart` in sync with the frame list.

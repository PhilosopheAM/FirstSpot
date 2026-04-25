# testapp

Flutter prototype for FirstSpot onboarding and dashboard flows.

## Current onboarding opening

The app no longer uses a standalone splash / hatch transition before onboarding.

- First entry goes directly to `Onboarding_01_Welcome`
- Entry gate: `lib/features/onboarding/pages/first_open_gate_page.dart`
- Onboarding container: `lib/features/onboarding/pages/onboarding_flow_page.dart`
- Welcome page: `lib/features/onboarding/widgets/onboarding_welcome_step.dart`

## Myo welcome media

- Welcome video: `assets/animations/myo_waving_welcome.mp4`
- Welcome tap sound: `assets/audio/myo_meow_short.mp3`

Behavior on `Onboarding_01_Welcome`:

- Myo loops inside the green circular frame
- Tapping the green circle keeps the video unchanged
- The tap triggers the first-interaction easter egg once
- The tap also plays the Myo meow sound

## Investor education path

The dashboard course card opens the `learning_guidance` feature:

- Entry page: `lib/features/learning_guidance/pages/guidance_learning_page.dart`
- Static lesson data: `lib/features/learning_guidance/data/guidance_lessons.dart`
- Reusable quiz widget: `lib/features/learning_guidance/widgets/myo_practice_block.dart`
- Chapter card assets: `assets/images/guidance_cards/`

## Onboarding lesson media

The mini lesson uses farming-metaphor assets registered in `pubspec.yaml`:

- Images: `assets/images/idle_money_coin.png`, `assets/images/planted_sprout.png`, `assets/images/harvest_basket.png`
- Audio: `assets/audio/seed_plant.wav`, `assets/audio/basket_drop.wav`, `assets/audio/heart_break_soft.wav`

# AURA (`example_v2`)

Local fitness tracker coach built **only** on [`masterfabric_core`](../).

App ID: `com.masterfabric.aura` (iOS + Android).

## Features

- **Today** — remaining calories, macros, warnings, quick water
- **Log** — food / drink / burn logging with presets + custom entries
- **Body** — height, weight, age, sex, activity → BMI / BMR / TDEE / goal
- **Coach** — tips, help topics, local reminders & warning toggles

Black–white, borderless UI. All data stays on device via `LocalStorageHelper`.

## Architecture

- **Dependency:** product UI sits on `masterfabric_core` (`MasterApp`, `MasterViewCubit`, `CoreSpacer`, config helpers).
- **AuraKit** (`lib/widgets/aura_kit.dart` + `aura_space.dart`): shared section cards, list rows, sheets, buttons, empty/loading — no one-off gaps.
- **Theme config:** `uiConfiguration` in `assets/app_config.json` → `AuraThemeConfig` (themeMode, fontScale, dev spacers).
- **i18n:** slang `en` + `tr` under `assets/i18n/` → `lib/src/resources/` (`dart run slang`). Language switcher lives in the profile sheet.

## Run

```bash
cd example_v2
flutter pub get
dart run slang   # after editing i18n JSON
flutter run
```

Requires Flutter ≥ 3.44. iOS 15+.

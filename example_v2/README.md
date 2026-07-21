# AURA (`example_v2`)

Local fitness tracker coach built **only** on [`masterfabric_core`](../).

App ID: `com.masterfabric.aura` (iOS + Android).

## Features

- **Today** — remaining calories, macros, warnings, quick water
- **Log** — food / drink / burn logging with presets + custom entries
- **Body** — height, weight, age, sex, activity → BMI / BMR / TDEE / goal
- **Coach** — tips, help topics, local reminders & warning toggles

Black–white, borderless UI. All data stays on device via `LocalStorageHelper`.

## Run

```bash
cd example_v2
flutter pub get
flutter run
```

Requires Flutter ≥ 3.44. iOS 15+.

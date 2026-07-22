<div align="center">

<p>
  <img src="docs/brand/app_icon_classic.png" width="96" alt="AURA classic app icon" />
  &nbsp;
  <img src="docs/brand/app_icon_woman.png" width="96" alt="AURA woman app icon" />
  &nbsp;
  <img src="docs/brand/app_icon_man.png" width="96" alt="AURA man app icon" />
  &nbsp;
  <img src="docs/brand/app_icon_crew.png" width="96" alt="AURA crew app icon" />
  &nbsp;
  <img src="docs/brand/app_icon_abstract.png" width="96" alt="AURA abstract app icon" />
</p>

# AURA

**Local fitness tracker & coach**

A product demonstration built exclusively on [`masterfabric_core`](../)

<br />

[![Owner](https://img.shields.io/badge/Owner-MASTERFABRIC-111111?style=flat-square)](https://masterfabric.co)
[![License](https://img.shields.io/badge/License-AGPLv3%20%2B%20terms-0B6E4F?style=flat-square)](./LICENSE)
[![App ID](https://img.shields.io/badge/App%20ID-com.masterfabric.aura-2563EB?style=flat-square)](#)
[![Locales](https://img.shields.io/badge/Locales-EN%20%7C%20TR-6B7280?style=flat-square)](#internationalization)

<br />

<img src="docs/brand/aura_wordmark.png" width="160" alt="AURA wordmark" />

<p>
  Black–white · borderless · on-device · illustration-led<br />
  Onboarding → permissions → Today · Log · Body · Coach
</p>

</div>

---

<div align="center">

## Overview

</div>

AURA is a **reference consumer product** for the MasterFabric Flutter stack. It shows how a full fitness coach experience can be assembled from core patterns alone — `MasterApp`, `MasterViewCubit`, config-driven theme, slang i18n, local storage, permissions, widgets, and jobs — without a separate design-system package or a remote backend for the daily loop.

| | |
|:--|:--|
| **Product** | AURA (`example_v2`) |
| **Owner** | MASTERFABRIC Bilişim Teknoloji A.Ş. ([masterfabric.co](https://masterfabric.co)) |
| **Author** | Gürkan Fikret Günak ([@gurkanfikretgunak](https://github.com/gurkanfikretgunak)) |
| **Platforms** | iOS 15+ · Android · optional Widget / Live Activity / Watch |
| **License** | [AGPLv3 + AURA additional terms](./LICENSE) |
| **Privacy** | All personal data stays on device |

**What you get in this package**

1. **Architectural fidelity** — screens extend `MasterViewCubit`; the shell boots through `MasterApp`.
2. **Shared chrome** — `AuraKit` / `AuraSpace` wrap core spacers so views do not invent one-off gaps.
3. **Config-first UI** — `assets/app_config.json` → `AuraThemeConfig` (theme mode, font scale, developer overlays).
4. **Bilingual copy** — slang `en` + `tr` with a language switcher in the profile sheet.
5. **Local-first coaching** — BMI / BMR / TDEE, food & burn logging, tip cards, local activity jobs; WebLLM coaching on a real iPhone.

Screenshots below were captured on an **iPhone 17** simulator via Flutter `integration_test`.

---

<div align="center">

## License & commercial use

</div>

AURA is **owned by MASTERFABRIC**. Source is released under the **GNU Affero General Public License v3** with product-specific terms in [`LICENSE`](./LICENSE).

| Use case | Requirement |
|:--|:--|
| Study, fork, AGPL-compliant use | AGPLv3 + MasterFabric root terms + AURA terms |
| Commercial / SaaS / white-label / paid store apps | **Paid commercial license** → [license@masterfabric.co](mailto:license@masterfabric.co) |
| Verified non-profit | Free-license codes on request (same contact) |
| Brand & illustrations | No endorsement without written permission |

Do not remove MasterFabric or AURA ownership notices from the app, this README, or license files.

---

<div align="center">

## Product surface

</div>

| Area | What it does |
|:--|:--|
| **Onboarding** | Welcome → sex → body metrics → body type → training goal → **app icon** → ready |
| **Permissions** | Intro → notifications → location → fitness → ready |
| **Today** | Remaining calories, macros, warnings, quick water / food / burn |
| **Log** | Presets + custom food, drink, and burn entries |
| **Body** | Height, weight, age, sex, activity → BMI / BMR / TDEE / goal |
| **Coach** | Daily assist, tip guides, journal, local reminder toggles |
| **Profile** | Baseline summary + language switcher + **change app icon** |

---

<div align="center">

## App icons

</div>

Five home-screen themes. **Classic** (original B&W) is the default; users can pick another during onboarding or later in Profile → Change app icon.

| Classic | Woman | Man | Crew | Abstract |
|:--:|:--:|:--:|:--:|:--:|
| <img src="docs/brand/app_icon_classic.png" width="88" alt="Classic" /> | <img src="docs/brand/app_icon_woman.png" width="88" alt="Woman" /> | <img src="docs/brand/app_icon_man.png" width="88" alt="Man" /> | <img src="docs/brand/app_icon_crew.png" width="88" alt="Crew" /> | <img src="docs/brand/app_icon_abstract.png" width="88" alt="Abstract" /> |
| Original B&W | Coral athlete | Cyan athlete | Lime gym crew | Violet mark |

Source masters live under `assets/icons/app_icon_*_1024.png`. iOS alternate icons + Android activity-aliases are switched at runtime via `flutter_dynamic_icon_plus`.

---

<div align="center">

## Architecture

</div>

```text
example_v2/
├── assets/
│   ├── app_config.json            # MasterApp + AuraThemeConfig
│   ├── i18n/{en,tr}.i18n.json     # slang product strings
│   ├── icons/app_icon_*_1024.png  # classic + alternate icon masters
│   ├── illustrations/             # onboarding, tips, log, brand
│   ├── notifications/             # local job / notification JSON
│   └── webllm/                    # on-device coach HTML shell
├── lib/
│   ├── app/                       # bootstrap, DI, theme config
│   ├── data/models/               # food, weight, notifications, …
│   ├── jobs/                      # local activity nudges
│   ├── platform/                  # widget / watch bridges
│   ├── views/                     # onboarding + tab screens (+ cubits)
│   ├── widgets/                   # AuraKit, AuraShell, tips, toasts
│   └── src/resources/             # generated slang (dart run slang)
├── ios/                           # Runner + AuraWidget + AuraWatch
├── docs/
│   ├── brand/                     # rounded icon + wordmark for docs
│   └── screenshots/               # capture set (01–18)
└── LICENSE                        # AGPLv3 notice + commercial terms
```

**Dependency rule:** product UI sits on **`masterfabric_core` only** (plus Flutter SDK helpers, `permission_handler`, and slang). There is no second UI framework.

| Concern | Mechanism |
|:--|:--|
| App shell | `MasterApp` (`lib/app/app.dart`) |
| Screens | `MasterViewCubit` / `BaseViewModelCubit` |
| Spacing & chrome | `AuraKit` + `AuraSpace` → core spacers |
| Theme | `uiConfiguration` → `AuraThemeConfig` |
| i18n | slang `en` / `tr` → `lib/src/resources/` (imported as `aura`) |
| Persistence | `LocalStorageHelper` / Hive CE via core storage config |
| Apple extras | Home Widget, Live Activity, Watch under `ios/` |

```mermaid
flowchart LR
  Config["app_config.json"] --> Theme["AuraThemeConfig"]
  Config --> Master["MasterApp"]
  Theme --> Master
  i18n["slang en / tr"] --> Views
  Master --> Shell["AuraShell"]
  Shell --> Views["Today / Log / Body / Coach"]
  Views --> Kit["AuraKit"]
  Views --> Storage["LocalStorageHelper"]
  Kit --> Core["masterfabric_core"]
  Master --> Core
```

---

<div align="center">

## Screenshots

<p>iPhone 17 simulator · rounded frames match the app-icon treatment</p>

</div>

### Launch & onboarding

<div align="center">
  <img src="docs/screenshots/01_launch.png" width="220" alt="Launch" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/02_onboarding_welcome.png" width="220" alt="Welcome" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/03_onboarding_sex.png" width="220" alt="Sex" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/04_onboarding_sex_selected.png" width="220" alt="Sex selected" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/05_onboarding_body_metrics.png" width="220" alt="Body metrics" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/06_onboarding_body_type.png" width="220" alt="Body type" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/07_onboarding_training_goal.png" width="220" alt="Training goal" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/08_onboarding_ready.png" width="220" alt="Onboarding ready" style="border-radius: 22px;" />
</div>

### Permissions

<div align="center">
  <img src="docs/screenshots/09_permissions_intro.png" width="220" alt="Permissions intro" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/10_permissions_notifications.png" width="220" alt="Notifications" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/11_permissions_location.png" width="220" alt="Location" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/12_permissions_fitness.png" width="220" alt="Fitness" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/13_permissions_ready.png" width="220" alt="Permissions ready" style="border-radius: 22px;" />
</div>

### Main tabs & profile

<div align="center">
  <img src="docs/screenshots/14_today.png" width="220" alt="Today" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/15_log.png" width="220" alt="Log" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/16_body.png" width="220" alt="Body" style="border-radius: 22px;" />
  &nbsp;
  <img src="docs/screenshots/17_coach.png" width="220" alt="Coach" style="border-radius: 22px;" />
  <br /><br />
  <img src="docs/screenshots/18_profile_language.png" width="220" alt="Profile and language" style="border-radius: 22px;" />
</div>

---

<div align="center">

## Internationalization

</div>

Supported locales: **English (`en`)** and **Turkish (`tr`)**.

```bash
# Edit
#   assets/i18n/en.i18n.json
#   assets/i18n/tr.i18n.json

cd example_v2
dart run slang
```

Generated output lives in `lib/src/resources/resources*.g.dart`.  
App code imports slang as `import '.../resources.g.dart' as aura;` so it does not collide with `masterfabric_core`’s own `LocaleSettings` / `Translations`.

Defaults are also declared in `app_config.json` → `localizationConfiguration`.

---

<div align="center">

## Theme configuration

</div>

`assets/app_config.json` → `uiConfiguration` drives:

| Key | Effect |
|:--|:--|
| `themeMode` | `light` / `dark` / system via `AuraThemeConfig.themeMode()` |
| `fontScale` | Global text scale into `MasterApp` |
| `devModeGrid` / `devModeSpacer` | Core developer overlays |

Splash, feature flags, storage (`hiveCe`), and navigation defaults share the same file so the product stays **config-first**.

---

<div align="center">

## Run

</div>

```bash
cd example_v2
flutter pub get
dart run slang          # after editing i18n JSON
flutter run
```

**Requirements:** Flutter ≥ 3.44 · Dart SDK ^3.12 · iOS 15+

Optional Apple targets: Home Widget (`AuraWidget`), Live Activity, Watch (`AuraWatch`) — see `ios/`.

App icon source: `assets/icons/app_icon_1024.png` and iOS `AppIcon.appiconset` (marketing 1024 used for `docs/brand/app_icon.png` with iOS-style corner radius).

---

<div align="center">

## Regenerating screenshots

</div>

| Driver | Coverage |
|:--|:--|
| `integration_test/aura_screenshots_test.dart` | Launch → onboarding → permissions |
| `integration_test/aura_tabs_screenshots_test.dart` | Today / Log / Body / Coach / profile (`14`–`18`) |
| `test_driver/integration_test.dart` | Writes PNGs under `docs/screenshots/` |

```bash
cd example_v2
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/aura_tabs_screenshots_test.dart \
  -d <SIMULATOR_UDID>
```

Body baseline capture selects **Woman** before Continue so validation does not block the flow.

After a fresh capture, re-apply iOS-style corner masks on `docs/screenshots/*.png` (and rebuild `docs/brand/app_icon.png` from the iOS 1024 marketing icon) so GitHub renders rounded frames without relying on CSS alone.

---

<div align="center">

## Relation to `masterfabric_core`

</div>

| Layer | Lives in |
|:--|:--|
| Reusable Flutter architecture (views, storage, config, spacers, slang patterns) | `masterfabric_core` |
| AURA product UX, illustrations, coach copy, jobs, shell widgets | `example_v2` (this package) |

Treat AURA as the **worked example** of shipping on the core — not as a second framework.

---

<div align="center">

## Contact

[license@masterfabric.co](mailto:license@masterfabric.co)
·
[masterfabric.co](https://masterfabric.co)
·
[`masterfabric_core`](../)

<br />

**© 2025–2026 MASTERFABRIC Bilişim Teknoloji A.Ş.**  
AURA is a MasterFabric product.

</div>

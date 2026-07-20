<!--
  Sites / docs that allow HTML may use the Academy iframe embed:

  <iframe
    src="https://academy.masterfabric.co/embed/badge?credit=0&size=120&style=mark"
    title="MasterFabric Academy badge"
    width="220"
    height="160"
    style="border:0;overflow:hidden;background:#000"
    loading="lazy"
  ></iframe>

  GitHub README strips iframes — use the Markdown badge below instead.
-->

<p align="center">
  <a href="https://academy.masterfabric.co">
    <img src="../doc/assets/masterfabric-academy-badge.png" alt="MasterFabric Academy" width="120" />
  </a>
</p>

# MasterFabric Core Example

Showcase app for **`masterfabric_core` 2.0.0** on **Flutter ≥ 3.44 / Dart ≥ 3.12**.

Soft white UI, Lucide icons, and interactive demos for MasterApp, MasterViewCubit, helpers, and pre-built views.

---

## Requirements

| Requirement | Version |
|-------------|---------|
| Flutter | ≥ 3.44 |
| Dart | ≥ 3.12 |
| iOS (Simulator / device) | 15.0+ |
| Xcode | Full app (not Command Line Tools only) + license accepted |
| CocoaPods | Recommended for iOS plugins |

Package under test: path dependency `../` → **masterfabric_core 2.0.0**.

---

## What’s covered (2.0.0 / Flutter 3.44)

- Flutter 3.44 toolchain + major plugin APIs (notifications, share, permissions, …)
- Secure defaults: auth via secure storage, WebView allowlists, HTTPS downloads
- `StorageKeyMigrator` (`osmea_*` → `mf_*`)
- GetIt registration for **example** cubits (`HomeCubit`, helpers, …) — required by `MasterViewCubit`
- Targets: **iOS**, **Web**, **macOS**
- Modern ink + teal UI (Home grid, Core demos, Helpers hub)
- Stale `lib/gen/` slang duplicate removed; Home links previously orphan core routes

Upstream notes: [../README.md](../README.md) · [../CHANGELOG.md](../CHANGELOG.md) · [../doc/sync_gap_flutter_344.md](../doc/sync_gap_flutter_344.md)

---

## Run

```bash
cd example
flutter pub get
```

### iOS Simulator

```bash
# Prefer Xcode that matches your installed runtime (e.g. Xcode-beta for iOS 27)
sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer   # if needed
open -a Simulator
flutter devices
flutter run -d ios
```

First build may take several minutes (SPM + CocoaPods + Xcode).

### Web

```bash
flutter build web --debug --no-wasm-dry-run
# serve build/web, or:
flutter run -d web-server --web-port=8080
```

### macOS

```bash
flutter run -d macos
```

---

## Design system

- Soft white backgrounds, flat elevations (0), ~0.5px borders  
- Lucide icons (`lucide_icons_flutter`)  
- Theme via example `ThemeCubit` + `app_config.json`

---

## Features demonstrated

1. **MasterApp** — `runBefore`, hydrated storage, ATT, network init features  
2. **MasterViewCubit** — home / products / profile / helpers hub  
3. **Helpers** — device info, storage, HiveCE, datetime, URL launcher, permissions, share, download, config, package info, SVG, WebViewer, push, force update, skeleton, network info  
4. **Pre-built core views** — splash, auth (demo), onboarding, account, search, empty / error / loading / info  

---

## Project layout (simplified)

```
example/
├── lib/
│   ├── main.dart
│   ├── app/                 # DI, routes, App shell
│   ├── theme/
│   ├── views/               # home, products, profile, helpers, settings
│   └── src/resources/       # slang generated
├── assets/app_config.json
├── ios/                     # platform :ios, '15.0'
├── macos/
└── web/
```

DI entry: `lib/app/di/injection.dart`  
- `getIt.init()` (generated core helpers)  
- `_registerCoreCubits()`  
- `_registerExampleCubits()` ← **required** for Home and helper demos  

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `HomeCubit is not registered` | Ensure `_registerExampleCubits()` runs in `configureDependencies()` |
| Xcode “iOS 26.5 is not installed” / destination mismatch | Use Xcode whose Simulator SDK matches the booted runtime (e.g. Xcode 27 ↔ iOS 27) |
| Deployment target 13.0 errors | Keep Podfile / Runner at **15.0** |
| ATT always false on Simulator | Expected; test on device for real prompt |
| Web build `LucideIcons.github` | Brand icons removed in newer Lucide — use alternatives (e.g. `folderGit2`) |

---

## Learn more

- Package README: [../README.md](../README.md)  
- Security audit: [../doc/security_audit_owasp.md](../doc/security_audit_owasp.md)  
- [MasterFabric Academy](https://academy.masterfabric.co)

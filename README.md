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
    <img src="doc/assets/masterfabric-academy-badge.png" alt="MasterFabric Academy" width="120" />
  </a>
</p>

# masterfabric_core

[![pub package](https://img.shields.io/pub/v/masterfabric_core.svg)](https://pub.dev/packages/masterfabric_core)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.44-02569B?logo=flutter)](https://docs.flutter.dev/release/whats-new)
[![Dart](https://img.shields.io/badge/Dart-%5E3.12-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)
[![CI](https://img.shields.io/badge/CI-analyze%20%2B%20test-success)](.github/workflows/ci.yml)

**Version 2.1.0** — MasterFabric’s Flutter application core: architecture foundation (BLoC / Cubit / Hydrated), GoRouter, Injectable/GetIt, pre-built screens, and production helpers (storage, push, force-update, WebView, network, ATT, security).

---

## What’s new in 2.0.0 (Flutter 3.44)

This major release moves the package onto the **Flutter 3.44 / Dart 3.12** baseline and consolidates dependency majors, OWASP security remediations, and example-app runtime fixes into a single line.

### Platform & toolchain

| Item | 2.0.0 |
|------|--------|
| Flutter | `>=3.44.0` |
| Dart SDK | `^3.12.0` |
| iOS deployment target | **15.0** |
| Example targets | iOS · Web · macOS |

### Major dependency upgrades (highlights)

- `go_router` 17 · `get_it` 9 · `injectable` 3 · `hydrated_bloc` 11  
- Firebase Core 4 / Messaging 16 · `permission_handler` 12  
- `device_info_plus` 13 · `package_info_plus` 10 · `share_plus` 13  
- `flutter_local_notifications` 22 · `slang` 4.18 · `flutter_lints` 6  
- Unused `sqflite` removed · `flutter_secure_storage` added for auth secrets  

Full history: [CHANGELOG.md](CHANGELOG.md) · sync analysis: [doc/sync_gap_flutter_344.md](doc/sync_gap_flutter_344.md)

### Security (shipped in 2.0.0)

- WebView **secure-by-default** (file access off, mixed content blocked, permission deny, URL allowlist)  
- Auth tokens in **Keychain / Keystore** (`flutter_secure_storage`) via `useSecureStorageForAuth`  
- Download path sanitization + HTTPS-only · URL scheme allowlist (`UrlSecurity`)  
- Per-install device UUID (`InstallIdStore`) instead of Android build fingerprint  
- Optional Dio cert pinning (`CertificatePinning`) · PII redacted in bootstrap logs  
- Audit report: [doc/security_audit_owasp.md](doc/security_audit_owasp.md)

### Breaking changes for host apps

1. **Upgrade Flutter** to 3.44+ (and Dart 3.12+) before consuming `^2.1.0`.  
2. **iOS 15+** — raise `IPHONEOS_DEPLOYMENT_TARGET` / Podfile `platform :ios, '15.0'`.  
3. **Device ID** — `platformDeviceDeviceID()` is now a per-install UUID; use `platformBuildFingerprint()` for build diagnostics.  
4. **Auth storage** — set `storageConfiguration.useSecureStorageForAuth: true` (replaces unused `enableEncryption`).  
5. **WebView / downloads / URL launch** — untrusted input is rejected by default; pass allowlists / permission callbacks when you need looser behavior.  
6. **API surface of upgraded plugins** — e.g. local notifications named params, `SharePlus.instance.share(ShareParams(...))`.

### Migrating from 0.0.x

```bash
# 1) Toolchain
flutter --version   # expect 3.44.x / Dart 3.12.x

# 2) Dependency
# pubspec.yaml → masterfabric_core: ^2.1.0
flutter pub get

# 3) iOS
# example/ios/Podfile → platform :ios, '15.0'
# Runner IPHONEOS_DEPLOYMENT_TARGET = 15.0
cd ios && pod install && cd ..

# 4) Storage keys
# osmea_* → mf_* migrated once by StorageKeyMigrator on MasterApp.runBefore()
```

---

## Features

### Architecture & state

- `BaseViewBloc` / `BaseViewCubit` / `BaseViewHydratedCubit`
- `MasterView` / `MasterViewCubit` / `MasterViewHydratedCubit` + `MasterApp`
- Hydrated BLoC persistence · Injectable + GetIt DI (`CoreHelperModule`)

### Navigation & views

- GoRouter-ready `AppRoutes` (`/home`, `/auth`, `/onboarding`, `/empty`, `/error`, `/counter`, …)
- Pre-built: Splash, Onboarding, Auth (**demo-only** — `AuthCubit.isDemoAuth`), Account, Permissions, Search, Loading, Empty, Error, Info bottom sheet, Image detail, **Counter** (`MasterView` + Bloc sample)

### Helpers (selection)

| Area | Helpers |
|------|---------|
| Storage | `LocalStorageHelper`, `HiveCeStorageHelper`, `AuthStorageHelper`, `StorageKeys` / `StorageKeyMigrator` |
| Device / network | `DeviceInfoHelper`, `PackageInfoHelper`, `NetworkInfoHelper`, `NetworkInitFeature` |
| UX | `SvgHelper`, `SkeletonHelper`, `WebViewerHelper`, `UrlLauncherHelper`, `ApplicationShareHelper` |
| Platform | `PermissionHandlerHelper`, `LocalNotificationHelper`, `AppTrackingTransparencyHelper` |
| Product | `ForceUpdateHelper`, `PushNotificationHelper`, `FileDownloadHelper` |
| Security | `UrlSecurity`, `InstallIdStore`, `CertificatePinning` |

### Layout & i18n

- Grid / spacer layout utilities · Slang localization scaffolding

---

## Installation

### pub.dev

```yaml
dependencies:
  masterfabric_core: ^2.1.0
```

```bash
flutter pub get
```

### Git (development)

```yaml
dependencies:
  masterfabric_core:
    git:
      url: https://github.com/masterfabric-mobile/masterfabric_core.git
      ref: v2.1.0   # or main
```

---

## Requirements

- **Dart** `^3.12.0`
- **Flutter** `>=3.44.0`
- **iOS** 15.0+ (ATT + CocoaPods / SPM as used by plugins)
- See root `pubspec.yaml` for the full dependency set

---

## Quick Start

### 1. Bootstrap with `MasterApp`

```dart
import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true,
    requestTrackingTransparency: true,
    networkFeatures: {
      NetworkInitFeature.cloudflareTrace,
      NetworkInitFeature.connectivity,
    },
  );

  final router = GoRouter(routes: [/* your routes */]);
  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MasterApp(
      router: router,
      shouldSetOrientation: true,
      preferredOrientations: const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }
}
```

### 2. Screen bases (both first-class)

Use **`MasterViewCubit`** for imperative Cubit state, or **`MasterView`** for event-driven Bloc:

```dart
// Cubit path
class ProductsView extends MasterViewCubit<ProductsCubit, ProductsState> {
  ProductsView({super.key, required super.goRoute})
      : super(currentView: MasterViewCubitTypes.content);

  @override
  Future<void> initialContent(ProductsCubit viewModel, BuildContext context) async {
    await viewModel.loadProducts();
  }

  @override
  Widget viewContent(BuildContext context, ProductsCubit viewModel, ProductsState state) {
    return const SizedBox.shrink();
  }
}

// Bloc path — see package CounterView / CounterBloc (/counter)
class OrdersView extends MasterView<OrdersBloc, OrdersEvent, OrdersState> {
  OrdersView({super.key, required super.goRoute})
      : super(currentView: MasterViewTypes.content);

  @override
  void initialContent(OrdersBloc viewModel, BuildContext context) {
    viewModel.add(const OrdersStarted());
  }

  @override
  Widget viewContent(BuildContext context, OrdersBloc viewModel, OrdersState state) {
    return const SizedBox.shrink();
  }
}
```

Register Blocs/Cubits in GetIt (example app uses `_registerCoreCubits()` / `_registerExampleCubits()` — host apps must register their own view models the same way).

### 3. Storage & secure auth

```json
{
  "storageConfiguration": {
    "localStorageType": "hiveCe",
    "useSecureStorageForAuth": true,
    "cacheDurationDays": 7,
    "maxCacheSizeMb": 100
  }
}
```

- `"sharedPreferences"` — default, backward compatible  
- `"hiveCe"` — high-performance box storage  
- Auth tokens always prefer secure storage when the flag is enabled  

Legacy `osmea_*` keys migrate once to `mf_*` via `StorageKeyMigrator`.

### 4. iOS App Tracking Transparency

`Info.plist`:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use this data to improve your experience.</string>
```

```dart
await MasterApp.runBefore(
  assetConfigPath: 'assets/app_config.json',
  hydrated: true,
  requestTrackingTransparency: true,
);
```

Result is stored as `mf_tracking_authorized`.

### 5. Network init features

| Feature | Persisted keys (prefix `mf_`) |
|---------|-------------------------------|
| `cloudflareTrace` | `cf_ip`, `cf_location`, `cf_colo`, `cf_tls`, `cf_http`, `cf_warp` |
| `publicIP` | `public_ip` |
| `connectivity` | `connection_type`, `is_connected` |
| `wifiInfo` | `wifi_name`, `wifi_ip`, `wifi_gateway` |

Values may be redacted in debug logs; collect only what your privacy policy allows.

### 6. Force update

```json
{
  "forceUpdateConfiguration": {
    "latestVersion": "2.0.0",
    "minimumVersion": "2.0.0",
    "releaseNotes": "Flutter 3.44 baseline and security hardening",
    "storeUrl": {
      "ios": "https://apps.apple.com/app/id123456789",
      "android": "https://play.google.com/store/apps/details?id=com.example.app"
    }
  }
}
```

### 7. Security helpers (opt-in)

```dart
// HTTPS + scheme allowlist
UrlSecurity.isHttpsUrl(url);
UrlSecurity.isAllowedUrl(url, allowedSchemes: UrlSecurity.defaultLaunchSchemes);

// Optional certificate pinning for Dio
final dio = CertificatePinning.createPinnedDio(
  allowedSha256Fingerprints: ['https://example.com#SHA256_HEX'],
);
```

---

## Example app

Interactive showcase under [`example/`](example/):

```bash
cd example
flutter pub get
flutter run -d ios          # Simulator / device (Xcode + CocoaPods)
flutter run -d web-server   # or open build/web after flutter build web
flutter run -d macos
```

Details: [example/README.md](example/README.md)

---

## Package structure

```
lib/
├── masterfabric_core.dart
└── src/
    ├── base/          # MasterApp, MasterView*, BaseView*
    ├── helper/        # utilities + security/
    ├── views/         # pre-built screens + cubits
    ├── models/
    ├── layout/
    ├── resources/
    └── di/
ios/                   # ATT MethodChannel plugin (podspec 2.0.0)
example/               # showcase (iOS / web / macOS)
doc/                   # audits, sync gap, Academy assets
test/                  # unit tests
.github/workflows/     # CI (Flutter 3.44.6 analyze + test + pub outdated)
```

---

## Documentation

| Doc | Purpose |
|-----|---------|
| [CHANGELOG.md](CHANGELOG.md) | Release history (2.0.0 breaking notes) |
| [doc/sync_gap_flutter_344.md](doc/sync_gap_flutter_344.md) | Flutter 3.44 parity / phase status |
| [doc/security_audit_owasp.md](doc/security_audit_owasp.md) | OWASP findings + remediation status |
| [doc/analysis.md](doc/analysis.md) | Historical OSMEA snapshot (superseded) |
| [MasterFabric Academy](https://academy.masterfabric.co) | Agentic AI developer curriculum |

---

## Package information

- **Version**: 2.1.0  
- **Pub.dev**: https://pub.dev/packages/masterfabric_core  
- **GitHub**: https://github.com/gurkanfikretgunak/masterfabric_core  
- **Org remote**: https://github.com/masterfabric-mobile/masterfabric_core  
- **License**: AGPL-3.0  
- **Academy**: https://academy.masterfabric.co  

## Contributing

PRs welcome. Prefer small, focused changes; keep `dart analyze` / `flutter test` green on Flutter 3.44.

## License

GNU AGPL v3.0 — see [LICENSE](LICENSE).

## Related

- [osmea](https://github.com/masterfabric-mobile/osmea) — component ecosystem (optional; not a hard dependency of this package)

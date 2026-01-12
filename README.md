# masterfabric_core

[![pub package](https://img.shields.io/pub/v/masterfabric_core.svg)](https://pub.dev/packages/masterfabric_core)
[![License](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)](LICENSE)

A comprehensive Flutter package providing core utilities, base classes, and shared logic for building scalable Flutter applications. MasterFabric Core serves as the foundational layer for MasterFabric projects, offering a complete architecture with state management, navigation, dependency injection, and pre-built views.

## Features

### 🏗️ Architecture & State Management
- **Base View Classes**: `BaseViewBloc`, `BaseViewCubit`, `BaseViewHydratedCubit` for different state management needs
- **Master View System**: Unified view management with `MasterView`, `MasterViewCubit`, and `MasterViewHydratedCubit`
- **State Persistence**: Hydrated BLoC support for state persistence across app restarts
- **View Models**: Base classes for business logic separation

### 🧭 Navigation & Routing
- **GoRouter Integration**: Pre-configured routing with `AppRoutes`
- **Route Management**: Centralized route definitions and navigation helpers

### 🎨 Pre-built Views
- **SplashView**: App launch screen with loading logic
- **OnboardingView**: User onboarding flow
- **AuthView**: Authentication screen with Sign In/Sign Up tabs
- **AccountView**: User account management screen
- **PermissionsView**: Runtime permission request screens
- **ErrorHandlingView**: Error display and recovery
- **LoadingView**: Loading state views
- **EmptyView**: Empty state views
- **InfoBottomSheetView**: Information bottom sheets
- **ImageDetailView**: Image detail viewer
- **SearchView**: Search functionality interface

### 🛠️ Helper Utilities
- **LocalStorageHelper**: Multi-backend local storage with SharedPreferences and HiveCE support
  - Storage type switching via `LocalStorageType` enum
  - Automatic storage type configuration from `app_config.json`
  - Backward compatible with existing SharedPreferences implementation
- **HiveCeStorageHelper**: HiveCE storage implementation for high-performance data persistence
- **AuthStorageHelper**: Authentication data persistence
- **PermissionHandlerHelper**: Runtime permissions management
- **LocalNotificationHelper**: Local push notifications
- **FileDownloadHelper**: File downloads with progress tracking
- **DateTimeHelper**: Date and time operations and formatting
- **UrlLauncherHelper**: External URL and app launching
- **ApplicationShareHelper**: Content sharing functionality
- **DeviceInfoHelper**: Device information retrieval
- **AssetConfigHelper**: JSON config management from assets
- **GridHelper**: Grid layout calculation utilities
- **SpacerHelper**: UI spacing utilities
- **CommonLoggerHelper**: Logging utilities
- **SvgHelper**: SVG rendering from assets, network, string, and file sources
  - Color tinting and theming support
  - Reusable configurations with `SvgConfig`
  - Placeholder and error widget support for network SVGs
- **PushNotificationHelper**: Multi-provider push notification management
  - OneSignal and Firebase FCM support
  - Topic subscriptions and user targeting
  - Permission handling and token management
- **WebViewerHelper**: HTML and WebView rendering
  - Sanitized HTML rendering
  - Custom styling support
  - Full WebView for URLs
- **ForceUpdateHelper**: App version checking and update prompts
  - Multiple version providers (config file, API, Remote Config)
  - Multiple UI styles (dialog, bottom sheet, full screen)
  - Semantic version comparison
  - Store redirects (App Store, Play Store, custom URLs)
  - Customizable strings for localization
- **SkeletonHelper**: Comprehensive skeleton loading placeholders
  - 10 animation styles: shimmer, pulse, wave, glow, slide, bounce, breathe, gradientFlow, sparkle, none
  - Shape widgets: rectangle, circle, rounded, text, avatar, custom
  - Preset widgets: list item, card, profile, article, product, social post, story
  - Theme support with `SkeletonTheme` and `SkeletonConfig`
  - Custom shapes with `DiamondClipper`, `HexagonClipper`, `StarClipper`

### 📐 Layout System
- **Grid**: Responsive grid layout system
- **Spacer**: Consistent spacing utilities

### 🔌 Dependency Injection
- **Injectable Integration**: Pre-configured dependency injection setup
- **GetIt Integration**: Service locator pattern support

### 🌍 Localization
- **Slang Integration**: i18n support with Slang
- **Translation Support**: English translation file structure

## Installation

### From pub.dev (Recommended)

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  masterfabric_core: ^0.0.13
```

Then run:

```bash
flutter pub get
```

### From Git (Development)

For the latest development version, you can use:

```yaml
dependencies:
  masterfabric_core:
    git:
      url: https://github.com/gurkanfikretgunak/masterfabric_core.git
      ref: dev  # or use a specific tag/commit
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Setup Your App with MasterApp

```dart
import 'package:flutter/material.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize MasterApp components (loads config and sets storage type)
  await MasterApp.runBefore(
    assetConfigPath: 'assets/app_config.json',
    hydrated: true, // Enable state persistence
  );
  
  // Create your router
  final router = GoRouter(
    routes: [
      // Your routes here
    ],
  );
  
  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  
  const MyApp({super.key, required this.router});
  
  @override
  Widget build(BuildContext context) {
    return MasterApp(
      router: router,
      shouldSetOrientation: true,
      preferredOrientations: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      showPerformanceOverlay: false,
      textDirection: TextDirection.ltr,
      fontScale: 1.0,
    );
  }
}
```

### 2. Create a View with MasterView

```dart
import 'package:masterfabric_core/masterfabric_core.dart';

class ProductsView extends MasterView<ProductsCubit, ProductsState> {
  ProductsView({super.key}) : super(currentView: MasterViewTypes.content);

  @override
  void initialContent(ProductsCubit cubit, BuildContext context) {
    cubit.loadProducts();
  }

  @override
  Widget viewContent(BuildContext context, ProductsCubit cubit, ProductsState state) {
    if (state.isLoading) {
      return LoadingView();
    }
    
    if (state.hasError) {
      return ErrorHandlingView(error: state.error);
    }
    
    return ListView.builder(
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        return ProductItem(product: state.products[index]);
      },
    );
  }
}
```

### 3. Use Pre-built Views

```dart
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:go_router/go_router.dart';

// In your router configuration
GoRoute(
  path: '/auth',
  builder: (context, state) => AuthView(
    goRoute: (path) => context.go(path),
    arguments: state.uri.queryParameters,
  ),
),

GoRoute(
  path: '/onboarding',
  builder: (context, state) => OnboardingView(
    config: onboardingConfig,
    goRoute: (path) => context.go(path),
    arguments: state.uri.queryParameters,
  ),
),
```

### 4. Configure Storage Backend

Storage backend can be configured in `app_config.json`:

```json
{
  "storageConfiguration": {
    "localStorageType": "hiveCe",
    "enableEncryption": false,
    "cacheDurationDays": 7,
    "maxCacheSizeMb": 100
  }
}
```

Supported values for `localStorageType`:
- `"sharedPreferences"` - Default, uses SharedPreferences (backward compatible)
- `"hiveCe"` - Uses HiveCE for high-performance storage

### 4b. Configure Force Update

Force update configuration in `app_config.json`:

```json
{
  "forceUpdateConfiguration": {
    "latestVersion": "2.0.0",
    "minimumVersion": "1.0.0",
    "releaseNotes": "Bug fixes and new features",
    "features": ["New feature 1", "Performance improvements"],
    "storeUrl": {
      "ios": "https://apps.apple.com/app/id123456789",
      "android": "https://play.google.com/store/apps/details?id=com.example.app"
    }
  }
}
```

Update types:
- **Force**: Current version < minimumVersion (blocking, user must update)
- **Recommended**: Current version < latestVersion with minimumVersion set
- **Optional**: Current version < latestVersion without minimumVersion

### 5. Use Helper Utilities

```dart
import 'package:masterfabric_core/masterfabric_core.dart';

// Local Storage
// Storage type is automatically configured from app_config.json
// Or set manually:
LocalStorageHelper.setStorageType(LocalStorageType.hiveCe); // or LocalStorageType.sharedPreferences

await LocalStorageHelper.setString('key', 'value');
final value = LocalStorageHelper.getString('key');

// Get value by key (supports any type, async)
final dynamicValue = await LocalStorageHelper.getByKey('key');

// Get all items from database
final allItems = await LocalStorageHelper.getAllItems();

// Check if key exists
final exists = LocalStorageHelper.hasKey('key');

// Permissions
final permissionHelper = PermissionHandlerHelper();
final granted = await permissionHelper.requestPermission(Permission.camera);

// Date Formatting
final formatted = DateTimeHelper.formatDate(DateTime.now(), 'yyyy-MM-dd');

// URL Launcher
await UrlLauncherHelper.launchUrl('https://example.com');

// Device Info
final deviceInfo = DeviceInfoHelper();
final platform = await deviceInfo.getPlatform();

// SVG Helper
SvgHelper.fromAsset('assets/icons/home.svg', width: 24, height: 24, color: Colors.blue);
SvgHelper.fromNetwork('https://example.com/logo.svg', placeholder: CircularProgressIndicator());
SvgHelper.themedIcon(context, 'assets/icons/star.svg'); // Auto-colored from IconTheme

// Force Update Helper
await ForceUpdateHelper.instance.initialize(
  ForceUpdateConfig(
    providerType: VersionProviderType.configFile,
    storeConfig: StoreConfig(
      appStoreId: '123456789',
      playStorePackage: 'com.example.app',
    ),
  ),
);

final updateInfo = await ForceUpdateHelper.instance.checkForUpdate();
if (updateInfo.hasUpdate) {
  await ForceUpdateHelper.instance.showUpdateUI(context, updateInfo);
}

// Skeleton Helper
// Simple shapes
SkeletonHelper.rectangle(width: 200, height: 40);
SkeletonHelper.circle(size: 48);
SkeletonHelper.text(lines: 3);

// Presets
SkeletonHelper.listItem(lines: 2);
SkeletonHelper.card(imageHeight: 150);
SkeletonHelper.socialPost(showImage: true);

// With animation type
SkeletonTheme(
  config: SkeletonConfig(
    animationType: SkeletonAnimationType.pulse,
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
  ),
  child: SkeletonHelper.productGrid(itemCount: 4),
);

// Dark theme
SkeletonTheme(
  config: SkeletonConfig.dark(),
  child: Column(
    children: [
      SkeletonHelper.listItem(),
      SkeletonHelper.listItem(),
    ],
  ),
);
```

## Package Structure

```
lib/
├── masterfabric_core.dart          # Main library export
└── src/
    ├── base/                       # Base classes and architecture
    │   ├── base_view_*.dart        # Base view classes
    │   ├── master_view/            # Master view system
    │   └── widgets/                # Base widgets
    ├── helper/                     # Utility helpers
    ├── views/                      # Pre-built views
    ├── models/                     # Data models
    ├── layout/                     # Layout utilities
    ├── resources/                  # Generated resources
    └── di/                         # Dependency injection
```

## Requirements

- Dart SDK: `^3.9.2`
- Flutter: `>=1.17.0`

## Dependencies

### Core Dependencies
- `flutter_bloc: ^9.1.0` - State management
- `hydrated_bloc: ^10.1.1` - State persistence
- `go_router: ^15.1.1` - Navigation
- `injectable: ^2.7.1` - Dependency injection
- `slang: ^4.11.1` - Localization
- `hive_ce: ^2.16.0` - High-performance NoSQL database (optional storage backend)
- `flutter_svg: ^2.2.3` - SVG rendering support

### See `pubspec.yaml` for complete dependency list

## Documentation

For detailed documentation, see:
- [CHANGELOG.md](CHANGELOG.md) - Version history and changes
- [doc/analysis.md](doc/analysis.md) - Architecture analysis

## Package Information

- **Pub.dev**: [https://pub.dev/packages/masterfabric_core](https://pub.dev/packages/masterfabric_core)
- **GitHub**: [https://github.com/gurkanfikretgunak/masterfabric_core](https://github.com/gurkanfikretgunak/masterfabric_core)
- **Version**: 0.0.13
- **License**: AGPL-3.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GNU AGPL v3.0 License - see the [LICENSE](LICENSE) file for details.

## Related Packages

- [osmea_components](https://github.com/masterfabric-mobile/osmea) - UI component library

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/gurkanfikretgunak/masterfabric_core).

## Publishing

This package is published on [pub.dev](https://pub.dev/packages/masterfabric_core). You can install it directly using:

```bash
flutter pub add masterfabric_core
```

Or add it manually to your `pubspec.yaml`:

```yaml
dependencies:
  masterfabric_core: ^0.0.13
```

---

**Published Package**: This package is available on [pub.dev](https://pub.dev/packages/masterfabric_core). For the latest stable version, use the pub.dev installation method above.


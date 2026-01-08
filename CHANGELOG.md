# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.9] - 2026-01-08

### Added

#### Force Update Helper Module
- `ForceUpdateHelper` - App version checking and update prompt management
  - `initialize()` - Initialize with config file, API, or custom provider
  - `checkForUpdate()` - Check for available updates
  - `showUpdateUI()` - Display update prompt with configurable UI style
  - `openStore()` - Redirect to App Store / Play Store
- Multiple version providers:
  - `ConfigFileProvider` - Read version info from `app_config.json`
  - `ApiVersionProvider` - Fetch version info from API endpoint
  - `RemoteConfigProvider` - Firebase Remote Config integration (adapter-based)
- Multiple UI styles:
  - `UpdateAlertDialog` - Dismissible/non-dismissible dialog
  - `UpdateBottomSheet` - Modal bottom sheet style
  - `ForceUpdateScreen` - Full screen blocking page for force updates
- `VersionComparator` - Semantic version comparison (supports `1.0.0-beta`, `1.0.0+build`)
- `StoreRedirector` - Platform-aware store redirects (App Store, Play Store, custom URLs)
- Models: `UpdateInfo`, `ForceUpdateConfig`, `StoreConfig`, `UpdateType`, `UpdateUIType`
- Customizable strings via `ForceUpdateStrings` for localization

#### Example App
- Force Update demo view (`force_update_view.dart`)
  - Status display with initialization
  - UI type selector (dialog, bottom sheet, full screen)
  - Simulation mode for testing different version scenarios
  - Preview buttons for optional, recommended, and force updates
  - Version comparison examples
- Force Update route added to helpers hub
- `forceUpdateConfiguration` added to `app_config.json`

### Fixed

#### Example App Navigation
- Fixed back button not working on helper views
- Changed navigation from `context.go()` to `context.push()` for helper routes
- Back button now properly pops navigation stack on all helper demo views

[0.0.9]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.9

## [0.0.8] - 2026-01-08

### Added

#### Push Notification Helper Module
- `PushNotificationHelper` - Unified push notification management with multi-provider support
  - `initialize()` - Initialize with OneSignal, Firebase, or both providers
  - `requestPermission()` - Request notification permissions
  - `getDeviceTokens()` - Get device tokens for all active providers
  - `subscribeToTopic()` / `unsubscribeFromTopic()` - Topic management
  - `setUserId()` / `removeUserId()` - User targeting
  - `sendLocalNotification()` - Send local notifications
- `PushNotificationProviderBase` - Abstract base for custom providers
- `OneSignalProvider` - OneSignal push notification integration
- `FirebaseProvider` - Firebase Cloud Messaging integration
- Push notification models: `PushNotificationToken`, `PushNotificationPermission`

#### Web Viewer Helper Module
- `WebViewerHelper` - HTML and WebView rendering utilities
  - `html()` - Render sanitized HTML content
  - `styledHtml()` - Render HTML with custom styling
  - `webView()` - Full WebView for URLs
  - `htmlWidget()` - Flutter widget from HTML
- `HtmlStyleConfig` - Configurable HTML styling options
- `HtmlViewerCubit` and `WebViewerCubit` for state management
- HTML rendering widgets with safe content handling

#### Example App
- Push Notification demo view (`push_notification_view.dart`)
  - Provider status display (OneSignal, Firebase)
  - Permission request and status
  - Device token display with copy functionality
  - Topic subscription management
  - User ID targeting
- Web Viewer demo view (`web_viewer_demo_view.dart`)
  - HTML tab: Sanitized HTML rendering
  - Styled tab: Custom styled HTML
  - Widget tab: HTML as Flutter widgets
  - URL tab: Full WebView for URLs

### Fixed

#### Example App
- Fixed "InkWell requires a Material ancestor" error on iOS
- `PlatformScaffold` now wraps body in `Material` widget on iOS for CupertinoPageScaffold compatibility

### Dependencies
- Added `onesignal_flutter: ^5.3.5` for OneSignal push notifications
- Added `firebase_core: ^3.12.1` and `firebase_messaging: ^15.2.4` for Firebase push notifications

[0.0.8]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.8

## [0.0.7] - 2026-01-08

### Added

#### SVG Helper Module
- `SvgHelper` - Comprehensive SVG rendering helper class with multiple source support
  - `fromAsset()` - Load SVG from asset path with color tinting, sizing, and accessibility
  - `fromNetwork()` - Load SVG from URL with caching, placeholder, and error widget support
  - `fromString()` - Render SVG from raw string data (useful for API responses)
  - `fromFile()` - Load SVG from File object
  - `icon()` - Convenience method for icon-sized SVGs with standard sizing
  - `themedIcon()` - Auto-colored icons using IconTheme from context
- `SvgConfig` - Reusable configuration class for SVG rendering options
  - Properties: `width`, `height`, `color`, `fit`, `alignment`, `semanticsLabel`, `placeholder`, `errorWidget`
  - Preset configs: `SvgConfig.smallIcon` (24x24), `SvgConfig.mediumIcon` (32x32), `SvgConfig.largeIcon` (48x48)
  - `copyWith()` method for easy customization

#### Example App
- SVG Helper demo view (`svg_view.dart`) with interactive examples:
  - Asset SVG loading with grid of sample icons
  - Color tinting with interactive color picker
  - Size variations demo (24px to 96px)
  - SVG from String rendering with code preview
  - Themed Icon demo showing IconTheme integration
  - SvgConfig usage examples with preset configurations
- Sample SVG assets: `home.svg`, `settings.svg`, `star.svg`, `heart.svg`, `user.svg`, `search.svg`
- SVG demo route added to helpers hub

### Dependencies
- Added `flutter_svg: ^2.2.3` dependency for SVG rendering support

[0.0.7]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.7

## [0.0.6] - 2026-01-07

### Fixed
- Fixed async/await issue in `LocalStorageHelper.getByKey()` method
- `getByKey()` now properly awaits initialization before retrieving values from HiveCE
- Fixed HiveCE storage retrieval to properly handle async operations
- Improved error handling in `HiveCeStorageCubit.getByKey()` method

### Changed
- `LocalStorageHelper.getByKey()` is now async and properly initializes storage before access
- Updated HiveCE example view to show "Key Not Found" message when value is null
- Improved UI feedback in Get by Key section with color-coded success/error states

### Example App UI Redesign
- Redesigned entire example app with minimalist, developer-friendly aesthetic
- Removed all shadows and rounded corners for a flat, clean look
- New monochrome color palette with accent colors for status indicators
- Thin 1px borders instead of shadows for card separation
- Monospace font for code values and keys
- Compact, dense layouts optimized for developer workflows
- Updated views: Home, Products, Profile, Helpers Hub, and all helper demo views
- Consistent design language across all screens

[0.0.6]: https://github.com/gurkanfikretgunak/masterfabric_core/compare/v0.0.5...v0.0.6

## [0.0.5] - 2026-01-07

### Added

#### Storage Module
- `LocalStorageType` enum - Storage backend selection enum with `sharedPreferences` and `hiveCe` options
- `HiveCeStorageHelper` - HiveCE storage implementation with full CRUD operations
- Storage type switching support in `LocalStorageHelper` via `setStorageType()` method
- Storage type configuration in `app_config.json` via `storageConfiguration.localStorageType` field
- MasterApp automatically reads and sets storage type from configuration
- Storage type displayed in CONFIGURATION LOADED debug output

#### Example App
- HiveCE Storage demo view (`hive_ce_storage_view.dart`)
- HiveCE Storage cubit and state (`hive_ce_storage_cubit.dart`, `hive_ce_storage_state.dart`)
- "All Items in Database" section showing all stored items with keys, types, and values
- Refresh functionality to reload all items from database
- HiveCE demo route added to helpers hub

### Changed
- `LocalStorageHelper` now supports multiple storage backends (SharedPreferences and HiveCE)
- Storage backend is selected based on `storageConfiguration.localStorageType` in app config
- Default storage type is `sharedPreferences` for backward compatibility
- CONFIGURATION LOADED output now includes storage type information

### Dependencies
- Added `hive_ce: ^2.16.0` dependency for HiveCE storage support

[0.0.5]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.5

## [0.0.4] - 2025-12-24

### Changed

#### Example App
- Refactored all helper demonstration views to follow consistent feature pattern
- Reorganized helper views into structured folders with cubit/state architecture:
  - `device_info/` - Device Info Helper demo with cubit/state
  - `storage/` - Local Storage Helper demo with cubit/state
  - `datetime/` - DateTime Helper demo with cubit/state
  - `url_launcher/` - URL Launcher Helper demo with cubit/state
  - `permissions/` - Permissions Helper demo with cubit/state (renamed to `HelperPermissionsCubit/State` to avoid conflicts)
  - `share/` - Share Helper demo with cubit/state
  - `download/` - File Download Helper demo with cubit/state
  - `config/` - App Config Helper demo with cubit/state
  - `package_info/` - Package Info Helper demo with cubit/state
- All helper views now use `MasterViewCubit` pattern matching `HomeView` structure
- Updated routes configuration to use new helper view structure
- Updated GetIt dependency injection to register all helper cubits
- Improved code organization and maintainability

### Fixed
- Resolved naming conflicts with `PermissionsState` and `PermissionsCubit` from masterfabric_core
- Fixed linting errors in helper views

### Changed
- Version bump to 0.0.4

[0.0.4]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.4

## [0.0.3] - 2025-12-23

### Added

#### Example App
- Complete example application demonstrating `masterfabric_core` usage
- Example app structure with features (home, products, profile)
- Example screens demonstrating `MasterViewCubit` pattern:
  - `HomeView` - Home screen with device info and storage examples
  - `ProductsView` - Products list with loading, error, and success states
  - `ProfileView` - Profile screen with user information
- Example cubits and states showing state management patterns
- Example routes configuration with GoRouter
- Example `main.dart` showing `MasterApp` initialization
- Example `README.md` with usage patterns and documentation
- Example app configuration (`app_config.json`)
- GetIt dependency injection setup examples
- AppBar customization examples with back button and actions

### Changed
- Version bump to 0.0.3

[0.0.3]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.3

## [0.0.1] - 2025-12-23

### Added

#### Base Module
- `BaseViewBloc` - Abstract BLoC-based view class
- `BaseViewCubit` - Abstract Cubit-based view class
- `BaseViewHydratedCubit` - Persisted Cubit view class with state persistence
- `BaseViewModel` - Base view model class
- `BaseViewModelCubit` - Cubit-based view model
- `BaseViewModelHydratedCubit` - Hydrated view model with persistence
- `BaseViewState` - Base state management class with common states (sealed class)
- `MasterView` - Unified view management interface with enums and mixins
- `MasterApp` - Main application wrapper with initialization and configuration
- `MasterViewCubit` - Cubit-based master view with enums and mixins
- `MasterViewHydratedCubit` - Hydrated master view with persistence, enums, mixins, and initialization
- `MasterScaffoldWidget` - Common scaffold widget with osmea_components integration
- `HydratedBlocInit` - Hydrated bloc storage initialization helper

#### Helper Module
- `LocalStorageHelper` - SharedPreferences wrapper for local storage (static API)
- `AuthStorageHelper` - Authentication data persistence helper
- `SpacerHelper` - UI spacing utilities with CoreSpacerType enum
- `UrlLauncherHelper` - External URL and app launching
- `WebViewerHelper` - HTML/WebView rendering utilities
- `ApplicationShareHelper` - Content sharing functionality
- `DateTimeHelper` - Date and time operations and formatting
- `DoubleExtensionHelper` - Number formatting extensions
- `PriceInfoCurrencyHelper` - Currency formatting utilities
- `FirstLetterCapitalizeHelper` - String capitalization helpers
- `GridHelper` - Grid layout calculation utilities
- `DeviceInfoHelper` - Device information retrieval (singleton pattern)
- `PermissionHandlerHelper` - Runtime permissions management with abstract base and models
- `LocalNotificationHelper` - Local push notifications
- `FileDownloadHelper` - File downloads with progress tracking
- `AssetConfigHelper` - JSON config management from assets with fallback support (camelCase keys)
- `PackageInfoHelper` - Package information retrieval (app name, version, build number)
- `OnboardingStorageHelper` - Onboarding flow storage (uses LocalStorageHelper)
- `CommonLoggerHelper` - Logging utilities

#### Views Module
- `SplashView` - App launch screen with loading logic and multiple style support
  - `SplashStartupWidget` - Basic splash style with logo and loading indicator
  - `SplashSpaceWidget` - Ultra-minimalist text-based splash style
  - `SplashEnterpriseWidget` - Professional corporate card-based splash style
- `OnboardingView` - User onboarding flow with cubit and state management
- `AuthView` - Authentication screen with Sign In/Sign Up tabs and cubit/state
- `AccountView` - User account management screen with cubit and state
- `PermissionsView` - Permission request screens with cubit and state
- `ErrorHandlingView` - Error display and recovery with cubit and state
- `LoadingView` - Loading state views with cubit and state
- `EmptyView` - Empty state views with cubit and state
- `InfoBottomSheetView` - Information bottom sheets with cubit and state
- `ImageDetailView` - Image detail viewer with cubit and state
- `SearchView` - Search functionality interface with cubit and state
- `AppRoutes` - Route definitions with GoRouter integration

#### Models Module
- `LoadingModel` - Loading state configurations
- `LoadingConfig` - Loading configuration with type, message, dismissible, and timeout
- `LoadingType` enum - Loading indicator types (circular, linear, custom)
- `ErrorModel` - Error handling data models
- `OnboardingPageModel` - Individual onboarding page configuration
- `OnboardingConfig` - Onboarding flow configuration with pages and button text
- `SplashConfigModel` - Splash screen configurations with style support
- `SplashStyle` enum - Splash style options (startup, space, enterprise)
- `SplashFlowState` enum - Splash flow states
- `SplashAction` enum - Splash actions
- `EmptyViewModel` - Empty state configurations
- `InfoModel` - Info sheet configurations

#### Layout Module
- `Grid` - Grid layout system with responsive calculations and dev mode overlay (`DevGridOverlay`)
- `Spacer` - Spacing utilities for consistent UI (`CoreSpacer`, `NavbarArea`, `FooterArea`)
- `CoreSpacerType` enum - Spacer types (navbar, footer, content, section, horizontal, vertical)

#### Dependency Injection
- Injectable configuration setup with code generation
- GetIt integration structure
- Injection configuration files (`injection.dart`, `injection.config.dart`)

#### Localization
- Slang configuration for i18n (`slang.yaml`)
- English translation file (`assets/i18n/en.i18n.json`)
- Generated resources (`resources.g.dart`, `resources_en.g.dart`)
- Translation keys organized by view (common, auth, account, onboarding, permissions, search, error, splash, etc.)

#### Configuration
- `pubspec.yaml` with all required dependencies
- `slang.yaml` for localization configuration
- `app_config.json` for app configuration with fallback support (camelCase format)
  - `appSettings` - App name, version, environment, debug mode, maintenance mode
  - `uiConfiguration` - Theme mode, font scale, dev mode settings
  - `splashConfiguration` - Splash screen style, duration, colors, logo settings
  - `featureFlags` - Feature toggles (onboarding, analytics, etc.)
  - `navigationConfiguration` - Default routes, deep linking
  - `apiConfiguration` - API base URL, timeout, retry settings
  - `permissionsConfiguration` - Required and optional permissions
  - `localizationConfiguration` - Default locale, supported locales
  - `storageConfiguration` - Encryption, cache settings

### Dependencies
- State Management: `flutter_bloc` (^9.1.0), `hydrated_bloc` (^10.1.1), `equatable` (^2.0.7)
- Navigation: `go_router` (^15.1.1)
- Dependency Injection: `injectable` (^2.7.1), `get_it` (^8.3.0)
- Localization: `slang` (^4.11.1), `slang_flutter` (^4.11.0)
- Utilities: `logger` (^2.5.0), `dio` (^5.7.0), `shared_preferences` (^2.5.3), `sqflite` (^2.4.2), `url_launcher` (^6.3.1), `intl` (^0.20.0)
- System: `device_info_plus` (^11.4.0), `package_info_plus` (^8.3.0), `permission_handler` (^11.2.0), `path_provider` (^2.1.5)
- UI: `flutter_html` (^3.0.0), `flutter_inappwebview` (^6.1.5), `webview_flutter` (^4.10.0)
- Notifications: `flutter_local_notifications` (^19.4.2), `timezone` (^0.10.1)
- Sharing: `share_plus` (^10.1.4)

### Dev Dependencies
- `flutter_test` - Flutter testing framework
- `flutter_lints` (^5.0.0) - Linting rules
- `build_runner` (^2.4.7) - Code generation
- `injectable_generator` (^2.11.1) - Injectable code generation
- `slang_build_runner` (^4.8.0) - Slang code generation

### Documentation
- Comprehensive README.md with usage examples
- Package structure documentation
- Architecture overview
- Quick start guide

[0.0.1]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.1

## [0.0.2] - 2025-12-23

### Changed
- Migrated from `osmea_components` to Material Design widgets
- All UI components now use Flutter's built-in Material widgets
- Updated `MasterScaffoldWidget` to use Material Design instead of osmea_components
- Updated splash widgets (`SplashStartupWidget`, `SplashSpaceWidget`, `SplashEnterpriseWidget`) to use Material widgets
- Replaced `OsmeaColors` with Material `Colors`
- Replaced `OsmeaComponents.*` helpers with standard Material widgets (`Container`, `Column`, `Row`, `Text`, etc.)
- Updated `SpacerHelper` to use Material colors instead of osmea colors
- Removed `osmea_components` dependency from `pubspec.yaml`

### Removed
- `osmea_components` Git dependency (replaced with Material widgets)
- All `OsmeaComponents.*` helper methods
- All `OsmeaColors.*` color references
- `osmea_components` export from main library

### Documentation
- Updated README.md with pub.dev installation instructions
- Added package publishing information
- Updated repository URLs to `https://github.com/gurkanfikretgunak/masterfabric_core`

### Publishing
- Package published to [pub.dev](https://pub.dev/packages/masterfabric_core)
- Package ready for public use via `flutter pub add masterfabric_core`
- Version bumped to 0.0.2

[0.0.2]: https://github.com/gurkanfikretgunak/masterfabric_core/releases/tag/v0.0.2

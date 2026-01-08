import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'web_viewer_cases_state.dart';

/// Cubit for Web Viewer cases
@injectable
class WebViewerCasesCubit extends BaseViewModelCubit<WebViewerCasesState> {
  WebViewerCasesCubit() : super(const WebViewerCasesState());

  /// Change selected tab
  void changeTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }

  /// Update custom URL
  void updateCustomUrl(String url) {
    emit(state.copyWith(customUrl: url));
  }

  /// Update sample HTML
  void updateSampleHtml(String html) {
    emit(state.copyWith(sampleHtml: html));
  }

  /// Toggle navigation controls
  void toggleNavControls(bool value) {
    emit(state.copyWith(showNavControls: value));
  }

  /// Change style preset
  void changeStylePreset(String preset) {
    emit(state.copyWith(selectedStylePreset: preset));
  }

  /// Available style presets
  static const List<String> stylePresets = [
    'default',
    'article',
    'code',
    'minimal',
    'dark',
  ];

  /// Sample URLs for cases
  static const List<Map<String, String>> sampleUrls = [
    {'name': 'Flutter', 'url': 'https://flutter.dev'},
    {'name': 'Dart', 'url': 'https://dart.dev'},
    {'name': 'Pub.dev', 'url': 'https://pub.dev'},
    {'name': 'GitHub', 'url': 'https://github.com'},
  ];
}

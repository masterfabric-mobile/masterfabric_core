import 'package:equatable/equatable.dart';

/// State for Web Viewer demo
class WebViewerDemoState extends Equatable {
  /// Currently selected demo tab
  final int selectedTab;

  /// Sample URL for web viewer
  final String sampleUrl;

  /// Custom URL input
  final String customUrl;

  /// Sample HTML content
  final String sampleHtml;

  /// Whether to show navigation controls
  final bool showNavControls;

  /// Selected style preset
  final String selectedStylePreset;

  const WebViewerDemoState({
    this.selectedTab = 0,
    this.sampleUrl = 'https://flutter.dev',
    this.customUrl = '',
    this.sampleHtml = '''
<article>
  <h1>Welcome to HTML Viewer</h1>
  <p>This is a <strong>sample HTML</strong> content with various elements:</p>
  
  <h2>Features</h2>
  <ul>
    <li>Sanitized HTML rendering</li>
    <li>Custom styling support</li>
    <li>Link tap handling</li>
    <li>Multiple presets</li>
  </ul>
  
  <blockquote>
    "The best way to predict the future is to create it." - Peter Drucker
  </blockquote>
  
  <h3>Code Example</h3>
  <pre><code>WebViewerHelper.html(content)</code></pre>
  
  <p>Visit <a href="https://flutter.dev">Flutter Website</a> for more info.</p>
  
  <h3>Table Example</h3>
  <table>
    <tr><th>Method</th><th>Description</th></tr>
    <tr><td>html()</td><td>Sanitized HTML</td></tr>
    <tr><td>raw()</td><td>Raw HTML</td></tr>
    <tr><td>styled()</td><td>Styled HTML</td></tr>
    <tr><td>url()</td><td>Web URL</td></tr>
  </table>
</article>
''',
    this.showNavControls = true,
    this.selectedStylePreset = 'default',
  });

  @override
  List<Object?> get props => [
        selectedTab,
        sampleUrl,
        customUrl,
        sampleHtml,
        showNavControls,
        selectedStylePreset,
      ];

  WebViewerDemoState copyWith({
    int? selectedTab,
    String? sampleUrl,
    String? customUrl,
    String? sampleHtml,
    bool? showNavControls,
    String? selectedStylePreset,
  }) {
    return WebViewerDemoState(
      selectedTab: selectedTab ?? this.selectedTab,
      sampleUrl: sampleUrl ?? this.sampleUrl,
      customUrl: customUrl ?? this.customUrl,
      sampleHtml: sampleHtml ?? this.sampleHtml,
      showNavControls: showNavControls ?? this.showNavControls,
      selectedStylePreset: selectedStylePreset ?? this.selectedStylePreset,
    );
  }
}

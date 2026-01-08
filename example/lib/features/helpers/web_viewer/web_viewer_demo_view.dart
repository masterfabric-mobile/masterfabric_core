import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/web_viewer/cubit/web_viewer_demo_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/web_viewer/cubit/web_viewer_demo_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

/// Web Viewer Helper Demo View
class WebViewerDemoView
    extends MasterViewCubit<WebViewerDemoCubit, WebViewerDemoState> {
  WebViewerDemoView({
    super.key,
    required super.goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Web Viewer Helper'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(
      WebViewerDemoCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, WebViewerDemoCubit viewModel, WebViewerDemoState state) {
    return BlocBuilder<WebViewerDemoCubit, WebViewerDemoState>(
      bloc: viewModel,
      builder: (context, state) {
        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.border),
                  ),
                ),
                child: const TabBar(
                  labelColor: AppTheme.textPrimary,
                  unselectedLabelColor: AppTheme.textMuted,
                  indicatorColor: AppTheme.accent,
                  labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(text: 'HTML'),
                    Tab(text: 'Styled'),
                    Tab(text: 'Widget'),
                    Tab(text: 'URL'),
                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    _HtmlDemoTab(state: state, cubit: viewModel),
                    _StyledDemoTab(state: state, cubit: viewModel),
                    _WidgetDemoTab(state: state),
                    _UrlDemoTab(state: state, cubit: viewModel),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// HTML Demo Tab
class _HtmlDemoTab extends StatelessWidget {
  final WebViewerDemoState state;
  final WebViewerDemoCubit cubit;

  const _HtmlDemoTab({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section: Sanitized HTML
        _SectionCard(
          title: 'Sanitized HTML',
          subtitle: 'WebViewerHelper.html() - Safe for user content',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: WebViewerHelper.html(
                    state.sampleHtml,
                    height: 250,
                    onLinkTap: (url, attrs) {
                      if (url != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Link tapped: $url')),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''WebViewerHelper.html(
  htmlContent,
  onLinkTap: (url, attrs) => print(url),
)''',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Section: Raw HTML
        _SectionCard(
          title: 'Raw HTML (Warning)',
          subtitle: 'WebViewerHelper.raw() - Unsanitized, trusted content only',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: WebViewerHelper.raw(
                    '<h2>Raw HTML Content</h2><p>This content is <em>not sanitized</em>.</p>',
                    showWarning: true,
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''WebViewerHelper.raw(
  htmlContent,
  showWarning: true,
)''',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Styled Demo Tab
class _StyledDemoTab extends StatelessWidget {
  final WebViewerDemoState state;
  final WebViewerDemoCubit cubit;

  const _StyledDemoTab({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Style Preset Selector
        _SectionCard(
          title: 'Style Presets',
          subtitle: 'HtmlStyleConfig factory constructors',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WebViewerDemoCubit.stylePresets.map((preset) {
                  final isSelected = state.selectedStylePreset == preset;
                  return ChoiceChip(
                    label: Text(preset),
                    selected: isSelected,
                    onSelected: (_) => cubit.changeStylePreset(preset),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                    selectedColor: AppTheme.accent,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: state.selectedStylePreset == 'dark'
                      ? Colors.grey[900]
                      : Colors.white,
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: WebViewerHelper.styled(
                    state.sampleHtml,
                    config: _getStyleConfig(state.selectedStylePreset),
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''WebViewerHelper.styled(
  htmlContent,
  config: HtmlStyleConfig.${state.selectedStylePreset}(),
)''',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Custom Config Example
        _SectionCard(
          title: 'Custom Configuration',
          subtitle: 'Create your own HtmlStyleConfig',
          child: _CodePreview(
            code: '''final customConfig = HtmlStyleConfig(
  headingStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  ),
  paragraphStyle: TextStyle(
    fontSize: 16,
    height: 1.6,
  ),
  linkStyle: TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
  blockquoteDecoration: BoxDecoration(
    border: Border(left: BorderSide(color: Colors.grey, width: 4)),
    color: Colors.grey[100],
  ),
  paragraphSpacing: 12.0,
  headingSpacing: 16.0,
);

WebViewerHelper.styled(content, config: customConfig)''',
          ),
        ),
      ],
    );
  }

  HtmlStyleConfig _getStyleConfig(String preset) {
    switch (preset) {
      case 'article':
        return HtmlStyleConfig.article();
      case 'code':
        return HtmlStyleConfig.code();
      case 'minimal':
        return HtmlStyleConfig.minimal();
      case 'dark':
        return HtmlStyleConfig.dark();
      default:
        return HtmlStyleConfig.defaultConfig;
    }
  }
}

/// Widget Demo Tab
class _WidgetDemoTab extends StatelessWidget {
  final WebViewerDemoState state;

  const _WidgetDemoTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final htmlWidget = WebViewerHelper.widget(state.sampleHtml);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Extract Text
        _SectionCard(
          title: 'Extract Text',
          subtitle: 'htmlWidget.extractText()',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  htmlWidget.extractText(),
                  style: AppTheme.mono.copyWith(fontSize: 11),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''final htmlWidget = WebViewerHelper.widget(content);
String plainText = htmlWidget.extractText();''',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Extract Links
        _SectionCard(
          title: 'Extract Links',
          subtitle: 'htmlWidget.extractLinks()',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...htmlWidget.extractLinks().map((link) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.link, size: 14, color: AppTheme.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            link,
                            style: AppTheme.mono.copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (htmlWidget.extractLinks().isEmpty)
                Text(
                  'No links found',
                  style: AppTheme.mono.copyWith(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''List<String> links = htmlWidget.extractLinks();''',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // To Widget
        _SectionCard(
          title: 'To Widget',
          subtitle: 'htmlWidget.toWidget()',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: htmlWidget.toWidget(),
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''Widget widget = htmlWidget.toWidget();

// Or with constraints
Widget constrained = htmlWidget.toWidget(
  constraints: BoxConstraints(maxWidth: 400),
);''',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Query Selector
        _SectionCard(
          title: 'Query Selector',
          subtitle: 'htmlWidget.querySelectorAll(selector)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Found ${htmlWidget.querySelectorAll('h1').length} <h1> elements',
                style: AppTheme.mono.copyWith(fontSize: 12),
              ),
              Text(
                'Found ${htmlWidget.querySelectorAll('p').length} <p> elements',
                style: AppTheme.mono.copyWith(fontSize: 12),
              ),
              Text(
                'Found ${htmlWidget.querySelectorAll('li').length} <li> elements',
                style: AppTheme.mono.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''List<String> headings = htmlWidget.querySelectorAll('h1');
String? firstPara = htmlWidget.querySelector('p');''',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// URL Demo Tab
class _UrlDemoTab extends StatefulWidget {
  final WebViewerDemoState state;
  final WebViewerDemoCubit cubit;

  const _UrlDemoTab({required this.state, required this.cubit});

  @override
  State<_UrlDemoTab> createState() => _UrlDemoTabState();
}

class _UrlDemoTabState extends State<_UrlDemoTab> {
  late TextEditingController _urlController;
  String _currentUrl = 'https://flutter.dev';

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _currentUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // URL Input
        _SectionCard(
          title: 'Web URL Viewer',
          subtitle: 'WebViewerHelper.url() - Full WebView with navigation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick URL buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WebViewerDemoCubit.sampleUrls.map((item) {
                  return OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentUrl = item['url']!;
                        _urlController.text = _currentUrl;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                    child: Text(item['name']!, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Custom URL input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter URL...',
                        isDense: true,
                      ),
                      style: AppTheme.mono.copyWith(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentUrl = _urlController.text;
                      });
                    },
                    child: const Text('Go'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Toggle navigation
              Row(
                children: [
                  const Text('Show Navigation: ', style: TextStyle(fontSize: 12)),
                  Switch(
                    value: widget.state.showNavControls,
                    onChanged: widget.cubit.toggleNavControls,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // WebView Preview
        _SectionCard(
          title: 'Preview',
          subtitle: _currentUrl,
          child: Column(
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: WebViewerHelper.url(
                    _currentUrl,
                    showNavigationControls: widget.state.showNavControls,
                    enableFullscreen: true,
                    height: 350,
                    onLoadStart: (controller, url) {
                      debugPrint('Loading: $url');
                    },
                    onLoadStop: (controller, url) {
                      debugPrint('Loaded: $url');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _CodePreview(
                code: '''WebViewerHelper.url(
  '$_currentUrl',
  showNavigationControls: ${widget.state.showNavControls},
  enableFullscreen: true,
  onLoadStart: (controller, url) => print('Loading'),
  onLoadStop: (controller, url) => print('Loaded'),
)''',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Section card wrapper
class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  subtitle,
                  style: AppTheme.mono.copyWith(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Code preview widget
class _CodePreview extends StatelessWidget {
  final String code;

  const _CodePreview({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        code,
        style: AppTheme.mono.copyWith(fontSize: 10),
      ),
    );
  }
}

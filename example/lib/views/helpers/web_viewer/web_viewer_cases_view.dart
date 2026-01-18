import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/theme_helper.dart';
import 'cubit/web_viewer_cases_cubit.dart';
import 'cubit/web_viewer_cases_state.dart';

/// Web Viewer Helper Cases View
class WebViewerCasesView
    extends MasterViewCubit<WebViewerCasesCubit, WebViewerCasesState> {
  WebViewerCasesView({
    super.key,
    required super.goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Web Viewer Helper'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(
      WebViewerCasesCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, WebViewerCasesCubit viewModel, WebViewerCasesState state) {
    return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: context.borderColor)),
                ),
                child: TabBar(
                  labelColor: Theme.of(context).colorScheme.onSurface,
                  unselectedLabelColor: context.textMutedColor,
                  indicatorColor: context.accentColor,
                  labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(text: 'HTML'),
                    Tab(text: 'Styled'),
                    Tab(text: 'Widget'),
                    Tab(text: 'URL'),
                  ],
                ),
              ),
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
  }
}

class _HtmlDemoTab extends StatelessWidget {
  final WebViewerCasesState state;
  final WebViewerCasesCubit cubit;

  const _HtmlDemoTab({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Sanitized HTML',
          subtitle: 'WebViewerHelper.html() - Safe for user content',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: context.borderColor),
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
            ],
          ),
        ),
      ],
    );
  }
}

class _StyledDemoTab extends StatelessWidget {
  final WebViewerCasesState state;
  final WebViewerCasesCubit cubit;

  const _StyledDemoTab({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Style Presets',
          subtitle: 'HtmlStyleConfig factory constructors',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WebViewerCasesCubit.stylePresets.map((preset) {
                  final isSelected = state.selectedStylePreset == preset;
                  return ChoiceChip(
                    label: Text(preset),
                    selected: isSelected,
                    onSelected: (_) => cubit.changeStylePreset(preset),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                    selectedColor: context.accentColor,
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
                  border: Border.all(color: context.borderColor),
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
            ],
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

class _WidgetDemoTab extends StatelessWidget {
  final WebViewerCasesState state;

  const _WidgetDemoTab({required this.state});

  @override
  Widget build(BuildContext context) {
    final htmlWidget = WebViewerHelper.widget(state.sampleHtml);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Extract Text',
          subtitle: 'htmlWidget.extractText()',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              htmlWidget.extractText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 16),
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
                        Icon(LucideIcons.link, size: 14, color: context.accentColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            link,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (htmlWidget.extractLinks().isEmpty)
                Text(
                  'No links found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11, color: context.textMutedColor),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'To Widget',
          subtitle: 'htmlWidget.toWidget()',
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: context.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: htmlWidget.toWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class _UrlDemoTab extends StatefulWidget {
  final WebViewerCasesState state;
  final WebViewerCasesCubit cubit;

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
        _SectionCard(
          title: 'Web URL Viewer',
          subtitle: 'WebViewerHelper.url() - Full WebView with navigation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: WebViewerCasesCubit.sampleUrls.map((item) {
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
                    child: Text(item['name']!, style: TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(hintText: 'Enter URL...', isDense: true),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 12),
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
        _SectionCard(
          title: 'Preview',
          subtitle: _currentUrl,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              border: Border.all(color: context.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: WebViewerHelper.url(
                _currentUrl,
                showNavigationControls: widget.state.showNavControls,
                enableFullscreen: true,
                height: 350,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }
}

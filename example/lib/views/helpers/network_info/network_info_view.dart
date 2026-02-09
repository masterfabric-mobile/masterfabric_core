import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import 'cubit/network_info_cubit.dart';
import 'cubit/network_info_state.dart';

/// Network Info Helper View -- clean white-based soft design
class NetworkInfoView
    extends MasterViewCubit<NetworkInfoCubit, NetworkInfoState> {
  NetworkInfoView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          arguments: const {'title': 'Network Info'},
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Network Info'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.refreshCw,
                    size: 18,
                  ),
                  onPressed: () => viewModel.loadNetworkInfo(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      NetworkInfoCubit viewModel, BuildContext context) async {
    await viewModel.loadNetworkInfo();
  }

  @override
  Widget viewContent(
      BuildContext context, NetworkInfoCubit viewModel, NetworkInfoState state) {
    if (state.isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.isWebPlatform) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.wifiOff,
                  size: 40, color: context.textMutedColor),
              const SizedBox(height: 16),
              Text(
                'Not Supported on Web',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Network info features require a native platform.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: context.textMutedColor),
              ),
            ],
          ),
        ),
      );
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.triangleAlert,
                size: 32, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(state.errorMessage ?? 'Error',
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              child: OutlinedButton.icon(
                onPressed: () => viewModel.loadNetworkInfo(),
                icon: const Icon(LucideIcons.refreshCw, size: 14),
                label: const Text('Retry', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _CloudflareTraceSection(state: state),
        const SizedBox(height: 14),
        _ConnectivitySection(state: state),
        const SizedBox(height: 14),
        _WifiSection(state: state),
        const SizedBox(height: 14),
        _PublicIPSection(state: state),
        const SizedBox(height: 14),
        _DnsSection(state: state, cubit: viewModel),
        const SizedBox(height: 14),
        _ReachabilitySection(state: state, cubit: viewModel),
        const SizedBox(height: 14),
        _SpeedSection(state: state, cubit: viewModel),
        const SizedBox(height: 14),
        _InterfacesSection(state: state),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared UI components
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          ConditionalIcon(
            context: context,
            icon: icon,
            size: 14,
            color: context.textMutedColor,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  letterSpacing: 0.5,
                  color: context.textMutedColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _KVRow extends StatelessWidget {
  final String label;
  final String? value;
  final Color? valueColor;

  const _KVRow({required this.label, this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'SF Mono',
                    fontSize: 11,
                    color: context.textMutedColor,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'SF Mono',
                    fontSize: 11,
                    color: valueColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cloudflare Trace
// ---------------------------------------------------------------------------

class _CloudflareTraceSection extends StatelessWidget {
  final NetworkInfoState state;
  const _CloudflareTraceSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final trace = state.cloudflareTrace;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
            title: 'CLOUDFLARE TRACE', icon: LucideIcons.globe),
        Container(
          decoration: context.cardDecoration,
          child: Column(
            children: [
              _KVRow(label: 'IP', value: trace?.ip),
              const Divider(height: 1),
              _KVRow(label: 'Location', value: trace?.loc),
              const Divider(height: 1),
              _KVRow(label: 'Datacenter', value: trace?.colo),
              const Divider(height: 1),
              _KVRow(label: 'TLS', value: trace?.tls),
              const Divider(height: 1),
              _KVRow(label: 'HTTP', value: trace?.http),
              const Divider(height: 1),
              _KVRow(label: 'WARP', value: trace?.warp),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Connectivity
// ---------------------------------------------------------------------------

class _ConnectivitySection extends StatelessWidget {
  final NetworkInfoState state;
  const _ConnectivitySection({required this.state});

  @override
  Widget build(BuildContext context) {
    final connected = state.isConnectedResult ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
            title: 'CONNECTIVITY', icon: LucideIcons.network),
        Container(
          decoration: context.cardDecoration,
          child: Column(
            children: [
              _KVRow(
                label: 'Connected',
                value: connected ? 'Yes' : 'No',
                valueColor: connected
                    ? context.successColor
                    : Theme.of(context).colorScheme.error,
              ),
              const Divider(height: 1),
              _KVRow(
                label: 'Type',
                value: state.connectionType?.name ?? '-',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// WiFi Info
// ---------------------------------------------------------------------------

class _WifiSection extends StatelessWidget {
  final NetworkInfoState state;
  const _WifiSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final wifi = state.wifiInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'WIFI', icon: LucideIcons.wifi),
        Container(
          decoration: context.cardDecoration,
          child: Column(
            children: [
              _KVRow(label: 'Name', value: wifi?.wifiName),
              const Divider(height: 1),
              _KVRow(label: 'BSSID', value: wifi?.wifiBSSID),
              const Divider(height: 1),
              _KVRow(label: 'IP', value: wifi?.wifiIP),
              const Divider(height: 1),
              _KVRow(label: 'IPv6', value: wifi?.wifiIPv6),
              const Divider(height: 1),
              _KVRow(label: 'Submask', value: wifi?.wifiSubmask),
              const Divider(height: 1),
              _KVRow(label: 'Broadcast', value: wifi?.wifiBroadcast),
              const Divider(height: 1),
              _KVRow(label: 'Gateway', value: wifi?.wifiGatewayIP),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Public IP (auto-fetched)
// ---------------------------------------------------------------------------

class _PublicIPSection extends StatelessWidget {
  final NetworkInfoState state;
  const _PublicIPSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'PUBLIC IP', icon: LucideIcons.mapPin),
        Container(
          decoration: context.cardDecoration,
          child: _KVRow(label: 'Address', value: state.publicIP),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DNS Lookup (interactive)
// ---------------------------------------------------------------------------

class _DnsSection extends StatefulWidget {
  final NetworkInfoState state;
  final NetworkInfoCubit cubit;
  const _DnsSection({required this.state, required this.cubit});

  @override
  State<_DnsSection> createState() => _DnsSectionState();
}

class _DnsSectionState extends State<_DnsSection> {
  final _controller = TextEditingController(text: 'google.com');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'DNS LOOKUP', icon: LucideIcons.search),
        Container(
          decoration: context.cardDecoration,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'SF Mono'),
                        decoration: InputDecoration(
                          hintText: 'Hostname',
                          hintStyle: TextStyle(
                              fontSize: 12, color: context.textMutedColor),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: widget.state.isLoadingDns
                          ? null
                          : () => widget.cubit
                              .runDnsLookup(_controller.text.trim()),
                      child: const Text('Resolve',
                          style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
              if (widget.state.isLoadingDns)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              if (widget.state.dnsResults != null &&
                  !widget.state.isLoadingDns) ...[
                const Divider(height: 16),
                ...widget.state.dnsResults!.map((ip) => Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(ip,
                            style: const TextStyle(
                                fontSize: 11, fontFamily: 'SF Mono')),
                      ),
                    )),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Reachability (interactive)
// ---------------------------------------------------------------------------

class _ReachabilitySection extends StatefulWidget {
  final NetworkInfoState state;
  final NetworkInfoCubit cubit;
  const _ReachabilitySection({required this.state, required this.cubit});

  @override
  State<_ReachabilitySection> createState() => _ReachabilitySectionState();
}

class _ReachabilitySectionState extends State<_ReachabilitySection> {
  final _controller = TextEditingController(text: 'google.com');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.state.reachabilityResult;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
            title: 'REACHABILITY', icon: LucideIcons.activity),
        Container(
          decoration: context.cardDecoration,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'SF Mono'),
                        decoration: InputDecoration(
                          hintText: 'Host',
                          hintStyle: TextStyle(
                              fontSize: 12, color: context.textMutedColor),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 32,
                    child: OutlinedButton(
                      onPressed: widget.state.isLoadingReachability
                          ? null
                          : () => widget.cubit
                              .checkReachability(_controller.text.trim()),
                      child:
                          const Text('Check', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
              if (widget.state.isLoadingReachability)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              if (result != null && !widget.state.isLoadingReachability) ...[
                const Divider(height: 16),
                _KVRow(
                  label: 'Reachable',
                  value: result.isReachable ? 'Yes' : 'No',
                  valueColor: result.isReachable
                      ? context.successColor
                      : Theme.of(context).colorScheme.error,
                ),
                if (result.latencyMs != null)
                  _KVRow(label: 'Latency', value: '${result.latencyMs} ms'),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Speed Test (manual trigger)
// ---------------------------------------------------------------------------

class _SpeedSection extends StatelessWidget {
  final NetworkInfoState state;
  final NetworkInfoCubit cubit;
  const _SpeedSection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final result = state.speedResult;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'SPEED TEST', icon: LucideIcons.gauge),
        Container(
          decoration: context.cardDecoration,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (state.isLoadingSpeed)
                const Column(
                  children: [
                    SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(height: 8),
                    Text('Downloading test file...',
                        style: TextStyle(fontSize: 11)),
                  ],
                )
              else if (result != null) ...[
                _KVRow(
                    label: 'Speed',
                    value:
                        '${result.downloadSpeedMbps.toStringAsFixed(2)} Mbps'),
                const Divider(height: 1),
                _KVRow(label: 'Duration', value: '${result.durationMs} ms'),
                const Divider(height: 1),
                _KVRow(
                    label: 'Downloaded',
                    value:
                        '${(result.bytesDownloaded / 1024).toStringAsFixed(1)} KB'),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () => cubit.runSpeedTest(),
                    icon: const Icon(LucideIcons.refreshCw, size: 13),
                    label:
                        const Text('Re-test', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: () => cubit.runSpeedTest(),
                    icon: const Icon(LucideIcons.zap, size: 14),
                    label: const Text('Run Speed Test',
                        style: TextStyle(fontSize: 11)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Network Interfaces
// ---------------------------------------------------------------------------

class _InterfacesSection extends StatelessWidget {
  final NetworkInfoState state;
  const _InterfacesSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final interfaces = state.interfaces ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
            title: 'INTERFACES', icon: LucideIcons.cable),
        Container(
          decoration: context.cardDecoration,
          child: interfaces.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('No interfaces found',
                      style: TextStyle(
                          fontSize: 11, color: context.textMutedColor)),
                )
              : Column(
                  children: interfaces.asMap().entries.map((entry) {
                    final index = entry.key;
                    final iface = entry.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    iface.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontFamily: 'SF Mono',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 6),
                                  if (iface.isLoopback)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: context.borderColor),
                                        borderRadius:
                                            BorderRadius.circular(3),
                                      ),
                                      child: Text('loopback',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: context.textMutedColor)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              ...iface.addresses.map((addr) => Text(
                                    addr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontFamily: 'SF Mono',
                                            fontSize: 10,
                                            color: context.textMutedColor),
                                  )),
                            ],
                          ),
                        ),
                        if (index < interfaces.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

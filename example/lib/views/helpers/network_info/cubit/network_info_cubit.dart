import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'network_info_state.dart';

/// Network Info Cubit
@injectable
class NetworkInfoCubit extends BaseViewModelCubit<NetworkInfoState> {
  NetworkInfoCubit() : super(const NetworkInfoState.initial());

  /// Load all network info: Cloudflare trace, WiFi, connectivity,
  /// public IP, and interfaces -- auto-fetched in one batch.
  Future<void> loadNetworkInfo() async {
    stateChanger(const NetworkInfoState.loading());

    if (kIsWeb) {
      stateChanger(state.copyWith(
        isLoading: false,
        isWebPlatform: true,
      ));
      return;
    }

    try {
      final helper = NetworkInfoHelper.instance;

      // Fetch everything in parallel where possible
      final results = await Future.wait([
        helper.getCloudflareTrace(),
        helper.getAllWifiInfo(),
        helper.getConnectionType(),
        helper.isConnected(),
        helper.getPublicIP(),
        helper.getNetworkInterfaces(),
      ]);

      final cloudflareTrace = results[0] as CloudflareTraceInfo?;
      final wifiInfo = results[1] as WifiInfo;
      final connectionType = results[2] as NetworkConnectionType;
      final isConnected = results[3] as bool;
      final publicIP = results[4] as String?;
      final interfaces = results[5] as List<NetworkInterfaceInfo>;

      stateChanger(state.copyWith(
        isLoading: false,
        hasError: false,
        cloudflareTrace: cloudflareTrace,
        wifiInfo: wifiInfo,
        connectionType: connectionType,
        isConnectedResult: isConnected,
        publicIP: publicIP ?? 'Unavailable',
        interfaces: interfaces,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Resolve a hostname via DNS.
  Future<void> runDnsLookup(String host) async {
    stateChanger(state.copyWith(isLoadingDns: true, dnsHost: host));
    try {
      final results = await NetworkInfoHelper.instance.dnsLookup(host);
      stateChanger(state.copyWith(
        isLoadingDns: false,
        dnsResults: results.isEmpty ? ['No results'] : results,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoadingDns: false,
        dnsResults: ['Error: $e'],
      ));
    }
  }

  /// Check if a host is reachable.
  Future<void> checkReachability(String host) async {
    stateChanger(state.copyWith(isLoadingReachability: true));
    try {
      final result = await NetworkInfoHelper.instance.isHostReachable(host);
      stateChanger(state.copyWith(
        isLoadingReachability: false,
        reachabilityResult: result,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoadingReachability: false,
        reachabilityResult: ReachabilityResult(
          isReachable: false,
          host: host,
        ),
      ));
    }
  }

  /// Run a download speed estimation test.
  Future<void> runSpeedTest() async {
    stateChanger(state.copyWith(isLoadingSpeed: true));
    try {
      final result =
          await NetworkInfoHelper.instance.estimateDownloadSpeed();
      stateChanger(state.copyWith(
        isLoadingSpeed: false,
        speedResult: result,
      ));
    } catch (e) {
      stateChanger(state.copyWith(
        isLoadingSpeed: false,
        speedResult: const NetworkSpeedResult(
          downloadSpeedMbps: 0,
          durationMs: 0,
          bytesDownloaded: 0,
        ),
      ));
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

/// Network Info State
class NetworkInfoState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  // Cloudflare Trace
  final CloudflareTraceInfo? cloudflareTrace;

  // WiFi
  final WifiInfo? wifiInfo;

  // Connectivity
  final NetworkConnectionType? connectionType;
  final bool? isConnectedResult;

  // Public IP
  final String? publicIP;

  // DNS
  final String? dnsHost;
  final List<String>? dnsResults;
  final bool isLoadingDns;

  // Reachability
  final ReachabilityResult? reachabilityResult;
  final bool isLoadingReachability;

  // Speed
  final NetworkSpeedResult? speedResult;
  final bool isLoadingSpeed;

  // Interfaces
  final List<NetworkInterfaceInfo>? interfaces;

  // Platform
  final bool isWebPlatform;

  const NetworkInfoState({
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    this.cloudflareTrace,
    this.wifiInfo,
    this.connectionType,
    this.isConnectedResult,
    this.publicIP,
    this.dnsHost,
    this.dnsResults,
    this.isLoadingDns = false,
    this.reachabilityResult,
    this.isLoadingReachability = false,
    this.speedResult,
    this.isLoadingSpeed = false,
    this.interfaces,
    this.isWebPlatform = false,
  });

  const NetworkInfoState.initial()
      : isLoading = false,
        hasError = false,
        errorMessage = null,
        cloudflareTrace = null,
        wifiInfo = null,
        connectionType = null,
        isConnectedResult = null,
        publicIP = null,
        dnsHost = null,
        dnsResults = null,
        isLoadingDns = false,
        reachabilityResult = null,
        isLoadingReachability = false,
        speedResult = null,
        isLoadingSpeed = false,
        interfaces = null,
        isWebPlatform = false;

  const NetworkInfoState.loading()
      : isLoading = true,
        hasError = false,
        errorMessage = null,
        cloudflareTrace = null,
        wifiInfo = null,
        connectionType = null,
        isConnectedResult = null,
        publicIP = null,
        dnsHost = null,
        dnsResults = null,
        isLoadingDns = false,
        reachabilityResult = null,
        isLoadingReachability = false,
        speedResult = null,
        isLoadingSpeed = false,
        interfaces = null,
        isWebPlatform = false;

  NetworkInfoState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    CloudflareTraceInfo? cloudflareTrace,
    WifiInfo? wifiInfo,
    NetworkConnectionType? connectionType,
    bool? isConnectedResult,
    String? publicIP,
    String? dnsHost,
    List<String>? dnsResults,
    bool? isLoadingDns,
    ReachabilityResult? reachabilityResult,
    bool? isLoadingReachability,
    NetworkSpeedResult? speedResult,
    bool? isLoadingSpeed,
    List<NetworkInterfaceInfo>? interfaces,
    bool? isWebPlatform,
  }) {
    return NetworkInfoState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      cloudflareTrace: cloudflareTrace ?? this.cloudflareTrace,
      wifiInfo: wifiInfo ?? this.wifiInfo,
      connectionType: connectionType ?? this.connectionType,
      isConnectedResult: isConnectedResult ?? this.isConnectedResult,
      publicIP: publicIP ?? this.publicIP,
      dnsHost: dnsHost ?? this.dnsHost,
      dnsResults: dnsResults ?? this.dnsResults,
      isLoadingDns: isLoadingDns ?? this.isLoadingDns,
      reachabilityResult: reachabilityResult ?? this.reachabilityResult,
      isLoadingReachability:
          isLoadingReachability ?? this.isLoadingReachability,
      speedResult: speedResult ?? this.speedResult,
      isLoadingSpeed: isLoadingSpeed ?? this.isLoadingSpeed,
      interfaces: interfaces ?? this.interfaces,
      isWebPlatform: isWebPlatform ?? this.isWebPlatform,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        cloudflareTrace,
        wifiInfo,
        connectionType,
        isConnectedResult,
        publicIP,
        dnsHost,
        dnsResults,
        isLoadingDns,
        reachabilityResult,
        isLoadingReachability,
        speedResult,
        isLoadingSpeed,
        interfaces,
        isWebPlatform,
      ];
}

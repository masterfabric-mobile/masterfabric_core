import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart' as nip;

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

/// Aggregated WiFi information returned by [NetworkInfoHelper.getAllWifiInfo].
class WifiInfo {
  final String? wifiName;
  final String? wifiBSSID;
  final String? wifiIP;
  final String? wifiIPv6;
  final String? wifiSubmask;
  final String? wifiBroadcast;
  final String? wifiGatewayIP;

  const WifiInfo({
    this.wifiName,
    this.wifiBSSID,
    this.wifiIP,
    this.wifiIPv6,
    this.wifiSubmask,
    this.wifiBroadcast,
    this.wifiGatewayIP,
  });

  WifiInfo copyWith({
    String? wifiName,
    String? wifiBSSID,
    String? wifiIP,
    String? wifiIPv6,
    String? wifiSubmask,
    String? wifiBroadcast,
    String? wifiGatewayIP,
  }) {
    return WifiInfo(
      wifiName: wifiName ?? this.wifiName,
      wifiBSSID: wifiBSSID ?? this.wifiBSSID,
      wifiIP: wifiIP ?? this.wifiIP,
      wifiIPv6: wifiIPv6 ?? this.wifiIPv6,
      wifiSubmask: wifiSubmask ?? this.wifiSubmask,
      wifiBroadcast: wifiBroadcast ?? this.wifiBroadcast,
      wifiGatewayIP: wifiGatewayIP ?? this.wifiGatewayIP,
    );
  }

  @override
  String toString() =>
      'WifiInfo(name: $wifiName, bssid: $wifiBSSID, ip: $wifiIP, '
      'ipv6: $wifiIPv6, submask: $wifiSubmask, broadcast: $wifiBroadcast, '
      'gateway: $wifiGatewayIP)';
}

/// Connection type abstraction that maps from [ConnectivityResult].
enum NetworkConnectionType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  none,
  unknown,
}

/// Result of a host reachability check.
class ReachabilityResult {
  final bool isReachable;
  final int? latencyMs;
  final String host;

  const ReachabilityResult({
    required this.isReachable,
    this.latencyMs,
    required this.host,
  });

  @override
  String toString() =>
      'ReachabilityResult(host: $host, reachable: $isReachable, latency: ${latencyMs}ms)';
}

/// Result of a download speed estimation.
class NetworkSpeedResult {
  final double downloadSpeedMbps;
  final int durationMs;
  final int bytesDownloaded;

  const NetworkSpeedResult({
    required this.downloadSpeedMbps,
    required this.durationMs,
    required this.bytesDownloaded,
  });

  @override
  String toString() =>
      'NetworkSpeedResult(speed: ${downloadSpeedMbps.toStringAsFixed(2)} Mbps, '
      'duration: ${durationMs}ms, bytes: $bytesDownloaded)';
}

/// Parsed response from the Cloudflare trace endpoint
/// (`https://cloudflare.com/cdn-cgi/trace`).
///
/// Contains IP address, country location, Cloudflare datacenter, TLS version,
/// HTTP protocol, WARP status, and other network metadata.
class CloudflareTraceInfo {
  /// The visitor's public IP address.
  final String? ip;

  /// Two-letter country code (ISO 3166-1 alpha-2), e.g. `US`.
  final String? loc;

  /// Cloudflare datacenter (IATA code), e.g. `IAD`.
  final String? colo;

  /// TLS version used, e.g. `TLSv1.3`.
  final String? tls;

  /// HTTP protocol version, e.g. `http/2`.
  final String? http;

  /// Visit scheme (`https` or `http`).
  final String? visitScheme;

  /// Cloudflare WARP status (`on` / `off`).
  final String? warp;

  /// Cloudflare Gateway status (`on` / `off`).
  final String? gateway;

  /// User-agent string as seen by Cloudflare.
  final String? uag;

  /// Cloudflare flight identifier.
  final String? fl;

  /// Server Name Indication (SNI) type.
  final String? sni;

  /// Key exchange algorithm.
  final String? kex;

  /// Unix timestamp of the request.
  final String? ts;

  /// Full raw key-value map for any additional fields.
  final Map<String, String> raw;

  const CloudflareTraceInfo({
    this.ip,
    this.loc,
    this.colo,
    this.tls,
    this.http,
    this.visitScheme,
    this.warp,
    this.gateway,
    this.uag,
    this.fl,
    this.sni,
    this.kex,
    this.ts,
    this.raw = const {},
  });

  /// Creates a [CloudflareTraceInfo] from a raw `key=value` map.
  factory CloudflareTraceInfo.fromMap(Map<String, String> map) {
    return CloudflareTraceInfo(
      ip: map['ip'],
      loc: map['loc'],
      colo: map['colo'],
      tls: map['tls'],
      http: map['http'],
      visitScheme: map['visit_scheme'],
      warp: map['warp'],
      gateway: map['gateway'],
      uag: map['uag'],
      fl: map['fl'],
      sni: map['sni'],
      kex: map['kex'],
      ts: map['ts'],
      raw: map,
    );
  }

  @override
  String toString() =>
      'CloudflareTraceInfo(ip: $ip, loc: $loc, colo: $colo, tls: $tls, '
      'http: $http, warp: $warp, gateway: $gateway)';
}

/// Information about a single network interface on the device.
class NetworkInterfaceInfo {
  final String name;
  final List<String> addresses;
  final bool isLoopback;
  final int index;

  const NetworkInterfaceInfo({
    required this.name,
    required this.addresses,
    required this.isLoopback,
    required this.index,
  });

  @override
  String toString() =>
      'NetworkInterfaceInfo(name: $name, addresses: $addresses, '
      'loopback: $isLoopback, index: $index)';
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

/// Comprehensive network information helper.
///
/// Provides WiFi details, connectivity status, public IP lookup, DNS
/// resolution, host reachability, download speed estimation, and
/// network interface listing.
///
/// **Not supported on web.** All methods return safe defaults on web.
///
/// ```dart
/// // WiFi info
/// final wifi = await NetworkInfoHelper.instance.getAllWifiInfo();
///
/// // Connectivity
/// final connected = await NetworkInfoHelper.instance.isConnected();
/// final type = await NetworkInfoHelper.instance.getConnectionType();
///
/// // Public IP
/// final publicIP = await NetworkInfoHelper.instance.getPublicIP();
///
/// // DNS
/// final ips = await NetworkInfoHelper.instance.dnsLookup('google.com');
///
/// // Reachability
/// final result = await NetworkInfoHelper.instance.isHostReachable('google.com');
///
/// // Speed
/// final speed = await NetworkInfoHelper.instance.estimateDownloadSpeed();
///
/// // Cloudflare Trace (IP, location, datacenter, TLS, ...)
/// final trace = await NetworkInfoHelper.instance.getCloudflareTrace();
///
/// // Interfaces
/// final interfaces = await NetworkInfoHelper.instance.getNetworkInterfaces();
/// ```
class NetworkInfoHelper {
  // Singleton
  static final NetworkInfoHelper _instance = NetworkInfoHelper._internal();
  static NetworkInfoHelper get instance => _instance;
  NetworkInfoHelper._internal();
  factory NetworkInfoHelper() => _instance;

  final nip.NetworkInfo _networkInfo = nip.NetworkInfo();
  final Connectivity _connectivity = Connectivity();

  // -------------------------------------------------------------------------
  // WiFi Info (network_info_plus)
  // -------------------------------------------------------------------------

  /// Returns the WiFi network name (SSID). Requires location permission on
  /// Android/iOS. Returns `null` on web or if unavailable.
  Future<String?> getWifiName() async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: WiFi name not supported on web');
      return null;
    }
    try {
      return await _networkInfo.getWifiName();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi name: $e');
      return null;
    }
  }

  /// Returns the WiFi BSSID (access point MAC address).
  Future<String?> getWifiBSSID() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiBSSID();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi BSSID: $e');
      return null;
    }
  }

  /// Returns the device's WiFi IPv4 address.
  Future<String?> getWifiIP() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi IP: $e');
      return null;
    }
  }

  /// Returns the device's WiFi IPv6 address.
  Future<String?> getWifiIPv6() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiIPv6();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi IPv6: $e');
      return null;
    }
  }

  /// Returns the WiFi subnet mask.
  Future<String?> getWifiSubmask() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiSubmask();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi submask: $e');
      return null;
    }
  }

  /// Returns the WiFi broadcast address.
  Future<String?> getWifiBroadcast() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiBroadcast();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi broadcast: $e');
      return null;
    }
  }

  /// Returns the WiFi gateway IP address.
  Future<String?> getWifiGatewayIP() async {
    if (kIsWeb) return null;
    try {
      return await _networkInfo.getWifiGatewayIP();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting WiFi gateway IP: $e');
      return null;
    }
  }

  /// Fetches all WiFi information in a single call and returns a [WifiInfo] model.
  Future<WifiInfo> getAllWifiInfo() async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: WiFi info not supported on web');
      return const WifiInfo();
    }
    try {
      final results = await Future.wait([
        getWifiName(),
        getWifiBSSID(),
        getWifiIP(),
        getWifiIPv6(),
        getWifiSubmask(),
        getWifiBroadcast(),
        getWifiGatewayIP(),
      ]);
      return WifiInfo(
        wifiName: results[0],
        wifiBSSID: results[1],
        wifiIP: results[2],
        wifiIPv6: results[3],
        wifiSubmask: results[4],
        wifiBroadcast: results[5],
        wifiGatewayIP: results[6],
      );
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting all WiFi info: $e');
      return const WifiInfo();
    }
  }

  // -------------------------------------------------------------------------
  // Connectivity (connectivity_plus)
  // -------------------------------------------------------------------------

  /// Returns the current [NetworkConnectionType].
  Future<NetworkConnectionType> getConnectionType() async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: Connectivity check not supported on web');
      return NetworkConnectionType.unknown;
    }
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return NetworkConnectionType.none;
      return _mapConnectivity(results.first);
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting connection type: $e');
      return NetworkConnectionType.unknown;
    }
  }

  /// Returns `true` if the device has any active network connection.
  Future<bool> isConnected() async {
    final type = await getConnectionType();
    return type != NetworkConnectionType.none &&
        type != NetworkConnectionType.unknown;
  }

  /// Returns `true` if the device is connected via WiFi.
  Future<bool> isWifi() async {
    final type = await getConnectionType();
    return type == NetworkConnectionType.wifi;
  }

  /// Returns `true` if the device is connected via mobile data.
  Future<bool> isMobile() async {
    final type = await getConnectionType();
    return type == NetworkConnectionType.mobile;
  }

  /// Stream that emits whenever the connectivity state changes.
  Stream<NetworkConnectionType> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      if (results.isEmpty) return NetworkConnectionType.none;
      return _mapConnectivity(results.first);
    });
  }

  NetworkConnectionType _mapConnectivity(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkConnectionType.wifi;
      case ConnectivityResult.mobile:
        return NetworkConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkConnectionType.ethernet;
      case ConnectivityResult.bluetooth:
        return NetworkConnectionType.bluetooth;
      case ConnectivityResult.vpn:
        return NetworkConnectionType.vpn;
      case ConnectivityResult.none:
        return NetworkConnectionType.none;
      default:
        return NetworkConnectionType.unknown;
    }
  }

  // -------------------------------------------------------------------------
  // Public IP (dio)
  // -------------------------------------------------------------------------

  /// Fetches the device's public (external) IP address via the ipify API.
  Future<String?> getPublicIP() async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: Public IP lookup not supported on web');
      return null;
    }
    final dio = Dio();
    try {
      final response = await dio.get<String>(
        'https://api.ipify.org?format=text',
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      return response.data?.trim();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error getting public IP: $e');
      return null;
    } finally {
      dio.close();
    }
  }

  // -------------------------------------------------------------------------
  // DNS Lookup (dart:io)
  // -------------------------------------------------------------------------

  /// Resolves [host] to a list of IP addresses using the system DNS resolver.
  Future<List<String>> dnsLookup(String host) async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: DNS lookup not supported on web');
      return [];
    }
    try {
      final addresses = await InternetAddress.lookup(host);
      return addresses.map((a) => a.address).toList();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: DNS lookup failed for $host: $e');
      return [];
    }
  }

  // -------------------------------------------------------------------------
  // Reachability (dart:io Socket)
  // -------------------------------------------------------------------------

  /// Checks whether [host] is reachable by opening a TCP socket on [port].
  ///
  /// Returns a [ReachabilityResult] with the latency in milliseconds.
  Future<ReachabilityResult> isHostReachable(
    String host, {
    int port = 80,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: Reachability check not supported on web');
      return ReachabilityResult(isReachable: false, host: host);
    }
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      stopwatch.stop();
      socket.destroy();
      return ReachabilityResult(
        isReachable: true,
        latencyMs: stopwatch.elapsedMilliseconds,
        host: host,
      );
    } catch (e) {
      stopwatch.stop();
      debugPrint('📶 NetworkInfoHelper: Host $host not reachable: $e');
      return ReachabilityResult(
        isReachable: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        host: host,
      );
    }
  }

  // -------------------------------------------------------------------------
  // Speed Estimation (dio)
  // -------------------------------------------------------------------------

  /// Estimates the download speed by fetching a small test file.
  ///
  /// Provide a custom [testUrl] or use the default (a ~1 MB file from
  /// Cloudflare's speed test CDN).
  Future<NetworkSpeedResult> estimateDownloadSpeed({
    String? testUrl,
  }) async {
    if (kIsWeb) {
      debugPrint('📶 NetworkInfoHelper: Speed test not supported on web');
      return const NetworkSpeedResult(
        downloadSpeedMbps: 0,
        durationMs: 0,
        bytesDownloaded: 0,
      );
    }

    final url = testUrl ??
        'https://speed.cloudflare.com/__down?measId=0&bytes=1048576';

    final dio = Dio();
    final stopwatch = Stopwatch()..start();
    int totalBytes = 0;

    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
        onReceiveProgress: (received, total) {
          totalBytes = received;
        },
      );

      stopwatch.stop();
      totalBytes = response.data?.length ?? totalBytes;

      final durationMs = stopwatch.elapsedMilliseconds;
      final durationSec = durationMs / 1000.0;
      // bits = bytes * 8, megabits = bits / 1_000_000
      final speedMbps =
          durationSec > 0 ? (totalBytes * 8) / (durationSec * 1000000) : 0.0;

      debugPrint(
        '📶 NetworkInfoHelper: Speed test complete - '
        '${speedMbps.toStringAsFixed(2)} Mbps '
        '(${totalBytes} bytes in ${durationMs}ms)',
      );

      return NetworkSpeedResult(
        downloadSpeedMbps: speedMbps,
        durationMs: durationMs,
        bytesDownloaded: totalBytes,
      );
    } catch (e) {
      stopwatch.stop();
      debugPrint('📶 NetworkInfoHelper: Speed test failed: $e');
      return NetworkSpeedResult(
        downloadSpeedMbps: 0,
        durationMs: stopwatch.elapsedMilliseconds,
        bytesDownloaded: totalBytes,
      );
    } finally {
      dio.close();
    }
  }

  // -------------------------------------------------------------------------
  // Cloudflare Trace (dio)
  // -------------------------------------------------------------------------

  /// Fetches network metadata from the Cloudflare trace endpoint.
  ///
  /// Returns a [CloudflareTraceInfo] with the visitor's public IP, country
  /// code, datacenter, TLS version, HTTP protocol, WARP status, and more.
  ///
  /// Returns `null` on web or if the request fails.
  Future<CloudflareTraceInfo?> getCloudflareTrace() async {
    if (kIsWeb) {
      debugPrint(
        '📶 NetworkInfoHelper: Cloudflare trace not supported on web',
      );
      return null;
    }
    final dio = Dio();
    try {
      final response = await dio.get<String>(
        'https://cloudflare.com/cdn-cgi/trace',
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      final body = response.data;
      if (body == null || body.isEmpty) return null;

      // Parse "key=value\n" format into a Map
      final Map<String, String> map = {};
      for (final line in body.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;
        final idx = trimmed.indexOf('=');
        if (idx == -1) continue;
        final key = trimmed.substring(0, idx);
        final value = trimmed.substring(idx + 1);
        map[key] = value;
      }

      final trace = CloudflareTraceInfo.fromMap(map);
      debugPrint(
        '📶 NetworkInfoHelper: Cloudflare trace - '
        'IP: ${trace.ip}, Location: ${trace.loc}, '
        'Colo: ${trace.colo}, TLS: ${trace.tls}',
      );
      return trace;
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Cloudflare trace failed: $e');
      return null;
    } finally {
      dio.close();
    }
  }

  // -------------------------------------------------------------------------
  // Network Interfaces (dart:io)
  // -------------------------------------------------------------------------

  /// Returns a list of all network interfaces on the device.
  Future<List<NetworkInterfaceInfo>> getNetworkInterfaces() async {
    if (kIsWeb) {
      debugPrint(
        '📶 NetworkInfoHelper: Network interfaces not supported on web',
      );
      return [];
    }
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: true,
        type: InternetAddressType.any,
      );
      return interfaces.map((iface) {
        return NetworkInterfaceInfo(
          name: iface.name,
          addresses: iface.addresses.map((a) => a.address).toList(),
          isLoopback:
              iface.addresses.isNotEmpty && iface.addresses.first.isLoopback,
          index: iface.index,
        );
      }).toList();
    } catch (e) {
      debugPrint('📶 NetworkInfoHelper: Error listing interfaces: $e');
      return [];
    }
  }
}

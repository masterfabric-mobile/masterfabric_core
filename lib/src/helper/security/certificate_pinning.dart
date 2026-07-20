import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Optional TLS certificate / SPKI pinning for Dio clients.
///
/// Host apps should supply pin hashes for production API / force-update hosts.
/// Pins are SHA-256 digests of the DER certificate (hex or base64) or SPKI.
///
/// Example:
/// ```dart
/// final dio = CertificatePinning.createPinnedDio(
///   allowedHosts: {'api.example.com'},
///   sha256Pins: {'api.example.com': {'AB:CD:...hex...'}},
/// );
/// ```
abstract final class CertificatePinning {
  /// Creates a [Dio] that rejects TLS certs whose SHA-256 fingerprint is not
  /// listed for the request host. On web / unsupported platforms returns a
  /// plain [Dio] (pinning is a no-op).
  static Dio createPinnedDio({
    required Map<String, Set<String>> sha256Pins,
    Set<String>? allowedHosts,
    BaseOptions? options,
  }) {
    final dio = Dio(options);
    if (kIsWeb) return dio;

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        return client;
      },
      validateCertificate: (cert, host, port) {
        if (cert == null) return false;
        if (allowedHosts != null &&
            allowedHosts.isNotEmpty &&
            !allowedHosts.contains(host.toLowerCase())) {
          return false;
        }
        final pins = sha256Pins[host.toLowerCase()];
        if (pins == null || pins.isEmpty) {
          // No pins configured for host → reject (fail closed).
          return false;
        }
        final fingerprint = _sha256Hex(cert.der);
        final normalizedPins =
            pins.map(_normalizeFingerprint).toSet();
        return normalizedPins.contains(fingerprint);
      },
    );
    return dio;
  }

  static String _sha256Hex(Uint8List der) {
    return sha256.convert(der).bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toLowerCase();
  }

  static String _normalizeFingerprint(String value) {
    return value.replaceAll(':', '').replaceAll(' ', '').toLowerCase();
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'version_provider.dart';

/// Version provider that fetches from an API endpoint
class ApiVersionProvider implements VersionProvider {
  /// API endpoint URL
  final String endpoint;

  /// Custom headers for the request
  final Map<String, String>? headers;

  /// Timeout duration
  final Duration timeout;

  /// HTTP client (for testing)
  final http.Client? client;

  ApiVersionProvider({
    required this.endpoint,
    this.headers,
    this.timeout = const Duration(seconds: 10),
    this.client,
  });

  @override
  Future<VersionData> fetchVersionInfo() async {
    try {
      final httpClient = client ?? http.Client();

      final response = await httpClient
          .get(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception(
            'API request failed with status: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;

      // Support various API response formats
      // Format 1: Direct response
      if (data.containsKey('latestVersion')) {
        return VersionData.fromJson(data);
      }

      // Format 2: Nested under 'data'
      if (data.containsKey('data') && data['data'] is Map) {
        return VersionData.fromJson(data['data'] as Map<String, dynamic>);
      }

      // Format 3: Nested under 'version' or 'update'
      if (data.containsKey('version') && data['version'] is Map) {
        return VersionData.fromJson(data['version'] as Map<String, dynamic>);
      }

      if (data.containsKey('update') && data['update'] is Map) {
        return VersionData.fromJson(data['update'] as Map<String, dynamic>);
      }

      // Fallback: try to parse the whole response
      return VersionData.fromJson(data);
    } catch (e) {
      debugPrint('ApiVersionProvider error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final httpClient = client ?? http.Client();

      final response = await httpClient
          .head(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 405;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    // Client is typically external, don't dispose
  }
}

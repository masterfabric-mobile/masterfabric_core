import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'version_provider.dart';

/// Version provider that fetches from an API endpoint
class ApiVersionProvider implements VersionProvider {
  /// API endpoint URL
  final String endpoint;

  /// Custom headers for the request
  final Map<String, String>? headers;

  /// Timeout duration
  final Duration timeout;

  /// Dio client (for testing or custom configuration)
  final Dio? dio;

  /// Internal dio instance
  Dio? _internalDio;

  ApiVersionProvider({
    required this.endpoint,
    this.headers,
    this.timeout = const Duration(seconds: 10),
    this.dio,
  });

  Dio get _dio {
    if (dio != null) return dio!;

    _internalDio ??= Dio(BaseOptions(
      connectTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'Content-Type': 'application/json',
        ...?headers,
      },
    ));

    return _internalDio!;
  }

  @override
  Future<VersionData> fetchVersionInfo() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(endpoint);

      if (response.statusCode != 200) {
        throw Exception(
            'API request failed with status: ${response.statusCode}');
      }

      final data = response.data;
      if (data == null) {
        throw Exception('API response is empty');
      }

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
    } on DioException catch (e) {
      debugPrint('ApiVersionProvider DioException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('ApiVersionProvider error: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final response = await _dio.head<void>(
        endpoint,
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      return response.statusCode == 200 || response.statusCode == 405;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _internalDio?.close();
    _internalDio = null;
  }
}

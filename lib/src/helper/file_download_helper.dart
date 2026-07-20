import 'dart:io';

import 'package:dio/dio.dart';
import 'package:masterfabric_core/src/helper/security/url_security.dart';
import 'package:path_provider/path_provider.dart';

/// Helper class for file downloads with progress tracking
class FileDownloadHelper {
  /// Download a file with progress callback.
  ///
  /// [url] must be HTTPS. [fileName] is sanitized (basename only; no `..`).
  static Future<String?> downloadFile(
    String url,
    String fileName, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
    Dio? dio,
  }) async {
    try {
      if (!UrlSecurity.isHttpsUrl(url)) {
        return null;
      }
      final client = dio ?? Dio();
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = UrlSecurity.resolveSafePath(appDir.path, fileName);

      await client.download(
        url,
        filePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );

      return filePath;
    } catch (_) {
      return null;
    }
  }

  /// Download file to a specific directory.
  ///
  /// [url] must be HTTPS. [fileName] is sanitized against path traversal.
  static Future<String?> downloadToDirectory(
    String url,
    String directory,
    String fileName, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
    Dio? dio,
  }) async {
    try {
      if (!UrlSecurity.isHttpsUrl(url)) {
        return null;
      }
      final client = dio ?? Dio();
      final dir = Directory(directory);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final filePath = UrlSecurity.resolveSafePath(directory, fileName);

      await client.download(
        url,
        filePath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );

      return filePath;
    } catch (_) {
      return null;
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// Delete a file
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

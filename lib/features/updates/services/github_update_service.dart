import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../domain/app_update_info.dart';

class GithubUpdateService {
  GithubUpdateService._();
  static final GithubUpdateService instance = GithubUpdateService._();

  static const String _latestReleaseApi =
      'https://api.github.com/repos/mo4wez/sayadganj/releases/latest';

  /// Returns [AppUpdateInfo] if a newer GitHub release exists, or `null` if up to date.
  Future<AppUpdateInfo?> checkForUpdate() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(Uri.parse(_latestReleaseApi));
      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/vnd.github+json',
      );
      request.headers.set(HttpHeaders.userAgentHeader, 'SayadGanj-Android-App');

      final response = await request.close();
      if (response.statusCode != 200) {
        throw HttpException('GitHub API returned ${response.statusCode}');
      }

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final tagName = (json['tag_name'] as String? ?? '').trim();
      if (tagName.isEmpty ||
          !AppUpdateInfo.isNewerVersion(tagName, currentVersion)) {
        return null;
      }

      final releasePageUrl =
          json['html_url'] as String? ??
          'https://github.com/mo4wez/sayadganj/releases/latest';
      final notes = (json['body'] as String? ?? '').trim();

      // Prefer the arm64-v8a APK asset directly; fall back to the release page.
      String downloadUrl = releasePageUrl;
      final assets = json['assets'] as List<dynamic>? ?? const [];
      for (final item in assets) {
        if (item is Map<String, dynamic>) {
          final name = item['name'] as String? ?? '';
          final url = item['browser_download_url'] as String? ?? '';
          if (name.contains('arm64-v8a') &&
              name.endsWith('.apk') &&
              url.isNotEmpty) {
            downloadUrl = url;
            break;
          }
        }
      }

      return AppUpdateInfo(
        currentVersion: currentVersion,
        latestVersion: tagName.replaceFirst(RegExp(r'^[vV]'), ''),
        releaseNotes: notes,
        downloadUrl: downloadUrl,
        releasePageUrl: releasePageUrl,
      );
    } finally {
      client.close(force: true);
    }
  }
}

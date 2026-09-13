import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DesktopUpdater {
  // هذا الرقم تزيده بمقدار 1 فقط عندما تخرج نسخة ويندوز جديدة
  static const int currentWindowsPatch = 1;

  static const String _apiUrl =
      'https://api.github.com/repos/Mohamed-Kamal-1/Accounting_Inventory_ERP_System/releases/latest';

  static Future<void> checkAndUpdate() async {
    if (kIsWeb || !Platform.isWindows) return;

    try {
      final dio = Dio();
      final response = await dio.get(_apiUrl);

      // اسم الـ Tag على جيت هب يكون بصيغة: win-patch-2
      final tag = response.data['tag_name'] as String;

      if (tag.startsWith('win-patch-')) {
        final serverPatchNumber =
            int.tryParse(tag.replaceAll('win-patch-', '').trim()) ?? 0;

        // إذا كان رقم الـ Patch على جيت هب أكبر من الرقم المدمج في الكود
        if (serverPatchNumber > currentWindowsPatch) {
          final assets = response.data['assets'] as List;
          final exeAsset = assets.firstWhere(
            (asset) => (asset['name'] as String).endsWith('.exe'),
            orElse: () => null,
          );

          if (exeAsset != null) {
            final downloadUrl = exeAsset['browser_download_url'] as String;
            await _downloadAndInstall(dio, downloadUrl);
          }
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  static Future<void> _downloadAndInstall(Dio dio, String downloadUrl) async {
    final tempDir = await getTemporaryDirectory();
    final savePath = '${tempDir.path}\\latest_setup.exe';

    // تحميل ملف التثبيت في الخلفية
    await dio.download(downloadUrl, savePath);

    // تثبيت فوري صامت وتشغيل البرنامج بعد الانتهاء
    await Process.start(savePath, [
      '/VERYSILENT',
      '/SUPPRESSMSGBOXES',
      '/FORCECLOSEAPPLICATIONS',
    ]);

    exit(0);
  }
}

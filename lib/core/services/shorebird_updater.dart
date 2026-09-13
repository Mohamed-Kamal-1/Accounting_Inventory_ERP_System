import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class AppUpdateService {
  static final updater = ShorebirdUpdater();

  static Future<void> checkForUpdates(BuildContext context) async {
    try {
      // التحقق من حالة التحديث
      final status = await updater.checkForUpdate();

      // لو التطبيق يحتاج تحديث (outdated)
      if (status == UpdateStatus.outdated) {
        // تحميل التحديث الجديد وتجهيزه
        await updater.update();

        // إظهار الرسالة للعميل
        if (context.mounted) {
          _showUpdateDialog(context);
        }
      }
    } catch (e) {
      debugPrint('Shorebird update error: $e');
    }
  }

  static void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تحديث جديد متاح',
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'تم تحميل تحديث جديد للنظام، يرجى إغلاق البرنامج وفتحه مرة أخرى لتطبيق التعديلات.',
          textAlign: TextAlign.right,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await Future.delayed(const Duration(seconds: 1));
              if (Platform.isWindows) {
                exit(0);
              } else {
                SystemNavigator.pop();
              }
            },
            child: const Text('إغلاق التطبيق الآن'),
          ),
        ],
      ),
    );
  }
}

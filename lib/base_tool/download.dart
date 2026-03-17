import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../base_views/rh_toast.dart';
import 'log_utils.dart';

typedef ProgressCallback = void Function(double progress, String filePath);

class ApkDownloader {
  static final Dio _dio = Dio();

  /// 下载并安装 APK
  static Future<void> downloadAndInstall({
    required String url,
    ProgressCallback? onProgress,
  }) async {
    // 1️⃣ 权限检查
    await _checkPermission();

    // 2️⃣ 保存路径
    final Directory dir = await getExternalStorageDirectory()
        ?? await getApplicationDocumentsDirectory();
    final String path = dir.path;
    String fileName = url.split('/').last;
    final String filePath = '$path/$fileName';
    LogUtils.d("下载的路径： $filePath");
    // 3️⃣ 下载
    await _dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total, filePath);
        }
      },
      options: Options(
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ),
    );

    // 4️⃣ 调起系统安装
    // await OpenFilex.open(filePath);
    // await installApk(filePath);
  }

  static Future<void> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.requestInstallPackages.status;
      if (!status.isGranted) {
        await Permission.requestInstallPackages.request();
      }
    }
  }
}

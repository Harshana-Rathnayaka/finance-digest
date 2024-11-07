import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class AppRequest {
  static Future<bool> notificationPermission() async {
    PermissionStatus request = await Permission.notification.request();

    if (request.isGranted) {
      log('Notification permission granted');
      return true;
    } else if (request.isDenied) {
      log('Notification permission denied');
      return false;
    } else if (request.isPermanentlyDenied) {
      log('Notification permission permanently denied');
      return false;
    }
    return false;
  }
}

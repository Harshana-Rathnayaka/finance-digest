import 'dart:developer';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
/*
* Notifications are enabled by default in Android API below 33
* But we have to request permission if its above API 33
*/

class AppRequest {
  static Future<bool> notificationPermission() async {
    // permission request is need on API level 33 or above
    if (Platform.isAndroid && (await Permission.notification.isDenied)) {
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
    } else {
      // if iOS or below API level 33
      log('Notification permission not required or already granted');
      return true;
    }
    return false;
  }
}

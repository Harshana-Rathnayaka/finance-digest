import 'package:finance_digest/constants/app_colors.dart';
import 'package:finance_digest/constants/app_text.dart';
import 'package:finance_digest/constants/app_fonts.dart';
import 'package:finance_digest/constants/app_images.dart';
import 'package:finance_digest/services/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../enums/app_routes.dart';

class NotificationPermission extends StatefulWidget {
  const NotificationPermission({super.key});

  @override
  State<NotificationPermission> createState() => _NotificationPermissionState();
}

class _NotificationPermissionState extends State<NotificationPermission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.notification),
                  const Text(AppText.nofHead, style: TextStyle(fontFamily: AppFonts.fontBold, fontSize: AppFonts.textSizeNormal)),
                  const Text(AppText.nofDesc, textAlign: TextAlign.center, style: TextStyle(fontFamily: AppFonts.fontRegular, fontSize: AppFonts.textSizeSMedium, color: AppColors.textGrey)),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                  onPressed: () async {
                    var value = await AppRequest.notificationPermission();
                    if (value && context.mounted) context.pushNamed(AppRoute.dashboard.name);
                  },
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(AppColors.buttonColor)),
                  child: const Text(AppText.continueBtn, style: TextStyle(fontFamily: AppFonts.fontMedium, color: AppColors.colorWhite))))
        ],
      ),
    );
  }
}

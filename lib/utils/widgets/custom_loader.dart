import 'package:finance_digest/constants/app_colors.dart';
import 'package:finance_digest/constants/app_fonts.dart';
import 'package:finance_digest/constants/app_images.dart';
import 'package:finance_digest/constants/app_text.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  const CustomLoader({super.key});

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: size.width, height: size.width / 1.5, child: Image.asset(AppImages.logo, fit: BoxFit.contain)),
              const SizedBox(height: 20),
              const Text(AppText.loading, style: TextStyle(fontFamily: AppFonts.fontMedium, letterSpacing: 0.6, color: AppColors.textGrey)),
              Container(width: size.width / 2, margin: const EdgeInsets.only(top: 8), child: const LinearProgressIndicator(color: AppColors.buttonColor, backgroundColor: AppColors.hintColor)),
            ],
          ),
        ));
  }
}

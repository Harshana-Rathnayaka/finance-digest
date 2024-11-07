import 'dart:developer';

import 'package:finance_digest/constants/app_colors.dart';
import 'package:finance_digest/constants/app_fonts.dart';
import 'package:finance_digest/enums/app_routes.dart';
import 'package:finance_digest/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_text.dart';
import '../../models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isButtonActive = false;
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateButtonState);
    _lastNameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // method to change the button state based on the listener data
  void _updateButtonState() => setState(() => _isButtonActive = _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.loginHead, style: TextStyle(fontSize: AppFonts.textSizeXXLarge, fontWeight: FontWeight.bold, fontFamily: AppFonts.fontBold))),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
        child: Column(
          children: [
            const Text(AppText.loginDesc, style: TextStyle(fontSize: AppFonts.textSizeMedium, fontFamily: AppFonts.fontRegular, color: AppColors.textGrey)),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(hintText: AppText.firstName, hintStyle: TextStyle(fontFamily: AppFonts.fontRegular, color: AppColors.hintColor)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(hintText: AppText.lastName, hintStyle: TextStyle(fontFamily: AppFonts.fontRegular, color: AppColors.hintColor)),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: _isButtonActive ? AppColors.buttonColor : AppColors.buttonColor.withOpacity(0.4),
        foregroundColor: AppColors.colorWhite,
        shape: const CircleBorder(),
        onPressed: _isButtonActive
            ? () async {
                int? id = await signUp();
                log('db response = $id');

                if (id != null) {
                  const storage = FlutterSecureStorage();
                  storage.write(key: 'userId', value: id.toString());
                  _firstNameController.clear();
                  _lastNameController.clear();
                  if (context.mounted) context.pushNamed(AppRoute.notificationPermission.name);
                }
              }
            : null,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  // sign up method
  signUp() async {
    return await db.signUp(User(firstName: _firstNameController.text, lastName: _lastNameController.text));
  }
}

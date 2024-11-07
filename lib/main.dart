import 'package:finance_digest/utils/router.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // isLoggedIn = await isUserLoggedIn();
  runApp(const MyApp());
}

// bool isLoggedIn = false;

// // checking if there is a user
// Future<bool> isUserLoggedIn() async {
//   const storage = FlutterSecureStorage();
//   final userId = (await storage.read(key: 'userId'));
//
//   if (userId == null) {
//     return false;
//   } else {
//     return true;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = goRouter();

    return MaterialApp.router(
      routerConfig: router,
      title: 'Finance Digest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
    );
  }
}

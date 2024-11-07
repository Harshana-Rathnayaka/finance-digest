import 'package:finance_digest/enums/app_routes.dart';
import 'package:finance_digest/screens/auth/login.dart';
import 'package:finance_digest/screens/features/permission/notification_permission.dart';
import 'package:go_router/go_router.dart';

import '../screens/features/news/dashboard.dart';

GoRouter goRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(path: '/login', name: AppRoute.login.name, builder: (context, state) => const Login()),
      GoRoute(path: '/notificationPermission', name: AppRoute.notificationPermission.name, builder: (context, state) => const NotificationPermission()),
      GoRoute(path: '/dashboard', name: AppRoute.dashboard.name, builder: (context, state) => const Dashboard()),
    ],
  );
}

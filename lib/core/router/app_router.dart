import 'dart:async';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/route_names.dart';
import 'package:tync/features/active_session/presentation/active_session_screen.dart';
import 'package:tync/features/auth/application/auth_controller.dart';
import 'package:tync/features/auth/presentation/login_screen.dart';
import 'package:tync/features/sessions/presentation/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));
  return GoRouter(
    initialLocation: RouteNames.dashboardPath,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.dashboardPath,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: RouteNames.sessionPath,
            name: RouteNames.session,
            builder: (context, state) {
              final id = state.pathParameters['sessionId']!;
              return ActiveSessionScreen(sessionId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final location = state.uri.path;

      logger.i("--- REDIRECT CHECK ---");
      logger.i("Gehe zu: $location");
      logger.i("User eingeloggt? $isLoggedIn");
      logger.i("User ID: ${authState.value?.uid}");

      final isGoingToLogin = state.matchedLocation == RouteNames.loginPath;

      if (!isLoggedIn && !isGoingToLogin) {
        return RouteNames.loginPath;
      }
      if (isLoggedIn && isGoingToLogin) {
        return RouteNames.dashboardPath;
      }
      return null;
    },
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _authStateSubscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _authStateSubscription = stream.asBroadcastStream().listen(
      (dynamic data) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}

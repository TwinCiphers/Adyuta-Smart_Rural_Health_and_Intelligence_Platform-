import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:adyuta_main/features/authentication/providers/auth_provider.dart';

// Import screens (adjust paths as needed once they are created)
import 'package:adyuta_main/features/authentication/screens/splash_screen.dart';
import 'package:adyuta_main/features/authentication/screens/login_screen.dart';
import 'package:adyuta_main/features/authentication/screens/signup_screen.dart';
import 'package:adyuta_main/home_screen.dart';
import 'package:adyuta_main/features/settings/presentation/security_settings_screen.dart';
import 'package:adyuta_main/features/settings/presentation/mpin_setup_screen.dart';
import 'package:adyuta_main/features/settings/presentation/settings_screen.dart';
import 'package:adyuta_main/features/settings/presentation/mfa_setup_screen.dart';
import 'package:adyuta_main/features/settings/presentation/domain_profile_placeholder.dart';
import 'package:adyuta_main/features/authentication/screens/mfa_verify_screen.dart';
import 'package:adyuta_main/features/authentication/providers/local_security_provider.dart';
import 'package:adyuta_main/features/authentication/screens/app_lock_screen.dart';
import 'package:adyuta_main/features/profile/screens/profile_screen.dart';

final mfaStatusProvider = FutureProvider<bool>((ref) async {
  return false;
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // Helper for transitions
  CustomTransitionPage buildPageWithDefaultTransition<T>({
    required BuildContext context, 
    required GoRouterState state, 
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      Stream.multi((controller) {
        ref.listen(authStateProvider, (_, __) => controller.add(null));
        ref.listen(localSecurityProvider, (_, __) => controller.add(null));
      }),
    ),
    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);
      final localSecurityState = ref.read(localSecurityProvider);

      final isAuth = authState.session != null;
      final isLoadingAuth = authState.isLoading;
      final isSplash = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      final isAppLock = state.matchedLocation == '/app_lock';

      // Wait while auth is initializing from secure storage (fast, < 200ms)
      if (isLoadingAuth || localSecurityState.isChecking) {
        return '/';
      }

      if (!isAuth && !isLoggingIn) return '/login';

      if (isAuth) {
        if (localSecurityState.isLocked && !isAppLock) return '/app_lock';
        if (!localSecurityState.isLocked && (isSplash || isLoggingIn || isAppLock)) return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen())),
      GoRoute(path: '/login', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const LoginScreen())),
      GoRoute(path: '/signup', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const SignupScreen())),
      GoRoute(path: '/home', pageBuilder: (context, state) => const NoTransitionPage(child: AdyutaMainHome())),
      GoRoute(path: '/settings', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const SettingsScreen())),
      GoRoute(path: '/security_settings', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const SecuritySettingsScreen())),
      GoRoute(path: '/mfa_setup', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const MfaSetupScreen())),
      GoRoute(path: '/mfa_verify', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const MfaVerifyScreen())),
      GoRoute(path: '/app_lock', pageBuilder: (context, state) => const NoTransitionPage(child: AppLockScreen())),
      GoRoute(path: '/setup_mpin', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const MpinSetupScreen())),
      GoRoute(path: '/profile', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ProfileScreen())),
      GoRoute(path: '/domain_health', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DomainProfilePlaceholderScreen(title: 'Health'))),
      GoRoute(path: '/domain_agri', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DomainProfilePlaceholderScreen(title: 'Agriculture'))),
      GoRoute(path: '/domain_safety', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DomainProfilePlaceholderScreen(title: 'Safety'))),
      GoRoute(path: '/domain_edu', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DomainProfilePlaceholderScreen(title: 'Education'))),
      GoRoute(path: '/domain_gov', pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const DomainProfilePlaceholderScreen(title: 'Governance'))),
    ],
  );
});



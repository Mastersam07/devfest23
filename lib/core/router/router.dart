import 'package:devfest23/core/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/pages/home.dart';
import '../../features/onboarding/onboarding.dart';

enum TabItem { home, schedule, speakers, favourites, more }

class AppRouter {
  AppRouter(WidgetRef ref) {
    mainRouter = _getRouter(ref);
  }

  static String initialLocation = RoutePaths.app;

  late GoRouter mainRouter;

  bool showOnboarding(GoRouterState state, WidgetRef ref) {
    // TODO: Implement onboarding screen checks
    return true;
  }

  GoRouter _getRouter(WidgetRef ref) => GoRouter(
        initialLocation: initialLocation,
        debugLogDiagnostics: true,
        redirect: (context, state) {
          if (showOnboarding(state, ref)) {
            return RoutePaths.onboarding;
          }

          return null;
        },
        routes: [
          GoRoute(
            path: RoutePaths.onboarding,
            name: RouteNames.onboarding,
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: '/',
            redirect: (context, state) {
              final tabId = state.pathParameters['tab'];
              return '/app/${tabId ?? TabItem.home.name}';
            },
          ),
          GoRoute(
            path: '/app/:tab',
            name: RouteNames.home,
            builder: (context, state) {
              final tabId = state.pathParameters['tab'];
              final tabItem = TabItem.values.firstWhere(
                (tabItem) => tabItem == TabItem.values.byName(tabId!),
                orElse: (() => throw Exception('Tab not found: $tabId')),
              );

              return AppHome(key: state.pageKey, initialTab: tabItem);
            },
          ),
        ],
      );
}
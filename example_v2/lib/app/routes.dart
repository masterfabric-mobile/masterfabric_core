import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:masterfabric_core/masterfabric_core.dart' hide AppRoutes;

import '../data/fitness_repository.dart';
import '../views/body/body_view.dart';
import '../views/coach/coach_view.dart';
import '../views/log/log_view.dart';
import '../views/onboarding/aura_onboarding_view.dart';
import '../views/onboarding/aura_permissions_view.dart';
import '../views/today/today_view.dart';
import '../widgets/aura_shell.dart';
import 'di/injection.dart' as di;

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String log = '/log';
  static const String body = '/body';
  static const String coach = '/coach';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      redirect: (context, state) {
        final loc = state.matchedLocation;
        if (loc == splash) return null;

        final repo = di.getIt<FitnessRepository>();
        final profileDone = repo.profile.onboardingComplete;
        final permsDone = repo.profile.permissionsComplete;

        // Queue 1: gym profile baseline.
        if (!profileDone && loc != onboarding) return onboarding;

        // Queue 2: system permissions (after profile).
        if (profileDone &&
            !permsDone &&
            loc != permissions &&
            loc != onboarding) {
          return permissions;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => SplashView(
            goRoute: (path) => context.go(path),
          ),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => const AuraOnboardingView(),
        ),
        GoRoute(
          path: permissions,
          builder: (context, state) => const AuraPermissionsView(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AuraShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: home,
                  builder: (context, state) {
                    final action = state.uri.queryParameters['action'];
                    return TodayView(
                      // Force rebuild when a quick-action / widget deep link arrives.
                      key: ValueKey('today-${action ?? 'idle'}-${state.uri.query}'),
                      goRoute: (path) => context.go(path),
                      initialAction: action,
                    );
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: log,
                  builder: (context, state) => LogView(
                    goRoute: (path) => context.go(path),
                    initialMeal: state.uri.queryParameters['meal'],
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: body,
                  builder: (context, state) => BodyView(
                    goRoute: (path) => context.go(path),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: coach,
                  builder: (context, state) => CoachView(
                    goRoute: (path) => context.go(path),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

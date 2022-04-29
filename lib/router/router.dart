import 'package:example/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mono_kit/mono_kit.dart';

import '../auth_action/auth_action_route.dart';

part 'router.g.dart';

// go_router_builderで組もうとしたものの、
// enumがケバブケースにされてしまって、URL不合致になるので一旦やめた
// (そのカスタマイズができるようになったらこっちで組みたい)
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<AuthActionRoute>(
      path: 'action',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context) => const HomePage();
}

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      // routes: $appRoutes,
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomePage(),
          routes: [
            authActionRoute,
          ],
        ),
      ],
      debugLogDiagnostics: kDebugMode,
      navigatorBuilder: (_, __, child) => GoRouterLocationButton(
        // ignore: avoid_redundant_argument_values
        visible: kDebugMode,
        child: child,
      ),
    );
  },
);

extension GoRouterX on GoRouter {
  BuildContext get context => navigator!.context;
}

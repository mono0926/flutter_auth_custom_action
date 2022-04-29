import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mono_kit/mono_kit.dart';

import 'password_reset/password_reset_page.dart';

final authActionRoute = GoRoute(
  path: 'action',
  builder: (_, state) {
    final mode = AuthActionMode.values.byNameOrNull(
      state.queryParams['mode'],
    );
    if (mode == null) {
      return const NoActionPage();
    }
    switch (mode) {
      case AuthActionMode.resetPassword:
        return PasswordResetPage(
          oobCode: state.queryParams['oobCode']!,
        );
    }
  },
);

// go_router_builderで組めなくなったが一応残しておく
class AuthActionRoute extends GoRouteData {
  const AuthActionRoute({
    this.mode,
    this.oobCode,
    this.apiKey,
  });
  final AuthActionMode? mode;
  final String? oobCode;
  final String? apiKey;
  @override
  Widget build(BuildContext context) {
    final mode = this.mode;
    if (mode == null) {
      return const NoActionPage();
    }
    switch (mode) {
      case AuthActionMode.resetPassword:
        return PasswordResetPage(
          oobCode: oobCode!,
        );
    }
  }
}

class NoActionPage extends ConsumerWidget {
  const NoActionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Action Parameter'),
      ),
    );
  }
}

enum AuthActionMode {
  resetPassword,
}

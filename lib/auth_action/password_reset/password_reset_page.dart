import 'package:example/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mono_kit/mono_kit.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({
    super.key,
    required this.oobCode,
  });
  final String oobCode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(resetPasswordController);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: ListView(
        children: [
          TilePadding(
            child: TextField(
              controller: controller.passwordTextController,
              obscureText: true,
              autofocus: true,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
            ),
          ),
          const Gap(8),
          TilePadding(
            child: ElevatedButton(
              onPressed: () => controller.resetPassword(
                oobCode: oobCode,
                theme: theme,
              ),
              child: const Text('Update Password'),
            ),
          ),
        ],
      ),
    );
  }
}

final resetPasswordController = Provider.autoDispose(
  ResetPasswordController.new,
);

class ResetPasswordController {
  ResetPasswordController(this._ref);
  final Ref _ref;
  final passwordTextController = TextEditingController();

  Future<void> resetPassword({
    required String oobCode,
    required ThemeData theme,
  }) async {
    final messenger = ScaffoldMessenger.of(_ref.read(routerProvider).context);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: passwordTextController.text,
      );
      messenger.showMessage('Password updated');
    } on FirebaseAuthException catch (e) {
      messenger.showError('Failed: ${e.code}', theme: theme);
    }
  }
}

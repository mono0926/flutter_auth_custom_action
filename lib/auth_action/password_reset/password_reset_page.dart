import 'package:example/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mono_kit/mono_kit.dart';

class PasswordResetPage extends ConsumerWidget {
  const PasswordResetPage({
    Key? key,
    required this.oobCode,
  }) : super(key: key);
  final String oobCode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(resetPasswordProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: ListView(
        children: [
          TilePadding(
            child: TextField(
              controller: notifier.passwordTextController,
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
              onPressed: () => notifier.resetPassword(
                oobCode: oobCode,
              ),
              child: const Text('Update Password'),
            ),
          ),
        ],
      ),
    );
  }
}

final resetPasswordProvider = Provider(
  (ref) => ResetPasswordNotifier(ref.read),
);

class ResetPasswordNotifier {
  ResetPasswordNotifier(this._read);
  final Reader _read;
  final passwordTextController = TextEditingController();

  Future<void> resetPassword({
    required String oobCode,
  }) async {
    final messenger = ScaffoldMessenger.of(_read(routerProvider).context);
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: oobCode,
        newPassword: passwordTextController.text,
      );
      messenger.showMessage(
        'Password updated',
      );
    } on FirebaseAuthException catch (e) {
      messenger.showError(
        'Failed: ${e.code}',
      );
    }
  }
}

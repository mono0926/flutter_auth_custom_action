import 'package:example/router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mono_kit/mono_kit.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordResetMailSender = ref.watch(passwordResetMailSenderProvider);
    final oob = ref.watch(oobProvider);
    final resetLocation = '/action?mode=resetPassword&oobCode=$oob';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          TilePadding(
            child: TextField(
              controller: passwordResetMailSender.emailTextController,
              autofocus: true,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
          ),
          const Gap(8),
          TilePadding(
            child: ElevatedButton(
              onPressed: () => passwordResetMailSender.send(theme: theme),
              child: const Text('Send Password Reset Email'),
            ),
          ),
          const Divider(),
          TilePadding(
            child: TextField(
              controller: ref.watch(oobProvider.notifier).oobTextController,
              decoration: const InputDecoration(
                label: Text('oobCode (For debug)'),
              ),
            ),
          ),
          const Gap(8),
          TilePadding(
            child: ElevatedButton(
              onPressed: () => context.go(resetLocation),
              child: Text('go($resetLocation)'),
            ),
          ),
          const Divider(),
          AboutListTile(
            icon: const Icon(Icons.info),
            aboutBoxChildren: [
              TextButton.icon(
                label: const Text('Source code'),
                onPressed: () => launchUrl(
                  Uri.parse(
                    'https://github.com/mono0926/firebase_auth_custom_action',
                  ),
                ),
                icon: const Icon(Icons.open_in_browser),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final passwordResetMailSenderProvider = Provider(
  PasswordResetMailSender.new,
);

class PasswordResetMailSender {
  PasswordResetMailSender(this._ref);
  final Ref _ref;
  final emailTextController =
      TextEditingController(text: 'mono0926@example.com');

  Future<void> send({required ThemeData theme}) async {
    final messenger = ScaffoldMessenger.of(_ref.read(routerProvider).context);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text);
      messenger.showMessage('Email sent.');
    } on FirebaseAuthException catch (e) {
      messenger.showError('Failed: ${e.code}', theme: theme);
    }
  }
}

final oobProvider = StateNotifierProvider<OobNotifier, String>(
  (ref) => OobNotifier(),
);

class OobNotifier extends StateNotifier<String> {
  OobNotifier() : super('xxx') {
    oobTextController.addListener(() {
      state = oobTextController.text;
    });
  }
  late final oobTextController = TextEditingController(text: state);
}

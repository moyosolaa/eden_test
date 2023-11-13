import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
          ref.read(authProvider.notifier).signInWithGoogle();
        },
        child: const Text('Login'),
      )),
    );
  }
}

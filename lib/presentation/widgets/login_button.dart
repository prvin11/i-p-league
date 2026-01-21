import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/auth_provider.dart';

class LoginButton extends StatelessWidget {
  final Function() onPressed;

  const LoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenProvider>();

    return ElevatedButton(
      onPressed: authProvider.isLoading
          ? null
          : onPressed,
      child: authProvider.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Login'),
    );
  }
}
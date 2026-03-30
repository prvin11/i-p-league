import 'package:flutter/material.dart';
import 'package:gully_11/core/constants/colors.dart';
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
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.red.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ).copyWith(
        elevation: WidgetStateProperty.all(12),
        shadowColor: WidgetStateProperty.all(cricketRed),
      ),
      child: authProvider.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Login',
              style: TextStyle(
                color: cricketRed,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
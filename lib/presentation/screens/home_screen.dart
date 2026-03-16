import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../panel/admin_panel.dart';
import '../panel/viewer_panel.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

   bool isAdminEmail(String? email) {
    return email?.toLowerCase() == 'gullyadmin@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoginScreen();
        }
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          if (isAdminEmail(user.email)) {
            return const AdminPanel();
          } else {
            return const ViewerPanel();
          }
        }
        return const LoginScreen();
      },
    );
  }
}
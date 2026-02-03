import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:i_p_league/core/constants/colors.dart';

import 'package:provider/provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/team_leaderboard_screen.dart';
import 'presentation/state/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDmMyuYSaSiWYtxxNMh_zAZotK5wJgxv20",
        authDomain: "i-p-league.firebaseapp.com",
        projectId: "i-p-league",
        storageBucket: "i-p-league.firebasestorage.app",
        messagingSenderId: "1089416550452",
        appId: "1:1089416550452:web:623bd0ed25ca0cab999261",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (BuildContext context) =>
            AuthenProvider(AuthRepository(AuthService())),
        child: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        }
        return const LoginScreen();
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: stitchWhite)),
        backgroundColor: cricketRed,
        elevation: 0,
      ),
      body: TeamLeaderboardScreen(),
    );
  }
}

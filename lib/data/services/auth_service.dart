import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // Initialize GoogleSignIn with serverClientId for Android
  late GoogleSignIn _googleSignIn;

  AuthService() {
    _googleSignIn = GoogleSignIn.instance;
    _googleSignIn.initialize(
      clientId:
          "1089416550452-eragp3hvg32qqqc56sr9o39737shi3l9.apps.googleusercontent.com",
      serverClientId:
          "1089416550452-eragp3hvg32qqqc56sr9o39737shi3l9.apps.googleusercontent.com",
    );
  }

  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> createAccount(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Use authenticate() method for google_sign_in 7.2.0+
      final googleUser = await _googleSignIn.authenticate();

      // Get the ID token from the signed-in user
      final idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        throw Exception('Failed to get ID token from Google Sign-In');
      }

      // Create Firebase credential using the Google ID token
      final credential = GoogleAuthProvider.credential(idToken: idToken);

      // Sign in with Firebase using the Google credential
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw Exception('No user is currently signed in');
    }
  }
}

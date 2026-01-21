import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<User?> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<User?> createAccount(String email, String password) {
    return _service.createAccount(email, password);
  }

  Future<User?> signInWithGoogle() {
    return _service.signInWithGoogle();
  }

  Future<void> logout() {
    return _service.logout();
  }

  Future<void> deleteAccount() {
    return _service.deleteAccount();
  }
}
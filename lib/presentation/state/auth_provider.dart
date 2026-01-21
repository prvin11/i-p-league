import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';

class AuthenProvider with ChangeNotifier {
  final AuthRepository _repo;

  AuthenProvider(this._repo) {
    _init();
  }

  User? _user;
  User? get user => _user;

  bool isLoading = false;

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.login(email, password);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> createAccount(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.createAccount(email, password);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.signInWithGoogle();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.logout();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    isLoading = true;
    notifyListeners();

    try {
      await _repo.deleteAccount();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }
}
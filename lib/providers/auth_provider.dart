import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences _prefs;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> register(String email, String password, String username) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        totalXP: 0,
        totalCoins: 0,
      );

      await _prefs.setString('username', username);
      await _prefs.setString('email', email);
      await _prefs.setInt('totalXP', 0);
      await _prefs.setInt('totalCoins', 0);

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final username = await _prefs.getString('username') ?? 'User';
      _currentUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        totalXP: await _prefs.getInt('totalXP') ?? 0,
        totalCoins: await _prefs.getInt('totalCoins') ?? 0,
      );

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void addXP(int xp) {
    if (_currentUser != null) {
      _currentUser!.totalXP += xp;
      _prefs.setInt('totalXP', _currentUser!.totalXP);
      notifyListeners();
    }
  }

  void addCoins(int coins) {
    if (_currentUser != null) {
      _currentUser!.totalCoins += coins;
      _prefs.setInt('totalCoins', _currentUser!.totalCoins);
      notifyListeners();
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'کاربری با این ایمیل یافت نشد';
      case 'wrong-password':
        return 'رمز عبور اشتباه است';
      case 'email-already-in-use':
        return 'این ایمیل قبلاً ثبت نام کرده است';
      case 'weak-password':
        return 'رمز عبور ضعیف است';
      case 'invalid-email':
        return 'ایمیل نامعتبر است';
      default:
        return 'خطای احراز هویت: $code';
    }
  }
}
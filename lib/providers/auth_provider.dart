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
    _checkAuthState();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _checkAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserData(user);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(User user) async {
    final String? userData = _prefs.getString('user_${user.uid}');
    if (userData != null) {
      // Load from local storage
      _currentUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: _prefs.getString('username_${user.uid}') ?? 'User',
        totalXp: _prefs.getInt('xp_${user.uid}') ?? 0,
        coins: _prefs.getInt('coins_${user.uid}') ?? 0,
      );
    } else {
      _currentUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: user.email?.split('@')[0] ?? 'User',
      );
      await _saveUserData();
    }
    notifyListeners();
  }

  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      await _prefs.setString('user_${_currentUser!.uid}', 'stored');
      await _prefs.setString('username_${_currentUser!.uid}', _currentUser!.username);
      await _prefs.setInt('xp_${_currentUser!.uid}', _currentUser!.totalXp);
      await _prefs.setInt('coins_${_currentUser!.uid}', _currentUser!.coins);
    }
  }

  Future<bool> register(String email, String password, String username) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await _saveUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUserData(userCredential.user!);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> addXp(int xp) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(totalXp: _currentUser!.totalXp + xp);
      await _saveUserData();
      notifyListeners();
    }
  }

  Future<void> addCoins(int coins) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(coins: _currentUser!.coins + coins);
      await _saveUserData();
      notifyListeners();
    }
  }
}

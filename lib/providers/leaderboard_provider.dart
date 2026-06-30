import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/leaderboard_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  List<LeaderboardEntry> _leaderboard = [];

  List<LeaderboardEntry> get leaderboard => _leaderboard;

  LeaderboardProvider() {
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    final List<String>? savedData = _prefs.getStringList('leaderboard');
    if (savedData != null) {
      _leaderboard = savedData
          .map((e) => LeaderboardEntry.fromJson(json.decode(e)))
          .toList();
      _sortLeaderboard();
    }
    notifyListeners();
  }

  Future<void> addScore(String username, int score, int xpEarned) async {
    final entry = LeaderboardEntry(
      username: username,
      score: score,
      xpEarned: xpEarned,
      timestamp: DateTime.now(),
    );

    _leaderboard.add(entry);
    _sortLeaderboard();

    if (_leaderboard.length > 10) {
      _leaderboard = _leaderboard.take(10).toList();
    }

    await _saveLeaderboard();
    notifyListeners();
  }

  void _sortLeaderboard() {
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));
  }

  Future<void> _saveLeaderboard() async {
    final data = _leaderboard.map((e) => json.encode(e.toJson())).toList();
    await _prefs.setStringList('leaderboard', data);
  }

  Future<void> clearLeaderboard() async {
    _leaderboard.clear();
    await _prefs.remove('leaderboard');
    notifyListeners();
  }
}

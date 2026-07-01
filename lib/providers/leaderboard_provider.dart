import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/leaderboard_entry.dart';

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

  Future<void> addScore(String username, int score, int xp) async {
    final entry = LeaderboardEntry(
      username: username,
      score: score,
      xp: xp,
      date: DateTime.now(),
    );

    _leaderboard.add(entry);
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));

    if (_leaderboard.length > 10) {
      _leaderboard = _leaderboard.take(10).toList();
    }

    await _saveLeaderboard();
    notifyListeners();
  }

  Future<void> _saveLeaderboard() async {
    final jsonList = _leaderboard.map((e) => e.toJson()).toList();
    await _prefs.setString('leaderboard', json.encode(jsonList));
  }

  Future<void> loadLeaderboard() async {
    try {
      final jsonString = _prefs.getString('leaderboard');
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        _leaderboard =
            jsonList.map((e) => LeaderboardEntry.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error loading leaderboard: $e');
    }
    notifyListeners();
  }
}
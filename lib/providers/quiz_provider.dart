import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _xpEarned = 0;
  bool _isLoading = false;
  Map<int, int?> _answers = {};

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get xpEarned => _xpEarned;
  bool get isLoading => _isLoading;
  int get totalQuestions => _questions.length;
  Map<int, int?> get answers => _answers;

  Future<void> loadQuestions() async {
    try {
      _isLoading = true;
      notifyListeners();

      String jsonString = await rootBundle.loadString('assets/data/questions.json');
      List<dynamic> jsonList = json.decode(jsonString);
      _questions = jsonList.map((q) => Question.fromJson(q)).toList();
      _questions = _questions.take(10).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading questions: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int optionIndex) {
    _answers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  void checkAnswer() {
    if (_answers[_currentQuestionIndex] == _questions[_currentQuestionIndex].correctAnswerIndex) {
      _score += 10;
      _xpEarned += 10;
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _xpEarned = 0;
    _answers.clear();
    notifyListeners();
  }

  bool get isQuizFinished => _currentQuestionIndex >= _questions.length - 1;
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _earnedXP = 0;
  List<int?> _selectedAnswers = [];
  bool _isLoading = false;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get earnedXP => _earnedXP;
  Question? get currentQuestion =>
      _currentQuestionIndex < _questions.length ? _questions[_currentQuestionIndex] : null;
  bool get isLoading => _isLoading;
  List<int?> get selectedAnswers => _selectedAnswers;

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/data/questions.json');
      final jsonData = json.decode(jsonString) as List;
      _questions = jsonData.map((q) => Question.fromJson(q)).toList();
      _questions = _questions.take(10).toList();
      _selectedAnswers = List<int?>.filled(_questions.length, null);
      _score = 0;
      _earnedXP = 0;
      _currentQuestionIndex = 0;
    } catch (e) {
      print('Error loading questions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    if (_currentQuestionIndex < _selectedAnswers.length) {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
      notifyListeners();
    }
  }

  void submitAnswer() {
    if (_currentQuestionIndex < _questions.length) {
      final question = _questions[_currentQuestionIndex];
      final selectedIndex = _selectedAnswers[_currentQuestionIndex];

      if (selectedIndex == question.correctAnswerIndex) {
        _score++;
        _earnedXP += 10;
      }
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _earnedXP = 0;
    _selectedAnswers = List<int?>.filled(_questions.length, null);
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/leaderboard_provider.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuizProvider _quizProvider;
  int _timeLeft = 15;
  late Future<void> _loadQuestions;

  @override
  void initState() {
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    _loadQuestions = _quizProvider.loadQuestions();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _timeLeft--;
          if (_timeLeft <= 0) {
            _handleTimeUp();
          } else {
            _startTimer();
          }
        });
      }
    });
  }

  void _handleTimeUp() {
    _quizProvider.checkAnswer();
    if (_quizProvider.isQuizFinished) {
      _navigateToResult();
    } else {
      _quizProvider.nextQuestion();
      setState(() => _timeLeft = 15);
      _startTimer();
    }
  }

  void _navigateToResult() {
    final authProvider = context.read<AuthProvider>();
    final leaderboardProvider = context.read<LeaderboardProvider>();
    leaderboardProvider.addScore(
      authProvider.currentUser?.username ?? 'Player',
      _quizProvider.score,
      _quizProvider.xpEarned,
    );
    authProvider.addXp(_quizProvider.xpEarned);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultPage(
          score: _quizProvider.score,
          xpEarned: _quizProvider.xpEarned,
          totalQuestions: _quizProvider.totalQuestions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E)],
          ),
        ),
        child: FutureBuilder<void>(
          future: _loadQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading questions', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            return Consumer<QuizProvider>(
              builder: (context, quizProvider, _) {
                if (quizProvider.questions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No questions available', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Go Back'),
                        ),
                      ],
                    ),
                  );
                }

                final question = quizProvider.questions[quizProvider.currentQuestionIndex];
                final selectedAnswer = quizProvider.answers[quizProvider.currentQuestionIndex];

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Q${quizProvider.currentQuestionIndex + 1}/${quizProvider.totalQuestions}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00E5FF),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _timeLeft <= 5 ? Colors.red : const Color(0xFF7B2FFF),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$_timeLeft s',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _timeLeft <= 5 ? Colors.red : const Color(0xFF7B2FFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                question.question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              ...List.generate(
                                question.options.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: GestureDetector(
                                    onTap: selectedAnswer == null
                                        ? () {
                                            quizProvider.selectAnswer(index);
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              quizProvider.checkAnswer();
                                              if (quizProvider.isQuizFinished) {
                                                _navigateToResult();
                                              } else {
                                                quizProvider.nextQuestion();
                                                setState(() => _timeLeft = 15);
                                                _startTimer();
                                              }
                                            });
                                          }
                                        : null,
                                    child: _OptionButton(
                                      text: question.options[index],
                                      isSelected: selectedAnswer == index,
                                      isCorrect: index == question.correctAnswerIndex,
                                      answered: selectedAnswer != null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Score: ${quizProvider.score}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool answered;

  const _OptionButton({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = const Color(0xFF7B2FFF);
    if (answered) {
      borderColor = isSelected ? (isCorrect ? Colors.green : Colors.red) : (isCorrect ? Colors.green : const Color(0xFF7B2FFF));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: answered
            ? (isSelected ? borderColor.withOpacity(0.2) : Colors.transparent)
            : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (answered && isSelected)
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: borderColor,
              size: 24,
            ),
          if (answered && !isSelected && isCorrect)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
        ],
      ),
    );
  }
}

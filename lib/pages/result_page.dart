import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/quiz_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/leaderboard_provider.dart';
import 'home_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  void _saveResult() {
    final quizProvider = context.read<QuizProvider>();
    final authProvider = context.read<AuthProvider>();
    final leaderboardProvider = context.read<LeaderboardProvider>();

    authProvider.addXP(quizProvider.earnedXP);
    leaderboardProvider.addScore(
      authProvider.currentUser?.username ?? 'Unknown',
      quizProvider.score,
      quizProvider.earnedXP,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('نتیجه'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<QuizProvider, AuthProvider>(
        builder: (context, quizProvider, authProvider, _) {
          final score = quizProvider.score;
          final totalQuestions = quizProvider.questions.length;
          final percentage = (score / totalQuestions * 100).toStringAsFixed(0);
          final earnedXP = quizProvider.earnedXP;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$percentage%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'تبریک می‌گویم! 🎉',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        _ResultRow(
                          label: 'امتیاز',
                          value: '$score / $totalQuestions',
                          icon: Icons.check_circle,
                        ),
                        const SizedBox(height: 20),
                        _ResultRow(
                          label: 'XP کسب شده',
                          value: '+$earnedXP',
                          icon: Icons.star,
                        ),
                        const SizedBox(height: 20),
                        _ResultRow(
                          label: 'کل XP',
                          value: authProvider.currentUser?.totalXP.toString() ?? '0',
                          icon: Icons.trending_up,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<QuizProvider>().resetQuiz();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('بازگشت به خانه'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
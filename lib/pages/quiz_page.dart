import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/quiz_provider.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int _timeRemaining = 15;
  late Future<void> _loadQuestionsFuture;

  @override
  void initState() {
    super.initState();
    _loadQuestionsFuture =
        context.read<QuizProvider>().loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('کویز'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _loadQuestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return Consumer<QuizProvider>(
            builder: (context, quizProvider, _) {
              final question = quizProvider.currentQuestion;
              if (question == null) {
                return const SizedBox();
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'سوال ${quizProvider.currentQuestionIndex + 1} / ${quizProvider.questions.length}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: (quizProvider.currentQuestionIndex + 1) /
                            quizProvider.questions.length,
                        backgroundColor: AppColors.surface,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 40),
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
                            Text(
                              question.question,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            ...List.generate(
                              question.options.length,
                              (index) => _OptionButton(
                                option: question.options[index],
                                isSelected: quizProvider
                                        .selectedAnswers[
                                    quizProvider.currentQuestionIndex] ==
                                    index,
                                onTap: () {
                                  quizProvider.selectAnswer(index);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            quizProvider.submitAnswer();
                            if (quizProvider.isLastQuestion) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const ResultPage(),
                                ),
                              );
                            } else {
                              quizProvider.nextQuestion();
                            }
                          },
                          child: quizProvider.isLastQuestion
                              ? const Text('تکمیل')
                              : const Text('بعدی'),
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
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.secondary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
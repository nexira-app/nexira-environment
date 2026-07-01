import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import 'quiz_page.dart';
import 'leaderboard_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nexira'),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'سلام، ${authProvider.currentUser?.username}! 👋',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          icon: Icons.star,
                          label: 'XP',
                          value: authProvider.currentUser?.totalXP.toString() ?? '0',
                        ),
                        _StatCard(
                          icon: Icons.monetization_on,
                          label: 'Coins',
                          value:
                              authProvider.currentUser?.totalCoins.toString() ?? '0',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  _ActionButton(
                    icon: Icons.quiz,
                    label: 'شروع کویز',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const QuizPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.leaderboard,
                    label: 'صورت‌جلسه',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.person,
                    label: 'پروفایل',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfilePage(),
                        ),
                      );
                    },
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 32,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.2),
              AppColors.secondary.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 32,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
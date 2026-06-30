import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/leaderboard_provider.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF00E5FF),
                        size: 28,
                      ),
                    ),
                    const Text(
                      'LEADERBOARD',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00E5FF),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<LeaderboardProvider>(
                  builder: (context, leaderboardProvider, _) {
                    final entries = leaderboardProvider.leaderboard;
                    if (entries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.leaderboard,
                              size: 64,
                              color: Color(0xFF7B2FFF),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No scores yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B2FFF),
                              ),
                              child: const Text('Go Back'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final isTopThree = index < 3;
                        final medalEmoji = ['🥇', '🥈', '🥉'][index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isTopThree ? const Color(0xFF00E5FF) : const Color(0xFF7B2FFF),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  (isTopThree ? const Color(0xFF00E5FF) : const Color(0xFF7B2FFF)).withOpacity(0.1),
                                  (isTopThree ? const Color(0xFF00E5FF) : const Color(0xFF7B2FFF)).withOpacity(0.05),
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isTopThree)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      medalEmoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7B2FFF),
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.username,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${entry.score}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF00E5FF),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.flash_on,
                                          color: Color(0xFF7B2FFF),
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+${entry.xpEarned}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF7B2FFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}

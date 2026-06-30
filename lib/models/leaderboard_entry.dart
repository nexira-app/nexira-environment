class LeaderboardEntry {
  final String username;
  final int score;
  final int xp;
  final DateTime date;

  LeaderboardEntry({
    required this.username,
    required this.score,
    required this.xp,
    required this.date,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username'] ?? '',
      score: json['score'] ?? 0,
      xp: json['xp'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'score': score,
      'xp': xp,
      'date': date.toIso8601String(),
    };
  }
}
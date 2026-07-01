class LeaderboardEntry {
  final String username;
  final int score;
  final int xpEarned;
  final DateTime timestamp;

  LeaderboardEntry({
    required this.username,
    required this.score,
    required this.xpEarned,
    required this.timestamp,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      username: json['username'] ?? '',
      score: json['score'] ?? 0,
      xpEarned: json['xpEarned'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'score': score,
      'xpEarned': xpEarned,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

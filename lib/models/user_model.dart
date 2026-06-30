class UserModel {
  final String uid;
  final String email;
  final String username;
  final int totalXp;
  final int coins;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.totalXp = 0,
    this.coins = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      totalXp: json['totalXp'] ?? 0,
      coins: json['coins'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'totalXp': totalXp,
      'coins': coins,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? totalXp,
    int? coins,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      totalXp: totalXp ?? this.totalXp,
      coins: coins ?? this.coins,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

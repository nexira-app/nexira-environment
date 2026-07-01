class UserModel {
  final String uid;
  final String email;
  final String username;
  int totalXP;
  int totalCoins;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.totalXP = 0,
    this.totalCoins = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      totalXP: json['totalXP'] ?? 0,
      totalCoins: json['totalCoins'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'totalXP': totalXP,
      'totalCoins': totalCoins,
    };
  }
}
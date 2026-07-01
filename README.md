# Nexira - Flutter Mobile Quiz Game MVP

🎮 **Nexira** is a neon cyberpunk-themed mobile quiz game built with Flutter.

## Features

### MVP Phase
- ✅ Splash Screen with neon design
- ✅ Firebase Authentication (Login/Register)
- ✅ Home Page with stats display
- ✅ Quiz System (10 questions, 15-second timer per question)
- ✅ Result Page with score and XP display
- ✅ Local Leaderboard (Top 10 scores)
- ✅ User Profile with stats
- ✅ Neon cyberpunk UI with dark theme

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── config/
│   └── theme.dart           # App theme & colors
├── models/
│   ├── question.dart        # Question model
│   ├── leaderboard_entry.dart
│   └── user_model.dart
├── providers/
│   ├── auth_provider.dart   # Authentication logic
│   ├── quiz_provider.dart   # Quiz state management
│   └── leaderboard_provider.dart
├── pages/
│   ├── splash_screen.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── home_page.dart
│   ├── quiz_page.dart
│   ├── result_page.dart
│   ├── leaderboard_page.dart
│   └── profile_page.dart
assets/
├── data/
│   └── questions.json       # Quiz questions
├── images/                  # App images
└── animations/              # Lottie animations (optional)
```

## Tech Stack

- **Flutter 3.x**
- **Firebase Authentication**
- **Provider (State Management)**
- **SharedPreferences (Local Storage)**
- **Material 3 Design**

## Color Palette

- Primary: `#00E5FF` (Cyan Neon)
- Secondary: `#7B2FFF` (Purple Neon)
- Background: `#0A0A0A` (Dark Black)
- Surface: `#1A1A2E` (Dark Blue)

## Getting Started

### Prerequisites
- Flutter 3.x installed
- Firebase project created
- Android/iOS development environment set up

### Installation

1. Clone the repository
```bash
git clone <repo-url>
cd nexira
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Replace Firebase credentials in `firebase_options.dart`
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

4. Run the app
```bash
flutter run
```

## Firebase Setup

1. Create a new Firebase project
2. Enable Firebase Authentication (Email/Password)
3. Add your Android and iOS apps
4. Download configuration files and place them in appropriate directories
5. Update `firebase_options.dart` with your credentials

## Future Enhancements

- 🎨 Character customization
- 🏆 Online leaderboard
- 💎 In-game shop & cosmetics
- 🎯 Daily challenges
- 👥 Multiplayer mode
- 🎬 Animations & special effects

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please follow the code style and create a pull request.

---

**Developed with ❤️ by Nexira Team**

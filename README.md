# Nexira - Flutter Quiz Game MVP

Nexira is a cyberpunk-themed mobile quiz game built with Flutter. This is the MVP (Minimum Viable Product) version with core features.

## Features

### ✅ Implemented
- **Splash Screen** - Neon-styled splash screen with auto-navigation
- **Authentication** - Firebase Auth integration (Login/Register)
- **Home Page** - Dashboard with XP, Coins, and main action buttons
- **Quiz System** - 10-question quiz with 15-second timer per question
- **Scoring** - Real-time score tracking and XP rewards
- **Result Page** - Score breakdown and statistics
- **Leaderboard** - Local top 10 scores with SharedPreferences
- **Profile Page** - User profile with stats and logout
- **State Management** - Provider pattern for clean state handling
- **Responsive Design** - Works on various screen sizes
- **Cyberpunk UI** - Neon colors (#00E5FF, #7B2FFF) with dark theme

## Tech Stack

- **Framework**: Flutter 3.x
- **Backend**: Firebase Authentication
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **UI**: Material 3 + Custom Widgets

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   ├── question_model.dart  # Question data model
│   ├── user_model.dart      # User data model
│   └── leaderboard_model.dart # Leaderboard entry model
├── providers/
│   ├── auth_provider.dart   # Authentication logic
│   ├── quiz_provider.dart   # Quiz state management
│   └── leaderboard_provider.dart # Leaderboard management
├── pages/
│   ├── splash_screen.dart   # Splash screen
│   ├── login_page.dart      # Login page
│   ├── register_page.dart   # Registration page
│   ├── home_page.dart       # Home dashboard
│   ├── quiz_page.dart       # Quiz gameplay
│   ├── result_page.dart     # Results screen
│   ├── leaderboard_page.dart # Leaderboard view
│   └── profile_page.dart    # User profile
├── constants/
│   └── colors.dart          # Color constants
└── assets/
    └── data/questions.json  # Quiz questions
```

## Getting Started

### Prerequisites
- Flutter 3.x installed
- Firebase project configured
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd nexira
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Update `firebase_options.dart` with your Firebase credentials
   - For iOS: Follow Firebase iOS setup
   - For Android: Add google-services.json

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication (Email/Password)
4. Add your app (Android/iOS)
5. Download configuration files
6. Update `firebase_options.dart`

## Usage

### Login Flow
1. App launches with splash screen
2. User can login or create account
3. Credentials stored in Firebase

### Quiz Flow
1. Start quiz from home page
2. Answer 10 questions (15 seconds each)
3. Get XP for correct answers
4. View results and score
5. Score added to local leaderboard

### Leaderboard
- Top 10 scores stored locally
- Sorted by score (highest first)
- Displays username, score, XP earned, and date

## Customization

### Change Quiz Questions
Edit `assets/data/questions.json`:
```json
{
  "id": "unique-id",
  "question": "Your question here?",
  "options": ["Option1", "Option2", "Option3", "Option4"],
  "correctAnswerIndex": 0
}
```

### Customize Colors
Edit `lib/constants/colors.dart` or theme in `main.dart`

### Adjust Timer
Modify `_startTimer()` in `quiz_page.dart` (default: 15 seconds)

## Future Enhancements (Not in MVP)
- Character system
- Arena battles
- Power-ups
- Mini-games
- Online leaderboard
- Marketplace
- Complex animations
- Multiplayer modes

## Known Limitations
- Leaderboard is local only
- No advanced animations
- Limited to 10 questions per quiz
- No user profiles with images

## Troubleshooting

### Firebase not working?
- Check `firebase_options.dart` configuration
- Ensure Firebase project is active
- Verify API keys are correct

### Questions not loading?
- Check `assets/data/questions.json` exists
- Verify JSON format is correct
- Check pubspec.yaml assets configuration

## License
MIT License

## Author
Nexira Team

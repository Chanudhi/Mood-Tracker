# Mood Tracker App 🌱

A privacy-focused mobile app for tracking daily moods,and  analyzing emotional trends. Supports anonymous login to protect user identity.


## Features ✨

- **Anonymous Sign-In**: Start using the app instantly without sharing personal data.
- **Daily Mood Tracking**: Log your mood on a scale of 1–10 with emoji/slider input.
- **Mood History Calendar**: Visualize your mood patterns with a color-coded calendar view.
- **Weekly Mood Analysis**: Interactive charts showing 7-day emotional trends.


## Tech Stack 🛠️

| **Component**       | **Technology**                                                                 |
|----------------------|--------------------------------------------------------------------------------|
| **Frontend**         | Flutter & Dart (iOS/Android)                                                   |
| **State Management** | Built-in Flutter State Management                                              |
| **Backend**          | Firebase (Authentication, Firestore Database)                                  |
| **API Hosting**      | Vercel (For future Python API integrations)                                    |
| **Encryption**       | `encrypt` package (AES-256) + `flutter_secure_storage`                         |
| **Charts**           | `syncfusion_flutter_charts`                                                    |
| **Local Storage**    | `shared_preferences`                                                           |
| **Dependency Injection** | `provider`                                                                 |

### Key Packages
```yaml
dependencies:
  firebase_core: ^2.18.0        # Firebase integration
  cloud_firestore: ^4.13.0       # Firestore database
  firebase_auth: ^4.11.0         # Anonymous authentication
  syncfusion_flutter_charts: ^23.1.40  # Mood trend visualization
  encrypt: ^5.0.1                # Data encryption
  flutter_secure_storage: ^8.0.0 # Secure key storage
  table_calendar: ^3.0.9         # Mood history calendar
```
### Architecture Overview 🏗️
```
mental_health_app/
├── flutter_app/                 # Flutter Frontend
│   ├── lib/
│   │   ├── screens/             # UI Pages (Mood tracker, dashboard)
│   │   ├── services/            # Firebase API calls, encryption logic
│   │   └── widgets/             # Reusable components (slider, charts)
│
├── python_api/                  # Future API (Hosted on Vercel)
│   ├── api/                     # Python scripts for potential NLP/analytics
│   └── vercel.json              # Deployment config
│
└── firebase/                    # Backend config
    ├── firestore.rules          # Security rules
    └── firebase_config.dart     # API keys (excluded from Git)
```

## Installation 🛠️

### 1. Clone Repository
```bash
git clone https://github.com/Chanudhi/Mood-Tracker.git
cd mental_health_app
```

### 2. Firebase Setup
Create a Firebase project at console.firebase.google.com.

Add Android/iOS apps in Firebase Console.

Download:

google-services.json → android/app/ 

GoogleService-Info.plist → ios/Runner/

### 3. Run the App
```bash
flutter run -d <device_id>
```

### 4. Deploy Python API (Optional)
```bash
cd python_api
vercel deploy --prod
```

### Contributing 🤝
Fork the repository.

Create a feature branch:

```bash
git checkout -b feature/your-feature
Submit a pull request.
```


# Lifevora — AI Fitness & Nutrition 

**Lifevora** is a Flutter fitness app powered by AI, combining smart nutrition tracking, an AI coach, and a premium dark UI experience.

---

##  Features

- **Food Scanner** — Snap a meal photo and get instant macro estimations via Gemini Vision
- **AI Coach** — Real-time fitness advice with structured, psychology-backed responses
- **Macro Tracking** — Tailored calculations based on your goal (Build Muscle, Lose Fat, Maintain)
- **Gamification** — Earn XP, level up, and track progression
- **Premium UI** — Dark Glassmorphic design with animated orbs and Lucide icons

---

## 🛠 Tech Stack

| Layer | Tool |
|-------|------|
| Framework | Flutter (Dart) |
| AI | Google Gemini 1.5 Flash |
| Navigation | GoRouter |
| Animations | Flutter Animate |
| Icons | Lucide Icons |

---

##  Getting Started

```bash
git clone https://github.com/yassinebouachrine/Fitlife.git
cd gym-app
flutter pub get
cp .env.example .env
```

Add your Gemini API key to `.env`:

```env
AI_API_KEY=YOUR_GEMINI_KEY_HERE
```

```bash
terminal1 :
cd backend
npm run dev
terminal2 :
flutter run
```

---

##  Project Structure

```
lib/
├── core/           # Theme, shared widgets, navigation
├── features/
│   ├── ai_coach/   # Gemini AI logic & chat UI
│   ├── auth/       # Login & register
│   ├── nutrition/  # Food scanner & macro tracking
│   ├── onboarding/ # Intro experience
│   └── splash/     # Animated splash screen
└── main.dart
```

---

## 📄 License

MIT License

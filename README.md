# NexusGym — Smart AI Fitness & Nutrition 🏋️‍♂️🤖


**NexusGym** is a high-performance, futuristic fitness application that bridges the gap between traditional training and Artificial Intelligence. Built with a premium Dark Neumorphic and Glassmorphic aesthetic, it provides an elite user experience powered by **AI**.

---

## ✨ Key Features

### 🍱 Smart Nutrition AI (New!)
- **Food Scanner**: Snap a photo of your meal and get instant macro estimations.
- **Nutritional Deep-Dive**: Estimates calories, protein, carbs, and fats using Gemini Vision.
- **Ingredient Detection**: Automatically identifies visible ingredients.
- **Smart Macros**: Tailored macro calculations based on your fitness goals (Build Muscle, Lose Fat, Maintain).

### AI Coach & Strategy
- **Conversational Intelligence**: Real-time fitness advice and psychology-backed motivation.
- **Dynamic Programming**: Exercises and plans that adapt based on your feedback.
- **Structured Response**: AI responses are parsed into structured UI elements for better clarity.

### � Premium Aesthetics
- **Electric Coral Theme**: A vibrant, high-contrast palette optimized for deep-dark modes.
- **Glassmorphism**: Elegant overlays, blurred backgrounds, and frosted-glass containers.
- **Animated Orbs**: Floating mesh-gradient shapes that bring the UI to life.
- **Lucide Icons**: Consistent, high-fidelity iconography across all screens.

### 🌐 Metaverse & Gamification
- **Avatar Training**: Bridge your digital and physical workouts.
- **XP & Levels**: Earn XP for logging workouts and tracking nutrition.
- **3D Workspace**: A futuristic "Metaverse" space for viewing your progression.

---

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **AI Brain**: Google Gemini 1.5 Flash (Generative AI & Vision API)
- **Navigation**: GoRouter
- **Animations**: Flutter Animate
- **Icons**: Lucide Icons
- **Theming**: Custom Neumorphic/Glassmorphic engine

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- A Gemini API Key from [Google AI Studio](https://aistudio.google.com/).

### 2. Installation
```bash
git clone https://github.com/0khacha/gym-app.git
cd gym-app
flutter pub get
```

### 3. Setup Environment
Copy the example environment file and add your Gemini API Key:
```bash
cp .env.example .env
```
Open `.env` and paste your key:
```env
AI_API_KEY=YOUR_GEMINI_KEY_HERE
```

### 4. Run the App
```bash
flutter run
```

---

## � Project Organization

```text
lib/
├── core/               # Theme, Shared Widgets, Navigation
├── features/           # Feature-based Architecture
│   ├── ai_coach/       # Gemini AI Logic & Chat UI
│   ├── auth/           # Login & Register (Neumorphic forms)
│   ├── main_shell/     # Glassmorphic Navigation
│   ├── nutrition/      # Food Scanner & Macro Tracking
│   ├── onboarding/     # Premium Intro Experience
│   └── splash/         # Animated Mesh Orbs
└── main.dart           # App Entry Point
```

---

## 📄 License
This project is licensed under the MIT License.

---


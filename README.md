# Ishara (ইশারা) — Inclusive Sign Language App (BdSL & ASL)

**Ishara (ইশারা)** is a lightweight, offline-first educational application designed to facilitate introductory learning of **Bengali Sign Language (BdSL)** and **American Sign Language (ASL)**.

Built with native Flutter, it features offline-cached typography, structured gesture descriptions, 7-language UI localization, and an ergonomic mobile design.

---

## 🌟 Key Features
- **Dual Curriculum Tracks:** Learn standardized Bengali Sign Language (BdSL) and international ASL side-by-side.
- **7-Language Localization:** Instant switching between Bengali, English, Arabic (RTL), Hindi, Urdu (RTL), Spanish, and French.
- **100% Offline-First:** Bundled offline fonts and local SQLite/SharedPreferences storage with zero cloud dependence.
- **Interactive Mirror Mode:** Check hand positioning using on-device front camera alignment without uploading any video feed.
- **Fast Searchable Dictionary:** Filter signs by daily essentials, emergency healthcare, numbers, and alphabets with local bookmarking.

---

## 🛠️ Architecture & Tech Stack
- **Framework:** Flutter 3.41+ / Dart 3.11+
- **Architecture:** Feature-First Clean Architecture (`core/`, `features/curriculum/`, `features/quiz/`, `features/dictionary/`, `features/onboarding/`)
- **State & Local Storage:** `shared_preferences` for progress and bookmarked signs.
- **Typography:** Bundled offline `Hind Siliguri` font.

---

## 📱 Platforms & Build
- **Android:** Application ID `com.yourpremiumapp.ishara`
- **Web:** Hosted live on Vercel: [https://ishara-sign-language.vercel.app](https://ishara-sign-language.vercel.app)
- **Privacy Policy:** [https://ishara-sign-language.vercel.app/privacy](https://ishara-sign-language.vercel.app/privacy)

---

## ⚠️ Pedagogical Disclaimer
This application serves as an introductory learning aid and community accessibility tool. For comprehensive and formal sign language proficiency, learners are encouraged to practice alongside certified Deaf instructors and accredited institutions.

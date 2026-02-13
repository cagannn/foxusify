# Foxusify: Pomodoro League Development Master Plan

Bu belge, Foxusify projesini "Rekabetçi Pomodoro Ligi" uygulamasına dönüştürmek için gereken adım adım geliştirme planını içerir. Her aşama, bir AI asistanına (Cursor, Antigravity, Copilot) verilecek **Prompt** bilgisini de barındırır.

---

## 🚀 Aşama 1: Mimari Kurulumu ve Paketler (Architecture & Setup)

Mevcut proje yapısını "Feature-First" mimarisine geçirmek ve State Management eklemek.

- [ ] **Paketlerin Eklenmesi:** `pubspec.yaml` dosyasına gerekli bağımlılıkları ekle.
- [ ] **Klasör Yapısının Düzenlenmesi:** Özellik tabanlı klasör yapısına geçiş.
- [ ] **Riverpod Kurulumu:** `main.dart` dosyasını `ProviderScope` ile sarmala.

> **AI Prompt:**
> "Act as a Senior Flutter Architect. Refactor 'foxusify' for scalability:
> 1. Add packages to pubspec.yaml: `flutter_riverpod`, `riverpod_annotation`, `freezed_annotation`, `lottie` (for animations), `intl`. Dev dependencies: `build_runner`, `riverpod_generator`, `freezed`.
> 2. Reorganize `/lib` into a Feature-First structure:
>    - `features/auth` (move existing login/signup here)
>    - `features/pomodoro` (timer & xp logic)
>    - `features/league` (leaderboard & ranking)
>    - `features/rewards` (badges & animations)
>    - `core/` (shared services, supabase client, theme)
> 3. Wrap `MyApp` in `main.dart` with `ProviderScope`.
> Show me the updated file structure and run `flutter pub get`."

---

## 🗄️ Aşama 2: Supabase Veritabanı Şeması (Database Schema)

Lig sistemi ve ödül mekanizması için veritabanı tablolarını oluştur.

- [ ] **Profiles Tablosu:** Kullanıcı XP ve Seviye bilgisi.
- [ ] **Weekly League Tablosu:** Pazartesi günü seviye dondurma (snapshot) mantığı.
- [ ] **Pending Rewards Tablosu:** Gecikmeli ödül animasyonu için kuyruk sistemi.
- [ ] **Badges Tablosu:** Kazanılan rozetler.

> **AI Prompt:**
> "Generate a Supabase SQL script to create these tables with RLS policies:
> 1. `profiles`: id (uuid), current_xp (int), current_level (int), total_focus_time (int).
> 2. `weekly_league_participants`: id (uuid), user_id (uuid), week_start_date (date), starting_level (int) [Critical for fairness], weekly_xp (int).
> 3. `pending_rewards`: id (uuid), user_id (uuid), reward_type (text), week_date (date), is_claimed (boolean, default false).
> 4. `user_badges`: id (uuid), user_id (uuid), badge_slug (text), earned_at (timestamp).
> Ensure users can read the leaderboard but only update their own progress."

---

## ⏱️ Aşama 3: Pomodoro Mantığı ve XP Sistemi (Core Logic)

Zamanlayıcıyı kurmak ve XP hesaplama motorunu yazmak.

- [ ] **XP Calculator:** Seviye atlama formülü (Örn: Her seviye %10 daha zor).
- [ ] **Pomodoro Controller:** Riverpod ile zamanlayıcı durumu.
- [ ] **DB Sync:** Sayaç durduğunda XP'yi hem `profiles` hem `weekly_league` tablosuna yaz.

> **AI Prompt:**
> "Implement the Pomodoro Logic using Riverpod:
> 1. Create `core/logic/xp_calculator.dart`: Formula where Level 1 = 100 XP, increasing by 10% per level. 1 Second focus = 0.1 XP.
> 2. Create `features/pomodoro/controller/timer_controller.dart`:
>    - Manage timer state (running, paused, finished).
>    - On finish, verify time and call Supabase RPC or direct update to increment `current_xp` in `profiles` AND `weekly_xp` in `weekly_league_participants`.
> 3. Create a simple UI showing the Timer, Circular Progress, and Live XP gain."

---

## 📅 Aşama 4: Pazartesi Ligi Mantığı (Backend / Edge Functions)

Uygulama kapalıyken ligi sonlandırıp kazananları belirleyen sistem.

- [ ] **Edge Function Oluştur:** `finish-weekly-league` adında bir fonksiyon.
- [ ] **Cron Job:** Her Pazartesi 00:00'da çalışacak şekilde ayarla.
- [ ] **Mantık:** Geçen haftanın kazananlarını bul -> `pending_rewards` tablosuna ekle -> Yeni hafta için herkesin seviyesini `starting_level` olarak kaydet.

> **AI Prompt:**
> "Write a Supabase Edge Function (TypeScript) named 'finish-weekly-league' that runs on Cron (Monday 00:00):
> 1. Calculate 'last week start date'.
> 2. Fetch `weekly_league_participants` for that week.
> 3. Group users by `starting_level`.
> 4. Identify Top 3 for each group.
> 5. Insert winners into `pending_rewards` (reward_type: '1st_place', etc.).
> 6. Reset logic: Create rows in `weekly_league_participants` for the NEW week, locking in everyone's CURRENT level as `starting_level`."

---

## 🎁 Aşama 5: Gecikmeli Ödül Animasyonu (Frontend)

Kullanıcı aylar sonra girse bile ödülünü animasyonla almalı.

- [ ] **Reward Service:** Açılışta `pending_rewards` tablosunu kontrol et.
- [ ] **Reward Overlay:** Eğer ödül varsa, ana sayfa açılmadan üzerine Lottie animasyonu bindir.
- [ ] **Claim Logic:** Animasyon bitince ödülü "alındı" olarak işaretle ve rozet ekle.

> **AI Prompt:**
> "Implement the 'Delayed Reward' system in Flutter:
> 1. Create `RewardCheckService` (Riverpod provider). On app init, query `pending_rewards` where `user_id=me` AND `is_claimed=false`.
> 2. If a reward exists, trigger a `RewardOverlay` widget (Full screen dialog).
> 3. Show a Lottie animation (e.g., a knight bowing).
> 4. When the user dismisses it:
>    - Update `pending_rewards` set `is_claimed=true`.
>    - Add the corresponding badge to `user_badges` locally."

---

## 🏆 Aşama 6: Profil ve Liderlik Tablosu (UI Polish)

- [ ] **Leaderboard UI:** Kendi seviyendeki (Ligindeki) insanları sırala.
- [ ] **Profile UI:** İstatistikler ve kazanılan rozetler "Müze" görünümü.

> **AI Prompt:**
> "Build the 'League & Profile' screens:
> 1. `LeagueScreen`: Fetch `weekly_league_participants` filtered by the current user's `starting_level`. Sort by `weekly_xp` descending. Highlight the current user.
> 2. `ProfileScreen`: Show User Avatar, Current Level, and a GridView of `user_badges`. Tapping a badge replays its animation."

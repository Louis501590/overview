# Overview

Persönliche Offline-Fitness-App (Flutter Web / PWA). Keine Cloud, keine Konten,
alle Daten liegen lokal auf dem Gerät (SQLite via drift im Browser).

## Auf dem iPhone installieren (kostenlos)
1. Die GitHub-Pages-Adresse in **Safari** öffnen.
2. Teilen → **Zum Home-Bildschirm**.
3. App vom Home-Bildschirm starten (nicht aus Safari!) und das Onboarding dort durchführen.
4. Unter *Mehr* regelmäßig eine **Sicherung exportieren** (Datei in iCloud Drive ablegen).
5. 05:00-Erinnerung: Anleitung unter *Mehr* (iOS-Kurzbefehle).

## Entwicklung
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift-Code
flutter test
flutter run -d chrome
```
Der drift-Worker wird bei drift-Updates neu gebaut:
`dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js`
(und `web/sqlite3.wasm` passend zur drift-Version ersetzen).

## Struktur
- `lib/domain` – reine Logik (e1RM, Progression, Termine) ohne Flutter, voll getestet
- `lib/data` – drift-Datenbank, Repository, Backup
- `lib/features` – Screens (Dashboard, Training, Gewicht, Mehr)

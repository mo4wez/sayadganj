# سَیّدگَنج (SayadGanj)

An offline-first Balochi-to-Balochi dictionary mobile application built with Flutter, bringing **Sayad Hashumi's** landmark lexicographical work into a fast, modern, and accessible reading experience.

---

## Features

- **Offline Dictionary (~17,000 Entries):** Fast local SQLite search with `LIMIT`/`OFFSET` pagination and clickable cross-references between related entries.
- **Word of the Day (روچ ءِ گال):** Rolling 7-day local notifications powered by Android's `AlarmManager`, featuring customizable daily reminder times, boot persistence (`RECEIVE_BOOT_COMPLETED`), monochrome status bar iconography, and native RTL formatting.
- **Interactive Vocabulary Quiz (گال چکّاس):** Practice and test Balochi word definitions offline directly from the dictionary corpus.
- **Balochi-First Typography & RTL Interface:** Full right-to-left layout with curated Balochi typefaces, live specimen previews in settings, and adjustable reading scale (`85%`–`145%`).
- **Adaptive Theme Engine:**
  - **Modes:** System, Light (*Warm Paper*), Dark (*Obsidian Slate*), and Pure Black (*AMOLED*).
  - **Accent & Surface Styles:** Customizable accent palettes with *Vivid*, *Soft*, *Tinted*, and *Monochrome* styles.
- **Bookmarks & Search History:** Save favorite entries in a dedicated user SQLite database and manage recent search history locally.
- **TakbandQandeel Literary Community:** Non-intrusive, frequency-capped community sheet linking readers to Balochi literary publications and podcasts.

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Local Persistence:** SQLite (`sqflite`) for dictionary and user data; `shared_preferences` for appearance, notification, and session preferences
- **Native Android Integration:** Kotlin `MethodChannel` (`com.example.sayadganj/rtl_notifications`) with `AlarmManager`, `BroadcastReceiver`, and `NotificationCompat.BigTextStyle`
- **UI & Utilities:** `lucide_icons_flutter`, `flutter_animate`, `carousel_slider`, `url_launcher`

---

## Project Structure

```text
lib/
├── core/
│   ├── database/          # Read-only dictionary DB & writable user DB helpers
│   ├── services/          # SharedPreferences & platform service providers
│   └── theme/             # AppTheme (Light, Dark, AMOLED), typography & accent styles
└── features/
    ├── community/         # Frequency-capped TakbandQandeel prompt & bottom sheet
    ├── dictionary/        # Search, paginated word list, word details & cross-references
    ├── notifications/     # Rolling 7-day Word of the Day scheduler & settings card
    ├── quiz/              # Interactive Balochi vocabulary quiz
    └── settings/          # Appearance, font preview/scaling, history & about screens

# سَیدگَنج (SayadGanj)

An offline-first Balochi-to-Balochi dictionary mobile application built with Flutter, bringing **Sayad Hashumi's** landmark lexicographical work into a fast, modern, and accessible reading experience.

---

## Features

- **Offline Dictionary (~17,000 Entries):** Fast local SQLite search with `LIMIT`/`OFFSET` pagination, structured definitions, abbreviations/notations guide, and clickable cross-references between related entries.
- **Full Balochi & Persian UI Localization:** Live language switching between Balochi (`bal`) and Persian (`fa`) powered by Flutter `gen-l10n` and custom Balochi Material, Cupertino, and Widgets localization delegates, with full RTL support.
- **Smart Search & Discovery:**
  - **Search Scopes:** Filter results by _Contains in Headword_, _Starts With_, or _In Definitions_.
  - **Alphabet Dial:** Browse dictionary entries by letter with an interactive dial sheet.
  - **Balochi Character Toolbar:** Animated quick-insert bar for special Balochi characters while typing.
  - **Animated Brand Header:** Editorial app bar with an entrance animation, periodic 3D book-tilt & sparkle accent, and tap-to-swap title/description with quick filter reset.
- **Word of the Day (روچ ءِ گال) & Reading Streak:** Rolling 7-day local notifications powered by Android's `AlarmManager` (with customizable reminder times, `RECEIVE_BOOT_COMPLETED` persistence, and native RTL formatting), alongside daily word carousels and reading streak tracking.
- **Interactive Vocabulary Quiz (گال چکّاس):** Practice and test Balochi word definitions offline directly from the dictionary corpus.
- **Balochi-First Typography & Reading Controls:** Curated Balochi and Persian typefaces, live specimen previews in settings, and adjustable reading scale (`85%`–`145%`).
- **Adaptive Theme & Navigation Engine:**
  - **Modes:** System, Light (_Warm Paper_), Dark (_Obsidian Slate_), and Pure Black (_AMOLED_).
  - **Accent & Surface Styles:** 7 customizable accent palettes (_Teal_, _Emerald_, _Blue_, _Violet_, _Amber_, _Rose_, _Ink_) paired with _Vivid_, _Soft_, _Tinted_, and _Monochrome_ styles.
  - **Navigation Styles:** Switch between _Docked_ and _Floating_ (capsule) bottom navigation bars.
- **Bookmarks & Search History:** Save favorite entries in a dedicated user SQLite database and manage recent search history locally.
- **TakbandQandeel Literary Community:** Non-intrusive, frequency-capped community sheet linking readers to Balochi literary publications, Telegram, Instagram, and YouTube.

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Localization:** Flutter `gen-l10n` (`l10n.yaml`, `app_bal.arb`, `app_fa.arb`) with custom Balochi delegates
- **Local Persistence:** SQLite (`sqflite`) for dictionary and user data; `shared_preferences` for locale, theme, font, notification, and session preferences
- **Native Android Integration:** Kotlin `MethodChannel` (`com.example.sayadganj/rtl_notifications`) with `AlarmManager`, `BroadcastReceiver`, and `NotificationCompat.BigTextStyle`
- **UI & Utilities:** `lucide_icons_flutter`, `flutter_animate`, `carousel_slider`, `url_launcher`

---

## Project Structure

```text
lib/
├── l10n/                  # ARB files (app_bal.arb, app_fa.arb), generated localizations & custom Balochi delegates
├── core/
│   ├── database/          # Read-only dictionary DB & writable user DB helpers
│   ├── services/          # SharedPreferences, locale & platform service providers
│   └── theme/             # AppTheme (Light, Dark, AMOLED), ThemeAppearanceState, accent/color/bottom-bar styles & typography
└── features/
    ├── community/         # Frequency-capped TakbandQandeel prompt & follow sheet
    ├── dictionary/        # Search scopes, animated brand header, alphabet dial, paginated word list, word details & cross-references
    ├── notifications/     # Rolling 7-day Word of the Day scheduler & settings card
    ├── quiz/              # Interactive Balochi vocabulary quiz
    └── settings/          # Language switcher, appearance, bottom bar style, font preview/scaling, history & about screens
```

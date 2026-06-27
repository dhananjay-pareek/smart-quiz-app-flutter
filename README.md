# Learn With SmartQuiz — Flutter (Android) Port

This is a 1:1 Flutter/Android port of the original **Learn-It-All Quiz** web
app (`index.html` + `script.js` + `style.css` + `bg.css`). Same screens, same
quiz logic, same dark "glassmorphism on an animated gradient" look — just
running natively on Android instead of in a browser.

## What was ported, and how

| Web app | Flutter equivalent |
|---|---|
| `index.html` (5 `<div id="...">` views) | `lib/screens/*.dart` (one widget per view) |
| `script.js` `App` object (state + methods) | `lib/app.dart` → `_QuizAppState` |
| `fetch('./chapters.json')` / `fetch('./chapters/*.json')` | `rootBundle.loadString('assets/...')` in `lib/services/quiz_data_service.dart` |
| `localStorage` (`customQuizQuestions`, `chapterProgress`) | `shared_preferences`, same keys/shape, in `quiz_data_service.dart` |
| `bg.css` (glass cards, animated gradient, buttons, option list, chapter list, modal) | `lib/theme/app_colors.dart` + `lib/widgets/*.dart` |
| `#confirm-modal` | `lib/widgets/confirm_dialog.dart` (`showConfirmModal(...)`) |

The quiz logic is unchanged: chapters are shuffled per attempt, score and
"Question X / Y" track the same way, skip/incorrect answers are collected
for the end-of-quiz review screen, and completed chapters are remembered
across launches.

The only things that intentionally differ are *implementation details* that
don't exist on Android: there is no DOM, so the original's animated CSS
gradient (`background-size: 400%` panning + `blur(60px)`) is recreated with
an `AnimationController`-driven gradient + `BackdropFilter` blur that gives
the same slow-drifting, blurred-color effect. The "Inter" web font isn't
bundled (no network access was available while porting this), so the app
currently falls back to Android's default Roboto — drop your own `Inter-*.ttf`
files into an `assets/fonts/` folder and register them in `pubspec.yaml` if
you'd like an exact font match.

## Project structure

```
lib/
  main.dart                     # Entry point, MaterialApp, dark theme
  app.dart                      # Root controller (state machine, same
                                 # responsibilities as App in script.js)
  models/
    chapter.dart                # {name, questions}
    question.dart                # {type, text, options, answer}
  services/
    quiz_data_service.dart      # asset loading + shared_preferences I/O
  screens/
    main_menu_screen.dart
    chapter_selection_screen.dart
    quiz_screen.dart
    quiz_complete_screen.dart
    add_questions_screen.dart
  widgets/
    animated_gradient_background.dart
    glass_card.dart
    app_button.dart
    app_progress_bar.dart
    options_list.dart
    chapter_list.dart
    confirm_dialog.dart
  theme/
    app_colors.dart              # all colors ported from bg.css

assets/
  chapters.json                  # same index file as the web app
  chapters/*.json                # same 36 chapter files, unmodified

android/                          # standard Flutter Android embedding
```

## Running it

You'll need the [Flutter SDK](https://docs.flutter.dev/get-started/install)
installed locally (this project was authored without access to the SDK, so
it hasn't been run through `flutter pub get` / `flutter analyze` yet).

```bash
cd smart_quiz_app

# 1. Regenerates the few platform files that can't be hand-written
#    (local.properties, the Gradle wrapper jar, etc.) without
#    overwriting anything in lib/, assets/, or pubspec.yaml.
flutter create .

# 2. Fetch packages (shared_preferences, cupertino_icons, flutter_lints).
flutter pub get

# 3. Run on a connected device / emulator.
flutter run

# ...or build a release APK:
flutter build apk --release
```

If `flutter create .` ever asks to overwrite a file, say no — it's only
needed to fill in the handful of generated platform files this project is
missing because it was built outside of an actual Flutter SDK environment.

## Adding your own questions

The "Add Custom Questions" screen works exactly like the original: paste a
JSON array of chapters in the format shown on-screen and tap **Save Bulk
Questions**. New questions are merged into a matching chapter name
(case-insensitive) or added as a new chapter, and persist across app
restarts via `shared_preferences`.

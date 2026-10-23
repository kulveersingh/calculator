# Calculator

A cross-platform calculator in Flutter — web, iOS, and macOS — sharing one pure
logic module, [`lib/calculator_engine.dart`](lib/calculator_engine.dart).

The project exists to exercise `calculator_engine.dart`'s 15 test cases (basic
ops, decimals, operator precedence, zero handling, long-input parsing, and edge
cases) end-to-end through every target.

## Repository layout

| Path | Contents |
|------|----------|
| `lib/main.dart` | Terminal I/O entry point. Run with `dart run lib/main.dart`. |
| `lib/calculator_engine.dart` | Pure calculation logic + 15-test validation. `dart run lib/calculator_engine.dart` runs the tests. |
| `ios/`, `macos/`, `web/` | Generated platform targets. |
| `.github/workflows/ci.yml` | Cross-platform CI: analyze + unit test + web/macOS/iOS builds. |

## Run locally

### Terminal (fastest)
```
cd calculator
flutter pub get
dart run lib/main.dart
```
Try:
- `8 / 0 =` → `Error`
- `12*5+3*2 =` → `78`
- `3^2 =` → `9`
- `√4 =` → `2`
- `(1+2)*3 =` → `9`

### Run the 15-test suite
```
dart run lib/calculator_engine.dart
```

### Web
```
flutter run -d chrome --web-rendering html
```

### macOS
```
EXCLUDED_ARCHS="x86_64" flutter build macos --release
open build/macos/Build/Products/Release/calculator.app
```

### iOS
Builds via the `macos-build` CI job. Locally on macOS:
```
flutter build ios --no-codesign --release
```

## CI

- **Linux job:** `flutter analyze` → `flutter test` → `flutter build web --release`.
- **macOS job:** `flutter build macos --release` and uploads `calculator.app` as an artifact.

Push to `main` to trigger both.

## Notes

- Built and validated on **Xcode 27.1 / Flutter 3.29.0**. Older Flutter versions
  targeting deployment target 10.14 fail on Xcode 27; the macOS build forces
  `-arch arm64` to sidestep that.
- This is a private repo as of Oct 2026. Toggle via GitHub settings or
  `gh repo visibility public`.

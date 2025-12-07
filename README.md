# Chat App New - Flutter Project

This is a new Flutter project with the UI code extracted from the original chat app.

## 🚀 Setup Instructions

### 1. Install Dependencies

```bash
cd "F:\Flutter projects\chat_app_new"
flutter pub get
```

### 2. Generate Code

You need to generate the router code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                          # Entry point
└── src/
    ├── core/
    │   ├── resources/                 # Themes and constants
    │   │   ├── sizes.dart
    │   │   ├── light_theme.dart
    │   │   └── dark_theme.dart
    │   └── router/
    │       └── app_router.dart       # Auto route configuration
    └── feature/
        ├── app/
        │   └── widget/               # App-level widgets
        │       ├── app_configuration.dart
        │       ├── app_lifecycle_scope.dart
        │       └── app_router_builder.dart
        ├── chat/
        │   ├── page/
        │   │   └── chat_page.dart    # Main chat UI
        │   └── widget/
        │       ├── chat_app_bar.dart  # Chat header
        │       └── scope/
        │           └── chat_scope.dart
        └── settings/
            ├── enum/
            │   └── app_theme.dart
            └── widget/
                └── scope/
                    └── settings_scope.dart
```

## 📦 Dependencies

- **auto_route** - Navigation/routing
- **flutter_bloc** - State management
- **flutter_chat_ui** - Chat UI components
- **flutter_chat_types** - Chat message types
- **intl** - Internationalization
- **url_launcher** - Opening URLs

## ⚠️ Important Notes

1. **Code Generation Required**: After `flutter pub get`, you MUST run:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   This generates `app_router.gr.dart` which is required for routing.

2. **Simplified Implementation**: This version has simplified BLoC implementations. You may need to:
   - Add proper message types from `flutter_chat_types`
   - Implement actual chat functionality (API calls, etc.)
   - Add proper state management for settings

3. **Assets**: 
   - Fonts: Add Inter font files to `assets/fonts/inter/` if you want custom fonts
   - Images: Add any images to `assets/images/`

4. **Current Status**: 
   - ✅ All UI files created
   - ✅ Basic structure in place
   - ⚠️ Needs code generation (`build_runner`)
   - ⚠️ Chat functionality is simplified (needs real implementation)

## 🎨 Features

- ✅ Beautiful chat UI with blur effects
- ✅ Light/Dark theme support
- ✅ Auto route navigation
- ✅ BLoC state management structure
- ✅ Custom chat theme styling

## 🔧 Next Steps

1. Run `flutter pub get`
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Add your chat API integration
4. Implement proper message handling
5. Add fonts and images to assets folder

## 📝 License

This project is for development purposes.

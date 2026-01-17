# picPics - Photo Organizer

<div align="center">
  <img src="lib/images/logo.png" alt="picPics Logo" width="160"/>
  
  **Organize your photos with tags and keep them safe**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
  [![License](https://img.shields.io/github/license/leonardocustodio/picpics)](LICENSE)
</div>

#### Important note: The main branch is undergoing a major refactor and is non-functional. If you are looking for the published version, you can find it [here](https://github.com/leonardocustodio/picpics/releases/tag/v1.7.0).

## 📱 About picPics

picPics is a Flutter-based photo organization app that helps you manage and categorize your photos using a tag-based system. With features like secret photo protection, multiple tag support, and an intuitive swipe interface, PicPics makes photo organization effortless and enjoyable.

## ✨ Features

- **📸 Smart Photo Organization**: Tag your photos with custom labels like "Family", "Travel", "Pets", etc.
- **🏷️ Multiple Tags**: Add multiple tags to a single photo for better organization
- **🔒 Secret Photos**: Keep sensitive photos protected with a secret key
- **👆 Intuitive Swipe Interface**: Simply swipe through photos to organize them quickly
- **📅 Daily Challenges**: Get daily reminders to organize a set number of photos
- **🔍 Powerful Search**: Find photos quickly by searching through tags
- **📍 Location Tagging**: Add location information to your photos
- **🌍 Multi-language Support**: Available in 17 languages including English, Spanish, Portuguese, French, German, and more
- **🎯 Batch Operations**: Tag multiple photos at once
- **📤 Export Functionality**: Export your organized photo library

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- iOS/Android development environment set up

### Installation

1. Clone the repository:
```bash
git clone https://github.com/leonardocustodio/picpics.git
cd picpics
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Add your `google-services.json` file to `/android/app/`
   - Add your `GoogleService-Info.plist` file to `/ios/Runner/`

4. Run the app:
```bash
flutter run
```

## 🌐 Localization

PicPics supports the following languages:
- English (en)
- Portuguese (pt-BR)
- Spanish (es)
- French (fr)
- German (de)
- Italian (it)
- Dutch (nl)
- Russian (ru)
- Japanese (ja)
- Korean (ko)
- Chinese (zh)
- Hindi (hi)
- Indonesian (id)
- Malay (ms)
- Polish (pl)
- Swedish (sv)
- Thai (th)

## 🔒 Privacy & Security

- Photos remain on your device
- Secret photos are encrypted and protected with a user-defined key
- Biometric authentication support (Face ID, Touch ID, Fingerprint)
- No photos are uploaded to external servers without explicit user action

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the Apache 2.0 - see the [LICENSE](LICENSE) file for details.

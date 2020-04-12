cd android
flutter build apk
bundle exec fastlane beta
cd ../ios
flutter build ios --release --no-codesign
bundle exec fastlane beta
cd ..
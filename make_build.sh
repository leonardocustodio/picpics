flutter build ios --release --no-codesign
cd ios
bundle exec fastlane beta
cd ../android
flutter build appbundle
bundle exec fastlane beta
cd ..

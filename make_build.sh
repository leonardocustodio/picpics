cd android
flutter build appbundle
cd ../ios
flutter build ios --release --no-codesign
fastlane beta
cd ..
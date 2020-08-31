(
  cd android || exit
  flutter build appbundle
  bundle exec fastlane beta
)
(
  cd ios || exit
  flutter build ios --release --no-codesign
  bundle exec fastlane beta
)
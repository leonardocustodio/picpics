build_android() {
  (
  cd android || exit 0
  flutter build appbundle
  bundle exec fastlane beta
  )
}

build_ios() {
  (
  cd ios || exit 0
  flutter build ios --release --no-codesign
  bundle exec fastlane beta
  )
}

if [ "$1" = "" ] ; then
  build_android
  build_ios
  exit 0
fi

while [ "$1" != "" ]; do
    case $1 in
        ios )       shift
                    build_ios
                    ;;
        android )   shift
                    build_android
                    ;;
        all | * )   build_android
                    build_ios
                    exit 0
    esac
    shift
done
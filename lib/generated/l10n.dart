// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit tag`
  String get edit_tag {
    return Intl.message(
      'Edit tag',
      name: 'edit_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Now your photos will be always organized`
  String get photos_always_organized {
    return Intl.message(
      'Now your photos will be always organized',
      name: 'photos_always_organized',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_string {
    return Intl.message(
      'Continue',
      name: 'continue_string',
      desc: '',
      args: [],
    );
  }

  /// `To organize your photos we need access to your photo gallery`
  String get gallery_access_reason {
    return Intl.message(
      'To organize your photos we need access to your photo gallery',
      name: 'gallery_access_reason',
      desc: '',
      args: [],
    );
  }

  /// `We bring a daily package for you to gradually organize your library.`
  String get tutorial_daily_package {
    return Intl.message(
      'We bring a daily package for you to gradually organize your library.',
      name: 'tutorial_daily_package',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Organize your photos by adding tags, like "family", "pets", or whatever you want.`
  String get tutorial_however_you_want {
    return Intl.message(
      'Organize your photos by adding tags, like "family", "pets", or whatever you want.',
      name: 'tutorial_however_you_want',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `After adding the tags to your photo, just swipe to go to the next one.`
  String get tutorial_just_swipe {
    return Intl.message(
      'After adding the tags to your photo, just swipe to go to the next one.',
      name: 'tutorial_just_swipe',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Suggestions`
  String get suggestions {
    return Intl.message(
      'Suggestions',
      name: 'suggestions',
      desc: '',
      args: [],
    );
  }

  /// `Photo location`
  String get photo_location {
    return Intl.message(
      'Photo location',
      name: 'photo_location',
      desc: '',
      args: [],
    );
  }

  /// `country`
  String get country {
    return Intl.message(
      'country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Add tag`
  String get add_tag {
    return Intl.message(
      'Add tag',
      name: 'add_tag',
      desc: '',
      args: [],
    );
  }

  /// `Add tags`
  String get add_tags {
    return Intl.message(
      'Add tags',
      name: 'add_tags',
      desc: '',
      args: [],
    );
  }

  /// `Full Screen`
  String get full_screen {
    return Intl.message(
      'Full Screen',
      name: 'full_screen',
      desc: '',
      args: [],
    );
  }

  /// `Photo Gallery`
  String get photo_gallery_title {
    return Intl.message(
      'Photo Gallery',
      name: 'photo_gallery_title',
      desc: '',
      args: [],
    );
  }

  /// `Photos not yet organized`
  String get photo_gallery_description {
    return Intl.message(
      'Photos not yet organized',
      name: 'photo_gallery_description',
      desc: '',
      args: [],
    );
  }

  /// `{howMany, plural, zero{No photos selected} one{1 photo selected} other{{howMany} photos selected}}`
  String photo_gallery_count(num howMany) {
    return Intl.plural(
      howMany,
      zero: 'No photos selected',
      one: '1 photo selected',
      other: '$howMany photos selected',
      name: 'photo_gallery_count',
      desc: '',
      args: [howMany],
    );
  }

  /// `Organized Photos`
  String get organized_photos_title {
    return Intl.message(
      'Organized Photos',
      name: 'organized_photos_title',
      desc: '',
      args: [],
    );
  }

  /// `Photos that have already been tagged`
  String get organized_photos_description {
    return Intl.message(
      'Photos that have already been tagged',
      name: 'organized_photos_description',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message(
      'Search...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any tagged photos yet`
  String get no_tagged_photos {
    return Intl.message(
      'You don\'t have any tagged photos yet',
      name: 'no_tagged_photos',
      desc: '',
      args: [],
    );
  }

  /// `Start tagging`
  String get start_tagging {
    return Intl.message(
      'Start tagging',
      name: 'start_tagging',
      desc: '',
      args: [],
    );
  }

  /// `No tags found`
  String get no_tags_found {
    return Intl.message(
      'No tags found',
      name: 'no_tags_found',
      desc: '',
      args: [],
    );
  }

  /// `Search results`
  String get search_results {
    return Intl.message(
      'Search results',
      name: 'search_results',
      desc: '',
      args: [],
    );
  }

  /// `Daily challenge`
  String get daily_challenge {
    return Intl.message(
      'Daily challenge',
      name: 'daily_challenge',
      desc: '',
      args: [],
    );
  }

  /// `Daily goal`
  String get daily_goal {
    return Intl.message(
      'Daily goal',
      name: 'daily_goal',
      desc: '',
      args: [],
    );
  }

  /// `Notification time`
  String get notification_time {
    return Intl.message(
      'Notification time',
      name: 'notification_time',
      desc: '',
      args: [],
    );
  }

  /// `Share with friends`
  String get share_with_friends {
    return Intl.message(
      'Share with friends',
      name: 'share_with_friends',
      desc: '',
      args: [],
    );
  }

  /// `Rate this app`
  String get rate_this_app {
    return Intl.message(
      'Rate this app',
      name: 'rate_this_app',
      desc: '',
      args: [],
    );
  }

  /// `How many pics`
  String get how_many_pics {
    return Intl.message(
      'How many pics',
      name: 'how_many_pics',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Take a look at this app!`
  String get take_a_look {
    return Intl.message(
      'Take a look at this app!',
      name: 'take_a_look',
      desc: '',
      args: [],
    );
  }

  /// `To organize all your photos go to {url}`
  String take_a_look_description(Object url) {
    return Intl.message(
      'To organize all your photos go to $url',
      name: 'take_a_look_description',
      desc: '',
      args: [url],
    );
  }

  /// `For us to be able to send your daily challenges we need authorization to send notifications, so, it is necessary that you authorize the notifications in the options of your cell phone`
  String get daily_challenge_permission_description {
    return Intl.message(
      'For us to be able to send your daily challenges we need authorization to send notifications, so, it is necessary that you authorize the notifications in the options of your cell phone',
      name: 'daily_challenge_permission_description',
      desc: '',
      args: [],
    );
  }

  /// `You are premium!`
  String get you_are_premium {
    return Intl.message(
      'You are premium!',
      name: 'you_are_premium',
      desc: '',
      args: [],
    );
  }

  /// `Get premium now!`
  String get get_premium_now {
    return Intl.message(
      'Get premium now!',
      name: 'get_premium_now',
      desc: '',
      args: [],
    );
  }

  /// `GET PREMIUM`
  String get get_premium_title {
    return Intl.message(
      'GET PREMIUM',
      name: 'get_premium_title',
      desc: '',
      args: [],
    );
  }

  /// `TO HAVE ALL THESE FEATURES`
  String get get_premium_description {
    return Intl.message(
      'TO HAVE ALL THESE FEATURES',
      name: 'get_premium_description',
      desc: '',
      args: [],
    );
  }

  /// `No Ads`
  String get no_ads {
    return Intl.message(
      'No Ads',
      name: 'no_ads',
      desc: '',
      args: [],
    );
  }

  /// `Export all gallery`
  String get export_all_gallery {
    return Intl.message(
      'Export all gallery',
      name: 'export_all_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Infinite tags`
  String get infinite_tags {
    return Intl.message(
      'Infinite tags',
      name: 'infinite_tags',
      desc: '',
      args: [],
    );
  }

  /// `Tag multiple photos at once`
  String get tag_multiple_photos_at_once {
    return Intl.message(
      'Tag multiple photos at once',
      name: 'tag_multiple_photos_at_once',
      desc: '',
      args: [],
    );
  }

  /// `Sign`
  String get sign {
    return Intl.message(
      'Sign',
      name: 'sign',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Restore purchase`
  String get restore_purchase {
    return Intl.message(
      'Restore purchase',
      name: 'restore_purchase',
      desc: '',
      args: [],
    );
  }

  /// `No Previous Purchase`
  String get no_previous_purchase {
    return Intl.message(
      'No Previous Purchase',
      name: 'no_previous_purchase',
      desc: '',
      args: [],
    );
  }

  /// `Could not find a valid subscription purchase.`
  String get no_valid_subscription {
    return Intl.message(
      'Could not find a valid subscription purchase.',
      name: 'no_valid_subscription',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save location`
  String get save_location {
    return Intl.message(
      'Save location',
      name: 'save_location',
      desc: '',
      args: [],
    );
  }

  /// `This device has no photo in the gallery, so there is no photo that can be tagged.`
  String get device_has_no_pics {
    return Intl.message(
      'This device has no photo in the gallery, so there is no photo that can be tagged.',
      name: 'device_has_no_pics',
      desc: '',
      args: [],
    );
  }

  /// `Open gallery`
  String get open_gallery {
    return Intl.message(
      'Open gallery',
      name: 'open_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Access permissions`
  String get gallery_access_permission {
    return Intl.message(
      'Access permissions',
      name: 'gallery_access_permission',
      desc: '',
      args: [],
    );
  }

  /// `To start organizing your photos, we need authorization to access them`
  String get gallery_access_permission_description {
    return Intl.message(
      'To start organizing your photos, we need authorization to access them',
      name: 'gallery_access_permission_description',
      desc: '',
      args: [],
    );
  }

  /// `Export Library`
  String get export_library {
    return Intl.message(
      'Export Library',
      name: 'export_library',
      desc: '',
      args: [],
    );
  }

  /// `You completed your {number} free daily pics, do you want to continue?`
  String premium_modal_description(Object number) {
    return Intl.message(
      'You completed your $number free daily pics, do you want to continue?',
      name: 'premium_modal_description',
      desc: '',
      args: [number],
    );
  }

  /// `Watch video ad to continue`
  String get premium_modal_watch_ad {
    return Intl.message(
      'Watch video ad to continue',
      name: 'premium_modal_watch_ad',
      desc: '',
      args: [],
    );
  }

  /// `Get Premium Account`
  String get premium_modal_get_premium_title {
    return Intl.message(
      'Get Premium Account',
      name: 'premium_modal_get_premium_title',
      desc: '',
      args: [],
    );
  }

  /// `ALL FEATURES WITHOUT ADS`
  String get premium_modal_get_premium_description {
    return Intl.message(
      'ALL FEATURES WITHOUT ADS',
      name: 'premium_modal_get_premium_description',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get family_tag {
    return Intl.message(
      'Family',
      name: 'family_tag',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get travel_tag {
    return Intl.message(
      'Travel',
      name: 'travel_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pets`
  String get pets_tag {
    return Intl.message(
      'Pets',
      name: 'pets_tag',
      desc: '',
      args: [],
    );
  }

  /// `Selfies`
  String get selfies_tag {
    return Intl.message(
      'Selfies',
      name: 'selfies_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sreenshots`
  String get screenshots_tag {
    return Intl.message(
      'Sreenshots',
      name: 'screenshots_tag',
      desc: '',
      args: [],
    );
  }

  /// `Foods`
  String get foods_tag {
    return Intl.message(
      'Foods',
      name: 'foods_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports_tag {
    return Intl.message(
      'Sports',
      name: 'sports_tag',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home_tag {
    return Intl.message(
      'Home',
      name: 'home_tag',
      desc: '',
      args: [],
    );
  }

  /// `Work`
  String get work_tag {
    return Intl.message(
      'Work',
      name: 'work_tag',
      desc: '',
      args: [],
    );
  }

  /// `Parties`
  String get parties_tag {
    return Intl.message(
      'Parties',
      name: 'parties_tag',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get terms_of_use {
    return Intl.message(
      'Terms of Use',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `The subscription is `
  String get auto_renewable_first_part {
    return Intl.message(
      'The subscription is ',
      name: 'auto_renewable_first_part',
      desc: '',
      args: [],
    );
  }

  /// `auto-renewable.`
  String get auto_renewable_second_part {
    return Intl.message(
      'auto-renewable.',
      name: 'auto_renewable_second_part',
      desc: '',
      args: [],
    );
  }

  /// `Cancel anytime`
  String get cancel_anytime {
    return Intl.message(
      'Cancel anytime',
      name: 'cancel_anytime',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `All Search Tags`
  String get all_search_tags {
    return Intl.message(
      'All Search Tags',
      name: 'all_search_tags',
      desc: '',
      args: [],
    );
  }

  /// `No pictures were found with all tags on it.`
  String get search_all_tags_not_found {
    return Intl.message(
      'No pictures were found with all tags on it.',
      name: 'search_all_tags_not_found',
      desc: '',
      args: [],
    );
  }

  /// `picPics - Photo Manager`
  String get picpics_photo_manager {
    return Intl.message(
      'picPics - Photo Manager',
      name: 'picpics_photo_manager',
      desc: '',
      args: [],
    );
  }

  /// `Adicione múltiplas tags`
  String get add_multiple_tags {
    return Intl.message(
      'Adicione múltiplas tags',
      name: 'add_multiple_tags',
      desc: '',
      args: [],
    );
  }

  /// `NY`
  String get ny_tag {
    return Intl.message(
      'NY',
      name: 'ny_tag',
      desc: '',
      args: [],
    );
  }

  /// `Times Square`
  String get tsqr_tag {
    return Intl.message(
      'Times Square',
      name: 'tsqr_tag',
      desc: '',
      args: [],
    );
  }

  /// `Vacation`
  String get vacation_tag {
    return Intl.message(
      'Vacation',
      name: 'vacation_tag',
      desc: '',
      args: [],
    );
  }

  /// `Organize multiple photos at once`
  String get all_at_once {
    return Intl.message(
      'Organize multiple photos at once',
      name: 'all_at_once',
      desc: '',
      args: [],
    );
  }

  /// `Easily find your photos`
  String get find_easily {
    return Intl.message(
      'Easily find your photos',
      name: 'find_easily',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Secret Photos`
  String get secret_photos {
    return Intl.message(
      'Secret Photos',
      name: 'secret_photos',
      desc: '',
      args: [],
    );
  }

  /// `Your secret key`
  String get your_secret_key {
    return Intl.message(
      'Your secret key',
      name: 'your_secret_key',
      desc: '',
      args: [],
    );
  }

  /// `New secret key`
  String get new_secret_key {
    return Intl.message(
      'New secret key',
      name: 'new_secret_key',
      desc: '',
      args: [],
    );
  }

  /// `Confirm secret key`
  String get confirm_secret_key {
    return Intl.message(
      'Confirm secret key',
      name: 'confirm_secret_key',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your registration email to receive your access code`
  String get confirm_email {
    return Intl.message(
      'Confirm your registration email to receive your access code',
      name: 'confirm_email',
      desc: '',
      args: [],
    );
  }

  /// `Access code`
  String get access_code {
    return Intl.message(
      'Access code',
      name: 'access_code',
      desc: '',
      args: [],
    );
  }

  /// `An access key was sent to user@email.com`
  String get access_code_sent {
    return Intl.message(
      'An access key was sent to user@email.com',
      name: 'access_code_sent',
      desc: '',
      args: [],
    );
  }

  /// `Secret key successfully created!`
  String get secret_key_created {
    return Intl.message(
      'Secret key successfully created!',
      name: 'secret_key_created',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to unhide this photo?`
  String get disable_secret {
    return Intl.message(
      'Do you want to unhide this photo?',
      name: 'disable_secret',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Your photo is now safe on picPics. Do you want to delete it from your camera roll?`
  String get keep_safe {
    return Intl.message(
      'Your photo is now safe on picPics. Do you want to delete it from your camera roll?',
      name: 'keep_safe',
      desc: '',
      args: [],
    );
  }

  /// `Keep asking`
  String get keep_asking {
    return Intl.message(
      'Keep asking',
      name: 'keep_asking',
      desc: '',
      args: [],
    );
  }

  /// `Don't ask again`
  String get dont_ask_again {
    return Intl.message(
      'Don\'t ask again',
      name: 'dont_ask_again',
      desc: '',
      args: [],
    );
  }

  /// `To view your hidden photos, release the lock in the application settings. You can unlock them with your PIN.`
  String get view_hidden_photos {
    return Intl.message(
      'To view your hidden photos, release the lock in the application settings. You can unlock them with your PIN.',
      name: 'view_hidden_photos',
      desc: '',
      args: [],
    );
  }

  /// `Require secret key`
  String get require_secret_key {
    return Intl.message(
      'Require secret key',
      name: 'require_secret_key',
      desc: '',
      args: [],
    );
  }

  /// `Always`
  String get always {
    return Intl.message(
      'Always',
      name: 'always',
      desc: '',
      args: [],
    );
  }

  /// `20 min`
  String get x_minutes {
    return Intl.message(
      '20 min',
      name: 'x_minutes',
      desc: '',
      args: [],
    );
  }

  /// `Forgot secret key?`
  String get forgot_secret_key {
    return Intl.message(
      'Forgot secret key?',
      name: 'forgot_secret_key',
      desc: '',
      args: [],
    );
  }

  /// `Lock your photos`
  String get lock_your_photos {
    return Intl.message(
      'Lock your photos',
      name: 'lock_your_photos',
      desc: '',
      args: [],
    );
  }

  /// `Lock down your private photos with a PIN passcode.`
  String get lock_with_pin {
    return Intl.message(
      'Lock down your private photos with a PIN passcode.',
      name: 'lock_with_pin',
      desc: '',
      args: [],
    );
  }

  /// `Protect your personal photos with encryption only accessible with a PIN password.`
  String get protect_with_encryption {
    return Intl.message(
      'Protect your personal photos with encryption only accessible with a PIN password.',
      name: 'protect_with_encryption',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja', countryCode: 'JP'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'nl'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'sv', countryCode: 'SE'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
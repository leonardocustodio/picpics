// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
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

  /// `Screenshots`
  String get screenshots_tag {
    return Intl.message(
      'Screenshots',
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

  /// `An access key was sent to {email}`
  String access_code_sent(Object email) {
    return Intl.message(
      'An access key was sent to $email',
      name: 'access_code_sent',
      desc: '',
      args: [email],
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

  /// `There are no more photos to organize.`
  String get all_photos_were_tagged {
    return Intl.message(
      'There are no more photos to organize.',
      name: 'all_photos_were_tagged',
      desc: '',
      args: [],
    );
  }

  /// `Daily challenge`
  String get daily_notification_title {
    return Intl.message(
      'Daily challenge',
      name: 'daily_notification_title',
      desc: '',
      args: [],
    );
  }

  /// `It's time to complete your picPics daily challenge!`
  String get daily_notification_description {
    return Intl.message(
      'It\'s time to complete your picPics daily challenge!',
      name: 'daily_notification_description',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited private photos`
  String get unlimited_private_pics {
    return Intl.message(
      'Unlimited private photos',
      name: 'unlimited_private_pics',
      desc: '',
      args: [],
    );
  }

  /// `Team`
  String get team_tag {
    return Intl.message(
      'Team',
      name: 'team_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bonfire`
  String get bonfire_tag {
    return Intl.message(
      'Bonfire',
      name: 'bonfire_tag',
      desc: '',
      args: [],
    );
  }

  /// `Comics`
  String get comics_tag {
    return Intl.message(
      'Comics',
      name: 'comics_tag',
      desc: '',
      args: [],
    );
  }

  /// `Himalayan`
  String get himalayan_tag {
    return Intl.message(
      'Himalayan',
      name: 'himalayan_tag',
      desc: '',
      args: [],
    );
  }

  /// `Iceberg`
  String get iceberg_tag {
    return Intl.message(
      'Iceberg',
      name: 'iceberg_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bento`
  String get bento_tag {
    return Intl.message(
      'Bento',
      name: 'bento_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sink`
  String get sink_tag {
    return Intl.message(
      'Sink',
      name: 'sink_tag',
      desc: '',
      args: [],
    );
  }

  /// `Toy`
  String get toy_tag {
    return Intl.message(
      'Toy',
      name: 'toy_tag',
      desc: '',
      args: [],
    );
  }

  /// `Statue`
  String get statue_tag {
    return Intl.message(
      'Statue',
      name: 'statue_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cheeseburger`
  String get cheeseburger_tag {
    return Intl.message(
      'Cheeseburger',
      name: 'cheeseburger_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tractor`
  String get tractor_tag {
    return Intl.message(
      'Tractor',
      name: 'tractor_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sled`
  String get sled_tag {
    return Intl.message(
      'Sled',
      name: 'sled_tag',
      desc: '',
      args: [],
    );
  }

  /// `Aquarium`
  String get aquarium_tag {
    return Intl.message(
      'Aquarium',
      name: 'aquarium_tag',
      desc: '',
      args: [],
    );
  }

  /// `Circus`
  String get circus_tag {
    return Intl.message(
      'Circus',
      name: 'circus_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sitting`
  String get sitting_tag {
    return Intl.message(
      'Sitting',
      name: 'sitting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Beard`
  String get beard_tag {
    return Intl.message(
      'Beard',
      name: 'beard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bridge`
  String get bridge_tag {
    return Intl.message(
      'Bridge',
      name: 'bridge_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tights`
  String get tights_tag {
    return Intl.message(
      'Tights',
      name: 'tights_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bird`
  String get bird_tag {
    return Intl.message(
      'Bird',
      name: 'bird_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rafting`
  String get rafting_tag {
    return Intl.message(
      'Rafting',
      name: 'rafting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Park`
  String get park_tag {
    return Intl.message(
      'Park',
      name: 'park_tag',
      desc: '',
      args: [],
    );
  }

  /// `Factory`
  String get factory_tag {
    return Intl.message(
      'Factory',
      name: 'factory_tag',
      desc: '',
      args: [],
    );
  }

  /// `Graduation`
  String get graduation_tag {
    return Intl.message(
      'Graduation',
      name: 'graduation_tag',
      desc: '',
      args: [],
    );
  }

  /// `Porcelain`
  String get porcelain_tag {
    return Intl.message(
      'Porcelain',
      name: 'porcelain_tag',
      desc: '',
      args: [],
    );
  }

  /// `Twig`
  String get twig_tag {
    return Intl.message(
      'Twig',
      name: 'twig_tag',
      desc: '',
      args: [],
    );
  }

  /// `Petal`
  String get petal_tag {
    return Intl.message(
      'Petal',
      name: 'petal_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cushion`
  String get cushion_tag {
    return Intl.message(
      'Cushion',
      name: 'cushion_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sunglasses`
  String get sunglasses_tag {
    return Intl.message(
      'Sunglasses',
      name: 'sunglasses_tag',
      desc: '',
      args: [],
    );
  }

  /// `Infrastructure`
  String get infrastructure_tag {
    return Intl.message(
      'Infrastructure',
      name: 'infrastructure_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ferris wheel`
  String get ferris_wheel_tag {
    return Intl.message(
      'Ferris wheel',
      name: 'ferris_wheel_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pomacentridae`
  String get pomacentridae_tag {
    return Intl.message(
      'Pomacentridae',
      name: 'pomacentridae_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wetsuit`
  String get wetsuit_tag {
    return Intl.message(
      'Wetsuit',
      name: 'wetsuit_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shetland sheepdog`
  String get shetland_sheepdog_tag {
    return Intl.message(
      'Shetland sheepdog',
      name: 'shetland_sheepdog_tag',
      desc: '',
      args: [],
    );
  }

  /// `Brig`
  String get brig_tag {
    return Intl.message(
      'Brig',
      name: 'brig_tag',
      desc: '',
      args: [],
    );
  }

  /// `Watercolor paint`
  String get watercolor_paint_tag {
    return Intl.message(
      'Watercolor paint',
      name: 'watercolor_paint_tag',
      desc: '',
      args: [],
    );
  }

  /// `Competition`
  String get competition_tag {
    return Intl.message(
      'Competition',
      name: 'competition_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cliff`
  String get cliff_tag {
    return Intl.message(
      'Cliff',
      name: 'cliff_tag',
      desc: '',
      args: [],
    );
  }

  /// `Badminton`
  String get badminton_tag {
    return Intl.message(
      'Badminton',
      name: 'badminton_tag',
      desc: '',
      args: [],
    );
  }

  /// `Safari`
  String get safari_tag {
    return Intl.message(
      'Safari',
      name: 'safari_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bicycle`
  String get bicycle_tag {
    return Intl.message(
      'Bicycle',
      name: 'bicycle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Stadium`
  String get stadium_tag {
    return Intl.message(
      'Stadium',
      name: 'stadium_tag',
      desc: '',
      args: [],
    );
  }

  /// `Boat`
  String get boat_tag {
    return Intl.message(
      'Boat',
      name: 'boat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Smile`
  String get smile_tag {
    return Intl.message(
      'Smile',
      name: 'smile_tag',
      desc: '',
      args: [],
    );
  }

  /// `Surfboard`
  String get surfboard_tag {
    return Intl.message(
      'Surfboard',
      name: 'surfboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fast food`
  String get fast_food_tag {
    return Intl.message(
      'Fast food',
      name: 'fast_food_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sunset`
  String get sunset_tag {
    return Intl.message(
      'Sunset',
      name: 'sunset_tag',
      desc: '',
      args: [],
    );
  }

  /// `Hot dog`
  String get hot_dog_tag {
    return Intl.message(
      'Hot dog',
      name: 'hot_dog_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shorts`
  String get shorts_tag {
    return Intl.message(
      'Shorts',
      name: 'shorts_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bus`
  String get bus_tag {
    return Intl.message(
      'Bus',
      name: 'bus_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bullfighting`
  String get bullfighting_tag {
    return Intl.message(
      'Bullfighting',
      name: 'bullfighting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sky`
  String get sky_tag {
    return Intl.message(
      'Sky',
      name: 'sky_tag',
      desc: '',
      args: [],
    );
  }

  /// `Gerbil`
  String get gerbil_tag {
    return Intl.message(
      'Gerbil',
      name: 'gerbil_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rock`
  String get rock_tag {
    return Intl.message(
      'Rock',
      name: 'rock_tag',
      desc: '',
      args: [],
    );
  }

  /// `Interaction`
  String get interaction_tag {
    return Intl.message(
      'Interaction',
      name: 'interaction_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dress`
  String get dress_tag {
    return Intl.message(
      'Dress',
      name: 'dress_tag',
      desc: '',
      args: [],
    );
  }

  /// `Toe`
  String get toe_tag {
    return Intl.message(
      'Toe',
      name: 'toe_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bear`
  String get bear_tag {
    return Intl.message(
      'Bear',
      name: 'bear_tag',
      desc: '',
      args: [],
    );
  }

  /// `Eating`
  String get eating_tag {
    return Intl.message(
      'Eating',
      name: 'eating_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tower`
  String get tower_tag {
    return Intl.message(
      'Tower',
      name: 'tower_tag',
      desc: '',
      args: [],
    );
  }

  /// `Brick`
  String get brick_tag {
    return Intl.message(
      'Brick',
      name: 'brick_tag',
      desc: '',
      args: [],
    );
  }

  /// `Junk`
  String get junk_tag {
    return Intl.message(
      'Junk',
      name: 'junk_tag',
      desc: '',
      args: [],
    );
  }

  /// `Person`
  String get person_tag {
    return Intl.message(
      'Person',
      name: 'person_tag',
      desc: '',
      args: [],
    );
  }

  /// `Windsurfing`
  String get windsurfing_tag {
    return Intl.message(
      'Windsurfing',
      name: 'windsurfing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Swimwear`
  String get swimwear_tag {
    return Intl.message(
      'Swimwear',
      name: 'swimwear_tag',
      desc: '',
      args: [],
    );
  }

  /// `Roller`
  String get roller_tag {
    return Intl.message(
      'Roller',
      name: 'roller_tag',
      desc: '',
      args: [],
    );
  }

  /// `Camping`
  String get camping_tag {
    return Intl.message(
      'Camping',
      name: 'camping_tag',
      desc: '',
      args: [],
    );
  }

  /// `Playground`
  String get playground_tag {
    return Intl.message(
      'Playground',
      name: 'playground_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get bathroom_tag {
    return Intl.message(
      'Bathroom',
      name: 'bathroom_tag',
      desc: '',
      args: [],
    );
  }

  /// `Laugh`
  String get laugh_tag {
    return Intl.message(
      'Laugh',
      name: 'laugh_tag',
      desc: '',
      args: [],
    );
  }

  /// `Balloon`
  String get balloon_tag {
    return Intl.message(
      'Balloon',
      name: 'balloon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Concert`
  String get concert_tag {
    return Intl.message(
      'Concert',
      name: 'concert_tag',
      desc: '',
      args: [],
    );
  }

  /// `Prom`
  String get prom_tag {
    return Intl.message(
      'Prom',
      name: 'prom_tag',
      desc: '',
      args: [],
    );
  }

  /// `Construction`
  String get construction_tag {
    return Intl.message(
      'Construction',
      name: 'construction_tag',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product_tag {
    return Intl.message(
      'Product',
      name: 'product_tag',
      desc: '',
      args: [],
    );
  }

  /// `Reef`
  String get reef_tag {
    return Intl.message(
      'Reef',
      name: 'reef_tag',
      desc: '',
      args: [],
    );
  }

  /// `Picnic`
  String get picnic_tag {
    return Intl.message(
      'Picnic',
      name: 'picnic_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wreath`
  String get wreath_tag {
    return Intl.message(
      'Wreath',
      name: 'wreath_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wheelbarrow`
  String get wheelbarrow_tag {
    return Intl.message(
      'Wheelbarrow',
      name: 'wheelbarrow_tag',
      desc: '',
      args: [],
    );
  }

  /// `Boxer`
  String get boxer_tag {
    return Intl.message(
      'Boxer',
      name: 'boxer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Necklace`
  String get necklace_tag {
    return Intl.message(
      'Necklace',
      name: 'necklace_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bracelet`
  String get bracelet_tag {
    return Intl.message(
      'Bracelet',
      name: 'bracelet_tag',
      desc: '',
      args: [],
    );
  }

  /// `Casino`
  String get casino_tag {
    return Intl.message(
      'Casino',
      name: 'casino_tag',
      desc: '',
      args: [],
    );
  }

  /// `Windshield`
  String get windshield_tag {
    return Intl.message(
      'Windshield',
      name: 'windshield_tag',
      desc: '',
      args: [],
    );
  }

  /// `Stairs`
  String get stairs_tag {
    return Intl.message(
      'Stairs',
      name: 'stairs_tag',
      desc: '',
      args: [],
    );
  }

  /// `Computer`
  String get computer_tag {
    return Intl.message(
      'Computer',
      name: 'computer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cookware and bakeware`
  String get cookware_and_bakeware_tag {
    return Intl.message(
      'Cookware and bakeware',
      name: 'cookware_and_bakeware_tag',
      desc: '',
      args: [],
    );
  }

  /// `Monochrome`
  String get monochrome_tag {
    return Intl.message(
      'Monochrome',
      name: 'monochrome_tag',
      desc: '',
      args: [],
    );
  }

  /// `Chair`
  String get chair_tag {
    return Intl.message(
      'Chair',
      name: 'chair_tag',
      desc: '',
      args: [],
    );
  }

  /// `Poster`
  String get poster_tag {
    return Intl.message(
      'Poster',
      name: 'poster_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bar`
  String get bar_tag {
    return Intl.message(
      'Bar',
      name: 'bar_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shipwreck`
  String get shipwreck_tag {
    return Intl.message(
      'Shipwreck',
      name: 'shipwreck_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pier`
  String get pier_tag {
    return Intl.message(
      'Pier',
      name: 'pier_tag',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get community_tag {
    return Intl.message(
      'Community',
      name: 'community_tag',
      desc: '',
      args: [],
    );
  }

  /// `Caving`
  String get caving_tag {
    return Intl.message(
      'Caving',
      name: 'caving_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cave`
  String get cave_tag {
    return Intl.message(
      'Cave',
      name: 'cave_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tie`
  String get tie_tag {
    return Intl.message(
      'Tie',
      name: 'tie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cabinetry`
  String get cabinetry_tag {
    return Intl.message(
      'Cabinetry',
      name: 'cabinetry_tag',
      desc: '',
      args: [],
    );
  }

  /// `Underwater`
  String get underwater_tag {
    return Intl.message(
      'Underwater',
      name: 'underwater_tag',
      desc: '',
      args: [],
    );
  }

  /// `Clown`
  String get clown_tag {
    return Intl.message(
      'Clown',
      name: 'clown_tag',
      desc: '',
      args: [],
    );
  }

  /// `Nightclub`
  String get nightclub_tag {
    return Intl.message(
      'Nightclub',
      name: 'nightclub_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cycling`
  String get cycling_tag {
    return Intl.message(
      'Cycling',
      name: 'cycling_tag',
      desc: '',
      args: [],
    );
  }

  /// `Comet`
  String get comet_tag {
    return Intl.message(
      'Comet',
      name: 'comet_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mortarboard`
  String get mortarboard_tag {
    return Intl.message(
      'Mortarboard',
      name: 'mortarboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Track`
  String get track_tag {
    return Intl.message(
      'Track',
      name: 'track_tag',
      desc: '',
      args: [],
    );
  }

  /// `Christmas`
  String get christmas_tag {
    return Intl.message(
      'Christmas',
      name: 'christmas_tag',
      desc: '',
      args: [],
    );
  }

  /// `Church`
  String get church_tag {
    return Intl.message(
      'Church',
      name: 'church_tag',
      desc: '',
      args: [],
    );
  }

  /// `Clock`
  String get clock_tag {
    return Intl.message(
      'Clock',
      name: 'clock_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dude`
  String get dude_tag {
    return Intl.message(
      'Dude',
      name: 'dude_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cattle`
  String get cattle_tag {
    return Intl.message(
      'Cattle',
      name: 'cattle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Jungle`
  String get jungle_tag {
    return Intl.message(
      'Jungle',
      name: 'jungle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Desk`
  String get desk_tag {
    return Intl.message(
      'Desk',
      name: 'desk_tag',
      desc: '',
      args: [],
    );
  }

  /// `Curling`
  String get curling_tag {
    return Intl.message(
      'Curling',
      name: 'curling_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cuisine`
  String get cuisine_tag {
    return Intl.message(
      'Cuisine',
      name: 'cuisine_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cat`
  String get cat_tag {
    return Intl.message(
      'Cat',
      name: 'cat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Juice`
  String get juice_tag {
    return Intl.message(
      'Juice',
      name: 'juice_tag',
      desc: '',
      args: [],
    );
  }

  /// `Couscous`
  String get couscous_tag {
    return Intl.message(
      'Couscous',
      name: 'couscous_tag',
      desc: '',
      args: [],
    );
  }

  /// `Screenshot`
  String get screenshot_tag {
    return Intl.message(
      'Screenshot',
      name: 'screenshot_tag',
      desc: '',
      args: [],
    );
  }

  /// `Crew`
  String get crew_tag {
    return Intl.message(
      'Crew',
      name: 'crew_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skyline`
  String get skyline_tag {
    return Intl.message(
      'Skyline',
      name: 'skyline_tag',
      desc: '',
      args: [],
    );
  }

  /// `Stuffed toy`
  String get stuffed_toy_tag {
    return Intl.message(
      'Stuffed toy',
      name: 'stuffed_toy_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cookie`
  String get cookie_tag {
    return Intl.message(
      'Cookie',
      name: 'cookie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tile`
  String get tile_tag {
    return Intl.message(
      'Tile',
      name: 'tile_tag',
      desc: '',
      args: [],
    );
  }

  /// `Hanukkah`
  String get hanukkah_tag {
    return Intl.message(
      'Hanukkah',
      name: 'hanukkah_tag',
      desc: '',
      args: [],
    );
  }

  /// `Crochet`
  String get crochet_tag {
    return Intl.message(
      'Crochet',
      name: 'crochet_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skateboarder`
  String get skateboarder_tag {
    return Intl.message(
      'Skateboarder',
      name: 'skateboarder_tag',
      desc: '',
      args: [],
    );
  }

  /// `Clipper`
  String get clipper_tag {
    return Intl.message(
      'Clipper',
      name: 'clipper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Nail`
  String get nail_tag {
    return Intl.message(
      'Nail',
      name: 'nail_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cola`
  String get cola_tag {
    return Intl.message(
      'Cola',
      name: 'cola_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cutlery`
  String get cutlery_tag {
    return Intl.message(
      'Cutlery',
      name: 'cutlery_tag',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu_tag {
    return Intl.message(
      'Menu',
      name: 'menu_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sari`
  String get sari_tag {
    return Intl.message(
      'Sari',
      name: 'sari_tag',
      desc: '',
      args: [],
    );
  }

  /// `Plush`
  String get plush_tag {
    return Intl.message(
      'Plush',
      name: 'plush_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pocket`
  String get pocket_tag {
    return Intl.message(
      'Pocket',
      name: 'pocket_tag',
      desc: '',
      args: [],
    );
  }

  /// `Neon`
  String get neon_tag {
    return Intl.message(
      'Neon',
      name: 'neon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Icicle`
  String get icicle_tag {
    return Intl.message(
      'Icicle',
      name: 'icicle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pasteles`
  String get pasteles_tag {
    return Intl.message(
      'Pasteles',
      name: 'pasteles_tag',
      desc: '',
      args: [],
    );
  }

  /// `Chain`
  String get chain_tag {
    return Intl.message(
      'Chain',
      name: 'chain_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dance`
  String get dance_tag {
    return Intl.message(
      'Dance',
      name: 'dance_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dune`
  String get dune_tag {
    return Intl.message(
      'Dune',
      name: 'dune_tag',
      desc: '',
      args: [],
    );
  }

  /// `Santa claus`
  String get santa_claus_tag {
    return Intl.message(
      'Santa claus',
      name: 'santa_claus_tag',
      desc: '',
      args: [],
    );
  }

  /// `Thanksgiving`
  String get thanksgiving_tag {
    return Intl.message(
      'Thanksgiving',
      name: 'thanksgiving_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tuxedo`
  String get tuxedo_tag {
    return Intl.message(
      'Tuxedo',
      name: 'tuxedo_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mouth`
  String get mouth_tag {
    return Intl.message(
      'Mouth',
      name: 'mouth_tag',
      desc: '',
      args: [],
    );
  }

  /// `Desert`
  String get desert_tag {
    return Intl.message(
      'Desert',
      name: 'desert_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dinosaur`
  String get dinosaur_tag {
    return Intl.message(
      'Dinosaur',
      name: 'dinosaur_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mufti`
  String get mufti_tag {
    return Intl.message(
      'Mufti',
      name: 'mufti_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fire`
  String get fire_tag {
    return Intl.message(
      'Fire',
      name: 'fire_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get bedroom_tag {
    return Intl.message(
      'Bedroom',
      name: 'bedroom_tag',
      desc: '',
      args: [],
    );
  }

  /// `Goggles`
  String get goggles_tag {
    return Intl.message(
      'Goggles',
      name: 'goggles_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dragon`
  String get dragon_tag {
    return Intl.message(
      'Dragon',
      name: 'dragon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Couch`
  String get couch_tag {
    return Intl.message(
      'Couch',
      name: 'couch_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sledding`
  String get sledding_tag {
    return Intl.message(
      'Sledding',
      name: 'sledding_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cap`
  String get cap_tag {
    return Intl.message(
      'Cap',
      name: 'cap_tag',
      desc: '',
      args: [],
    );
  }

  /// `Whiteboard`
  String get whiteboard_tag {
    return Intl.message(
      'Whiteboard',
      name: 'whiteboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Hat`
  String get hat_tag {
    return Intl.message(
      'Hat',
      name: 'hat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Gelato`
  String get gelato_tag {
    return Intl.message(
      'Gelato',
      name: 'gelato_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cavalier`
  String get cavalier_tag {
    return Intl.message(
      'Cavalier',
      name: 'cavalier_tag',
      desc: '',
      args: [],
    );
  }

  /// `Beanie`
  String get beanie_tag {
    return Intl.message(
      'Beanie',
      name: 'beanie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Jersey`
  String get jersey_tag {
    return Intl.message(
      'Jersey',
      name: 'jersey_tag',
      desc: '',
      args: [],
    );
  }

  /// `Scarf`
  String get scarf_tag {
    return Intl.message(
      'Scarf',
      name: 'scarf_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pitch`
  String get pitch_tag {
    return Intl.message(
      'Pitch',
      name: 'pitch_tag',
      desc: '',
      args: [],
    );
  }

  /// `Blackboard`
  String get blackboard_tag {
    return Intl.message(
      'Blackboard',
      name: 'blackboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Deejay`
  String get deejay_tag {
    return Intl.message(
      'Deejay',
      name: 'deejay_tag',
      desc: '',
      args: [],
    );
  }

  /// `Monument`
  String get monument_tag {
    return Intl.message(
      'Monument',
      name: 'monument_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bumper`
  String get bumper_tag {
    return Intl.message(
      'Bumper',
      name: 'bumper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Longboard`
  String get longboard_tag {
    return Intl.message(
      'Longboard',
      name: 'longboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Waterfowl`
  String get waterfowl_tag {
    return Intl.message(
      'Waterfowl',
      name: 'waterfowl_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flesh`
  String get flesh_tag {
    return Intl.message(
      'Flesh',
      name: 'flesh_tag',
      desc: '',
      args: [],
    );
  }

  /// `Net`
  String get net_tag {
    return Intl.message(
      'Net',
      name: 'net_tag',
      desc: '',
      args: [],
    );
  }

  /// `Icing`
  String get icing_tag {
    return Intl.message(
      'Icing',
      name: 'icing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dalmatian`
  String get dalmatian_tag {
    return Intl.message(
      'Dalmatian',
      name: 'dalmatian_tag',
      desc: '',
      args: [],
    );
  }

  /// `Speedboat`
  String get speedboat_tag {
    return Intl.message(
      'Speedboat',
      name: 'speedboat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Trunk`
  String get trunk_tag {
    return Intl.message(
      'Trunk',
      name: 'trunk_tag',
      desc: '',
      args: [],
    );
  }

  /// `Coffee`
  String get coffee_tag {
    return Intl.message(
      'Coffee',
      name: 'coffee_tag',
      desc: '',
      args: [],
    );
  }

  /// `Soccer`
  String get soccer_tag {
    return Intl.message(
      'Soccer',
      name: 'soccer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ragdoll`
  String get ragdoll_tag {
    return Intl.message(
      'Ragdoll',
      name: 'ragdoll_tag',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get food_tag {
    return Intl.message(
      'Food',
      name: 'food_tag',
      desc: '',
      args: [],
    );
  }

  /// `Standing`
  String get standing_tag {
    return Intl.message(
      'Standing',
      name: 'standing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fiction`
  String get fiction_tag {
    return Intl.message(
      'Fiction',
      name: 'fiction_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fruit`
  String get fruit_tag {
    return Intl.message(
      'Fruit',
      name: 'fruit_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pho`
  String get pho_tag {
    return Intl.message(
      'Pho',
      name: 'pho_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sparkler`
  String get sparkler_tag {
    return Intl.message(
      'Sparkler',
      name: 'sparkler_tag',
      desc: '',
      args: [],
    );
  }

  /// `Presentation`
  String get presentation_tag {
    return Intl.message(
      'Presentation',
      name: 'presentation_tag',
      desc: '',
      args: [],
    );
  }

  /// `Swing`
  String get swing_tag {
    return Intl.message(
      'Swing',
      name: 'swing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cairn terrier`
  String get cairn_terrier_tag {
    return Intl.message(
      'Cairn terrier',
      name: 'cairn_terrier_tag',
      desc: '',
      args: [],
    );
  }

  /// `Forest`
  String get forest_tag {
    return Intl.message(
      'Forest',
      name: 'forest_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flag`
  String get flag_tag {
    return Intl.message(
      'Flag',
      name: 'flag_tag',
      desc: '',
      args: [],
    );
  }

  /// `Frigate`
  String get frigate_tag {
    return Intl.message(
      'Frigate',
      name: 'frigate_tag',
      desc: '',
      args: [],
    );
  }

  /// `Foot`
  String get foot_tag {
    return Intl.message(
      'Foot',
      name: 'foot_tag',
      desc: '',
      args: [],
    );
  }

  /// `Jacket`
  String get jacket_tag {
    return Intl.message(
      'Jacket',
      name: 'jacket_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pillow`
  String get pillow_tag {
    return Intl.message(
      'Pillow',
      name: 'pillow_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bathing`
  String get bathing_tag {
    return Intl.message(
      'Bathing',
      name: 'bathing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Glacier`
  String get glacier_tag {
    return Intl.message(
      'Glacier',
      name: 'glacier_tag',
      desc: '',
      args: [],
    );
  }

  /// `Gymnastics`
  String get gymnastics_tag {
    return Intl.message(
      'Gymnastics',
      name: 'gymnastics_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ear`
  String get ear_tag {
    return Intl.message(
      'Ear',
      name: 'ear_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flora`
  String get flora_tag {
    return Intl.message(
      'Flora',
      name: 'flora_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shell`
  String get shell_tag {
    return Intl.message(
      'Shell',
      name: 'shell_tag',
      desc: '',
      args: [],
    );
  }

  /// `Grandparent`
  String get grandparent_tag {
    return Intl.message(
      'Grandparent',
      name: 'grandparent_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ruins`
  String get ruins_tag {
    return Intl.message(
      'Ruins',
      name: 'ruins_tag',
      desc: '',
      args: [],
    );
  }

  /// `Eyelash`
  String get eyelash_tag {
    return Intl.message(
      'Eyelash',
      name: 'eyelash_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bunk bed`
  String get bunk_bed_tag {
    return Intl.message(
      'Bunk bed',
      name: 'bunk_bed_tag',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance_tag {
    return Intl.message(
      'Balance',
      name: 'balance_tag',
      desc: '',
      args: [],
    );
  }

  /// `Backpacking`
  String get backpacking_tag {
    return Intl.message(
      'Backpacking',
      name: 'backpacking_tag',
      desc: '',
      args: [],
    );
  }

  /// `Horse`
  String get horse_tag {
    return Intl.message(
      'Horse',
      name: 'horse_tag',
      desc: '',
      args: [],
    );
  }

  /// `Glitter`
  String get glitter_tag {
    return Intl.message(
      'Glitter',
      name: 'glitter_tag',
      desc: '',
      args: [],
    );
  }

  /// `Saucer`
  String get saucer_tag {
    return Intl.message(
      'Saucer',
      name: 'saucer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Hair`
  String get hair_tag {
    return Intl.message(
      'Hair',
      name: 'hair_tag',
      desc: '',
      args: [],
    );
  }

  /// `Miniature`
  String get miniature_tag {
    return Intl.message(
      'Miniature',
      name: 'miniature_tag',
      desc: '',
      args: [],
    );
  }

  /// `Crowd`
  String get crowd_tag {
    return Intl.message(
      'Crowd',
      name: 'crowd_tag',
      desc: '',
      args: [],
    );
  }

  /// `Curtain`
  String get curtain_tag {
    return Intl.message(
      'Curtain',
      name: 'curtain_tag',
      desc: '',
      args: [],
    );
  }

  /// `Icon`
  String get icon_tag {
    return Intl.message(
      'Icon',
      name: 'icon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pixie-bob`
  String get pixie_bob_tag {
    return Intl.message(
      'Pixie-bob',
      name: 'pixie_bob_tag',
      desc: '',
      args: [],
    );
  }

  /// `Herd`
  String get herd_tag {
    return Intl.message(
      'Herd',
      name: 'herd_tag',
      desc: '',
      args: [],
    );
  }

  /// `Insect`
  String get insect_tag {
    return Intl.message(
      'Insect',
      name: 'insect_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ice`
  String get ice_tag {
    return Intl.message(
      'Ice',
      name: 'ice_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bangle`
  String get bangle_tag {
    return Intl.message(
      'Bangle',
      name: 'bangle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flap`
  String get flap_tag {
    return Intl.message(
      'Flap',
      name: 'flap_tag',
      desc: '',
      args: [],
    );
  }

  /// `Jewellery`
  String get jewellery_tag {
    return Intl.message(
      'Jewellery',
      name: 'jewellery_tag',
      desc: '',
      args: [],
    );
  }

  /// `Knitting`
  String get knitting_tag {
    return Intl.message(
      'Knitting',
      name: 'knitting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Centrepiece`
  String get centrepiece_tag {
    return Intl.message(
      'Centrepiece',
      name: 'centrepiece_tag',
      desc: '',
      args: [],
    );
  }

  /// `Outerwear`
  String get outerwear_tag {
    return Intl.message(
      'Outerwear',
      name: 'outerwear_tag',
      desc: '',
      args: [],
    );
  }

  /// `Love`
  String get love_tag {
    return Intl.message(
      'Love',
      name: 'love_tag',
      desc: '',
      args: [],
    );
  }

  /// `Muscle`
  String get muscle_tag {
    return Intl.message(
      'Muscle',
      name: 'muscle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Motorcycle`
  String get motorcycle_tag {
    return Intl.message(
      'Motorcycle',
      name: 'motorcycle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Money`
  String get money_tag {
    return Intl.message(
      'Money',
      name: 'money_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mosque`
  String get mosque_tag {
    return Intl.message(
      'Mosque',
      name: 'mosque_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tableware`
  String get tableware_tag {
    return Intl.message(
      'Tableware',
      name: 'tableware_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ballroom`
  String get ballroom_tag {
    return Intl.message(
      'Ballroom',
      name: 'ballroom_tag',
      desc: '',
      args: [],
    );
  }

  /// `Kayak`
  String get kayak_tag {
    return Intl.message(
      'Kayak',
      name: 'kayak_tag',
      desc: '',
      args: [],
    );
  }

  /// `Leisure`
  String get leisure_tag {
    return Intl.message(
      'Leisure',
      name: 'leisure_tag',
      desc: '',
      args: [],
    );
  }

  /// `Receipt`
  String get receipt_tag {
    return Intl.message(
      'Receipt',
      name: 'receipt_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lake`
  String get lake_tag {
    return Intl.message(
      'Lake',
      name: 'lake_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lighthouse`
  String get lighthouse_tag {
    return Intl.message(
      'Lighthouse',
      name: 'lighthouse_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bridle`
  String get bridle_tag {
    return Intl.message(
      'Bridle',
      name: 'bridle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Leather`
  String get leather_tag {
    return Intl.message(
      'Leather',
      name: 'leather_tag',
      desc: '',
      args: [],
    );
  }

  /// `Horn`
  String get horn_tag {
    return Intl.message(
      'Horn',
      name: 'horn_tag',
      desc: '',
      args: [],
    );
  }

  /// `Strap`
  String get strap_tag {
    return Intl.message(
      'Strap',
      name: 'strap_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lego`
  String get lego_tag {
    return Intl.message(
      'Lego',
      name: 'lego_tag',
      desc: '',
      args: [],
    );
  }

  /// `Scuba diving`
  String get scuba_diving_tag {
    return Intl.message(
      'Scuba diving',
      name: 'scuba_diving_tag',
      desc: '',
      args: [],
    );
  }

  /// `Leggings`
  String get leggings_tag {
    return Intl.message(
      'Leggings',
      name: 'leggings_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pool`
  String get pool_tag {
    return Intl.message(
      'Pool',
      name: 'pool_tag',
      desc: '',
      args: [],
    );
  }

  /// `Musical instrument`
  String get musical_instrument_tag {
    return Intl.message(
      'Musical instrument',
      name: 'musical_instrument_tag',
      desc: '',
      args: [],
    );
  }

  /// `Musical`
  String get musical_tag {
    return Intl.message(
      'Musical',
      name: 'musical_tag',
      desc: '',
      args: [],
    );
  }

  /// `Metal`
  String get metal_tag {
    return Intl.message(
      'Metal',
      name: 'metal_tag',
      desc: '',
      args: [],
    );
  }

  /// `Moon`
  String get moon_tag {
    return Intl.message(
      'Moon',
      name: 'moon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Blazer`
  String get blazer_tag {
    return Intl.message(
      'Blazer',
      name: 'blazer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Marriage`
  String get marriage_tag {
    return Intl.message(
      'Marriage',
      name: 'marriage_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mobile phone`
  String get mobile_phone_tag {
    return Intl.message(
      'Mobile phone',
      name: 'mobile_phone_tag',
      desc: '',
      args: [],
    );
  }

  /// `Militia`
  String get militia_tag {
    return Intl.message(
      'Militia',
      name: 'militia_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tablecloth`
  String get tablecloth_tag {
    return Intl.message(
      'Tablecloth',
      name: 'tablecloth_tag',
      desc: '',
      args: [],
    );
  }

  /// `Party`
  String get party_tag {
    return Intl.message(
      'Party',
      name: 'party_tag',
      desc: '',
      args: [],
    );
  }

  /// `Nebula`
  String get nebula_tag {
    return Intl.message(
      'Nebula',
      name: 'nebula_tag',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get news_tag {
    return Intl.message(
      'News',
      name: 'news_tag',
      desc: '',
      args: [],
    );
  }

  /// `Newspaper`
  String get newspaper_tag {
    return Intl.message(
      'Newspaper',
      name: 'newspaper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Piano`
  String get piano_tag {
    return Intl.message(
      'Piano',
      name: 'piano_tag',
      desc: '',
      args: [],
    );
  }

  /// `Plant`
  String get plant_tag {
    return Intl.message(
      'Plant',
      name: 'plant_tag',
      desc: '',
      args: [],
    );
  }

  /// `Passport`
  String get passport_tag {
    return Intl.message(
      'Passport',
      name: 'passport_tag',
      desc: '',
      args: [],
    );
  }

  /// `Penguin`
  String get penguin_tag {
    return Intl.message(
      'Penguin',
      name: 'penguin_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shikoku`
  String get shikoku_tag {
    return Intl.message(
      'Shikoku',
      name: 'shikoku_tag',
      desc: '',
      args: [],
    );
  }

  /// `Palace`
  String get palace_tag {
    return Intl.message(
      'Palace',
      name: 'palace_tag',
      desc: '',
      args: [],
    );
  }

  /// `Doily`
  String get doily_tag {
    return Intl.message(
      'Doily',
      name: 'doily_tag',
      desc: '',
      args: [],
    );
  }

  /// `Polo`
  String get polo_tag {
    return Intl.message(
      'Polo',
      name: 'polo_tag',
      desc: '',
      args: [],
    );
  }

  /// `Paper`
  String get paper_tag {
    return Intl.message(
      'Paper',
      name: 'paper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pop music`
  String get pop_music_tag {
    return Intl.message(
      'Pop music',
      name: 'pop_music_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skiff`
  String get skiff_tag {
    return Intl.message(
      'Skiff',
      name: 'skiff_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pizza`
  String get pizza_tag {
    return Intl.message(
      'Pizza',
      name: 'pizza_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pet`
  String get pet_tag {
    return Intl.message(
      'Pet',
      name: 'pet_tag',
      desc: '',
      args: [],
    );
  }

  /// `Quilting`
  String get quilting_tag {
    return Intl.message(
      'Quilting',
      name: 'quilting_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cage`
  String get cage_tag {
    return Intl.message(
      'Cage',
      name: 'cage_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skateboard`
  String get skateboard_tag {
    return Intl.message(
      'Skateboard',
      name: 'skateboard_tag',
      desc: '',
      args: [],
    );
  }

  /// `Surfing`
  String get surfing_tag {
    return Intl.message(
      'Surfing',
      name: 'surfing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rugby`
  String get rugby_tag {
    return Intl.message(
      'Rugby',
      name: 'rugby_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lipstick`
  String get lipstick_tag {
    return Intl.message(
      'Lipstick',
      name: 'lipstick_tag',
      desc: '',
      args: [],
    );
  }

  /// `River`
  String get river_tag {
    return Intl.message(
      'River',
      name: 'river_tag',
      desc: '',
      args: [],
    );
  }

  /// `Race`
  String get race_tag {
    return Intl.message(
      'Race',
      name: 'race_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rowing`
  String get rowing_tag {
    return Intl.message(
      'Rowing',
      name: 'rowing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Road`
  String get road_tag {
    return Intl.message(
      'Road',
      name: 'road_tag',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get running_tag {
    return Intl.message(
      'Running',
      name: 'running_tag',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get room_tag {
    return Intl.message(
      'Room',
      name: 'room_tag',
      desc: '',
      args: [],
    );
  }

  /// `Roof`
  String get roof_tag {
    return Intl.message(
      'Roof',
      name: 'roof_tag',
      desc: '',
      args: [],
    );
  }

  /// `Star`
  String get star_tag {
    return Intl.message(
      'Star',
      name: 'star_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shoe`
  String get shoe_tag {
    return Intl.message(
      'Shoe',
      name: 'shoe_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tubing`
  String get tubing_tag {
    return Intl.message(
      'Tubing',
      name: 'tubing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Space`
  String get space_tag {
    return Intl.message(
      'Space',
      name: 'space_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sleep`
  String get sleep_tag {
    return Intl.message(
      'Sleep',
      name: 'sleep_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skin`
  String get skin_tag {
    return Intl.message(
      'Skin',
      name: 'skin_tag',
      desc: '',
      args: [],
    );
  }

  /// `Swimming`
  String get swimming_tag {
    return Intl.message(
      'Swimming',
      name: 'swimming_tag',
      desc: '',
      args: [],
    );
  }

  /// `School`
  String get school_tag {
    return Intl.message(
      'School',
      name: 'school_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sushi`
  String get sushi_tag {
    return Intl.message(
      'Sushi',
      name: 'sushi_tag',
      desc: '',
      args: [],
    );
  }

  /// `Loveseat`
  String get loveseat_tag {
    return Intl.message(
      'Loveseat',
      name: 'loveseat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Superman`
  String get superman_tag {
    return Intl.message(
      'Superman',
      name: 'superman_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cool`
  String get cool_tag {
    return Intl.message(
      'Cool',
      name: 'cool_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skiing`
  String get skiing_tag {
    return Intl.message(
      'Skiing',
      name: 'skiing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Submarine`
  String get submarine_tag {
    return Intl.message(
      'Submarine',
      name: 'submarine_tag',
      desc: '',
      args: [],
    );
  }

  /// `Song`
  String get song_tag {
    return Intl.message(
      'Song',
      name: 'song_tag',
      desc: '',
      args: [],
    );
  }

  /// `Class`
  String get class_tag {
    return Intl.message(
      'Class',
      name: 'class_tag',
      desc: '',
      args: [],
    );
  }

  /// `Skyscraper`
  String get skyscraper_tag {
    return Intl.message(
      'Skyscraper',
      name: 'skyscraper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Volcano`
  String get volcano_tag {
    return Intl.message(
      'Volcano',
      name: 'volcano_tag',
      desc: '',
      args: [],
    );
  }

  /// `Television`
  String get television_tag {
    return Intl.message(
      'Television',
      name: 'television_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rein`
  String get rein_tag {
    return Intl.message(
      'Rein',
      name: 'rein_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tattoo`
  String get tattoo_tag {
    return Intl.message(
      'Tattoo',
      name: 'tattoo_tag',
      desc: '',
      args: [],
    );
  }

  /// `Train`
  String get train_tag {
    return Intl.message(
      'Train',
      name: 'train_tag',
      desc: '',
      args: [],
    );
  }

  /// `Handrail`
  String get handrail_tag {
    return Intl.message(
      'Handrail',
      name: 'handrail_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cup`
  String get cup_tag {
    return Intl.message(
      'Cup',
      name: 'cup_tag',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle`
  String get vehicle_tag {
    return Intl.message(
      'Vehicle',
      name: 'vehicle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Handbag`
  String get handbag_tag {
    return Intl.message(
      'Handbag',
      name: 'handbag_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lampshade`
  String get lampshade_tag {
    return Intl.message(
      'Lampshade',
      name: 'lampshade_tag',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event_tag {
    return Intl.message(
      'Event',
      name: 'event_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wine`
  String get wine_tag {
    return Intl.message(
      'Wine',
      name: 'wine_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wing`
  String get wing_tag {
    return Intl.message(
      'Wing',
      name: 'wing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wheel`
  String get wheel_tag {
    return Intl.message(
      'Wheel',
      name: 'wheel_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wakeboarding`
  String get wakeboarding_tag {
    return Intl.message(
      'Wakeboarding',
      name: 'wakeboarding_tag',
      desc: '',
      args: [],
    );
  }

  /// `Web page`
  String get web_page_tag {
    return Intl.message(
      'Web page',
      name: 'web_page_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ranch`
  String get ranch_tag {
    return Intl.message(
      'Ranch',
      name: 'ranch_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fishing`
  String get fishing_tag {
    return Intl.message(
      'Fishing',
      name: 'fishing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Heart`
  String get heart_tag {
    return Intl.message(
      'Heart',
      name: 'heart_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cotton`
  String get cotton_tag {
    return Intl.message(
      'Cotton',
      name: 'cotton_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cappuccino`
  String get cappuccino_tag {
    return Intl.message(
      'Cappuccino',
      name: 'cappuccino_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bread`
  String get bread_tag {
    return Intl.message(
      'Bread',
      name: 'bread_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sand`
  String get sand_tag {
    return Intl.message(
      'Sand',
      name: 'sand_tag',
      desc: '',
      args: [],
    );
  }

  /// `Museum`
  String get museum_tag {
    return Intl.message(
      'Museum',
      name: 'museum_tag',
      desc: '',
      args: [],
    );
  }

  /// `Helicopter`
  String get helicopter_tag {
    return Intl.message(
      'Helicopter',
      name: 'helicopter_tag',
      desc: '',
      args: [],
    );
  }

  /// `Mountain`
  String get mountain_tag {
    return Intl.message(
      'Mountain',
      name: 'mountain_tag',
      desc: '',
      args: [],
    );
  }

  /// `Duck`
  String get duck_tag {
    return Intl.message(
      'Duck',
      name: 'duck_tag',
      desc: '',
      args: [],
    );
  }

  /// `Soil`
  String get soil_tag {
    return Intl.message(
      'Soil',
      name: 'soil_tag',
      desc: '',
      args: [],
    );
  }

  /// `Turtle`
  String get turtle_tag {
    return Intl.message(
      'Turtle',
      name: 'turtle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Crocodile`
  String get crocodile_tag {
    return Intl.message(
      'Crocodile',
      name: 'crocodile_tag',
      desc: '',
      args: [],
    );
  }

  /// `Musician`
  String get musician_tag {
    return Intl.message(
      'Musician',
      name: 'musician_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sneakers`
  String get sneakers_tag {
    return Intl.message(
      'Sneakers',
      name: 'sneakers_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wool`
  String get wool_tag {
    return Intl.message(
      'Wool',
      name: 'wool_tag',
      desc: '',
      args: [],
    );
  }

  /// `Ring`
  String get ring_tag {
    return Intl.message(
      'Ring',
      name: 'ring_tag',
      desc: '',
      args: [],
    );
  }

  /// `Singer`
  String get singer_tag {
    return Intl.message(
      'Singer',
      name: 'singer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Carnival`
  String get carnival_tag {
    return Intl.message(
      'Carnival',
      name: 'carnival_tag',
      desc: '',
      args: [],
    );
  }

  /// `Snowboarding`
  String get snowboarding_tag {
    return Intl.message(
      'Snowboarding',
      name: 'snowboarding_tag',
      desc: '',
      args: [],
    );
  }

  /// `Waterskiing`
  String get waterskiing_tag {
    return Intl.message(
      'Waterskiing',
      name: 'waterskiing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Wall`
  String get wall_tag {
    return Intl.message(
      'Wall',
      name: 'wall_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rocket`
  String get rocket_tag {
    return Intl.message(
      'Rocket',
      name: 'rocket_tag',
      desc: '',
      args: [],
    );
  }

  /// `Countertop`
  String get countertop_tag {
    return Intl.message(
      'Countertop',
      name: 'countertop_tag',
      desc: '',
      args: [],
    );
  }

  /// `Beach`
  String get beach_tag {
    return Intl.message(
      'Beach',
      name: 'beach_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rainbow`
  String get rainbow_tag {
    return Intl.message(
      'Rainbow',
      name: 'rainbow_tag',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get branch_tag {
    return Intl.message(
      'Branch',
      name: 'branch_tag',
      desc: '',
      args: [],
    );
  }

  /// `Moustache`
  String get moustache_tag {
    return Intl.message(
      'Moustache',
      name: 'moustache_tag',
      desc: '',
      args: [],
    );
  }

  /// `Garden`
  String get garden_tag {
    return Intl.message(
      'Garden',
      name: 'garden_tag',
      desc: '',
      args: [],
    );
  }

  /// `Gown`
  String get gown_tag {
    return Intl.message(
      'Gown',
      name: 'gown_tag',
      desc: '',
      args: [],
    );
  }

  /// `Field`
  String get field_tag {
    return Intl.message(
      'Field',
      name: 'field_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dog`
  String get dog_tag {
    return Intl.message(
      'Dog',
      name: 'dog_tag',
      desc: '',
      args: [],
    );
  }

  /// `Superhero`
  String get superhero_tag {
    return Intl.message(
      'Superhero',
      name: 'superhero_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flower`
  String get flower_tag {
    return Intl.message(
      'Flower',
      name: 'flower_tag',
      desc: '',
      args: [],
    );
  }

  /// `Placemat`
  String get placemat_tag {
    return Intl.message(
      'Placemat',
      name: 'placemat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Subwoofer`
  String get subwoofer_tag {
    return Intl.message(
      'Subwoofer',
      name: 'subwoofer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cathedral`
  String get cathedral_tag {
    return Intl.message(
      'Cathedral',
      name: 'cathedral_tag',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get building_tag {
    return Intl.message(
      'Building',
      name: 'building_tag',
      desc: '',
      args: [],
    );
  }

  /// `Airplane`
  String get airplane_tag {
    return Intl.message(
      'Airplane',
      name: 'airplane_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fur`
  String get fur_tag {
    return Intl.message(
      'Fur',
      name: 'fur_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bull`
  String get bull_tag {
    return Intl.message(
      'Bull',
      name: 'bull_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bench`
  String get bench_tag {
    return Intl.message(
      'Bench',
      name: 'bench_tag',
      desc: '',
      args: [],
    );
  }

  /// `Temple`
  String get temple_tag {
    return Intl.message(
      'Temple',
      name: 'temple_tag',
      desc: '',
      args: [],
    );
  }

  /// `Butterfly`
  String get butterfly_tag {
    return Intl.message(
      'Butterfly',
      name: 'butterfly_tag',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get model_tag {
    return Intl.message(
      'Model',
      name: 'model_tag',
      desc: '',
      args: [],
    );
  }

  /// `Marathon`
  String get marathon_tag {
    return Intl.message(
      'Marathon',
      name: 'marathon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Needlework`
  String get needlework_tag {
    return Intl.message(
      'Needlework',
      name: 'needlework_tag',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get kitchen_tag {
    return Intl.message(
      'Kitchen',
      name: 'kitchen_tag',
      desc: '',
      args: [],
    );
  }

  /// `Castle`
  String get castle_tag {
    return Intl.message(
      'Castle',
      name: 'castle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Aurora`
  String get aurora_tag {
    return Intl.message(
      'Aurora',
      name: 'aurora_tag',
      desc: '',
      args: [],
    );
  }

  /// `Larva`
  String get larva_tag {
    return Intl.message(
      'Larva',
      name: 'larva_tag',
      desc: '',
      args: [],
    );
  }

  /// `Racing`
  String get racing_tag {
    return Intl.message(
      'Racing',
      name: 'racing_tag',
      desc: '',
      args: [],
    );
  }

  /// `Airliner`
  String get airliner_tag {
    return Intl.message(
      'Airliner',
      name: 'airliner_tag',
      desc: '',
      args: [],
    );
  }

  /// `Dam`
  String get dam_tag {
    return Intl.message(
      'Dam',
      name: 'dam_tag',
      desc: '',
      args: [],
    );
  }

  /// `Textile`
  String get textile_tag {
    return Intl.message(
      'Textile',
      name: 'textile_tag',
      desc: '',
      args: [],
    );
  }

  /// `Groom`
  String get groom_tag {
    return Intl.message(
      'Groom',
      name: 'groom_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fun`
  String get fun_tag {
    return Intl.message(
      'Fun',
      name: 'fun_tag',
      desc: '',
      args: [],
    );
  }

  /// `Steaming`
  String get steaming_tag {
    return Intl.message(
      'Steaming',
      name: 'steaming_tag',
      desc: '',
      args: [],
    );
  }

  /// `Vegetable`
  String get vegetable_tag {
    return Intl.message(
      'Vegetable',
      name: 'vegetable_tag',
      desc: '',
      args: [],
    );
  }

  /// `Unicycle`
  String get unicycle_tag {
    return Intl.message(
      'Unicycle',
      name: 'unicycle_tag',
      desc: '',
      args: [],
    );
  }

  /// `Jeans`
  String get jeans_tag {
    return Intl.message(
      'Jeans',
      name: 'jeans_tag',
      desc: '',
      args: [],
    );
  }

  /// `Flowerpot`
  String get flowerpot_tag {
    return Intl.message(
      'Flowerpot',
      name: 'flowerpot_tag',
      desc: '',
      args: [],
    );
  }

  /// `Drawer`
  String get drawer_tag {
    return Intl.message(
      'Drawer',
      name: 'drawer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Cake`
  String get cake_tag {
    return Intl.message(
      'Cake',
      name: 'cake_tag',
      desc: '',
      args: [],
    );
  }

  /// `Armrest`
  String get armrest_tag {
    return Intl.message(
      'Armrest',
      name: 'armrest_tag',
      desc: '',
      args: [],
    );
  }

  /// `Aviation`
  String get aviation_tag {
    return Intl.message(
      'Aviation',
      name: 'aviation_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fog`
  String get fog_tag {
    return Intl.message(
      'Fog',
      name: 'fog_tag',
      desc: '',
      args: [],
    );
  }

  /// `Fireworks`
  String get fireworks_tag {
    return Intl.message(
      'Fireworks',
      name: 'fireworks_tag',
      desc: '',
      args: [],
    );
  }

  /// `Farm`
  String get farm_tag {
    return Intl.message(
      'Farm',
      name: 'farm_tag',
      desc: '',
      args: [],
    );
  }

  /// `Seal`
  String get seal_tag {
    return Intl.message(
      'Seal',
      name: 'seal_tag',
      desc: '',
      args: [],
    );
  }

  /// `Shelf`
  String get shelf_tag {
    return Intl.message(
      'Shelf',
      name: 'shelf_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bangs`
  String get bangs_tag {
    return Intl.message(
      'Bangs',
      name: 'bangs_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lightning`
  String get lightning_tag {
    return Intl.message(
      'Lightning',
      name: 'lightning_tag',
      desc: '',
      args: [],
    );
  }

  /// `Van`
  String get van_tag {
    return Intl.message(
      'Van',
      name: 'van_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sphynx`
  String get sphynx_tag {
    return Intl.message(
      'Sphynx',
      name: 'sphynx_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tire`
  String get tire_tag {
    return Intl.message(
      'Tire',
      name: 'tire_tag',
      desc: '',
      args: [],
    );
  }

  /// `Denim`
  String get denim_tag {
    return Intl.message(
      'Denim',
      name: 'denim_tag',
      desc: '',
      args: [],
    );
  }

  /// `Prairie`
  String get prairie_tag {
    return Intl.message(
      'Prairie',
      name: 'prairie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Snorkeling`
  String get snorkeling_tag {
    return Intl.message(
      'Snorkeling',
      name: 'snorkeling_tag',
      desc: '',
      args: [],
    );
  }

  /// `Umbrella`
  String get umbrella_tag {
    return Intl.message(
      'Umbrella',
      name: 'umbrella_tag',
      desc: '',
      args: [],
    );
  }

  /// `Asphalt`
  String get asphalt_tag {
    return Intl.message(
      'Asphalt',
      name: 'asphalt_tag',
      desc: '',
      args: [],
    );
  }

  /// `Sailboat`
  String get sailboat_tag {
    return Intl.message(
      'Sailboat',
      name: 'sailboat_tag',
      desc: '',
      args: [],
    );
  }

  /// `Basset hound`
  String get basset_hound_tag {
    return Intl.message(
      'Basset hound',
      name: 'basset_hound_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pattern`
  String get pattern_tag {
    return Intl.message(
      'Pattern',
      name: 'pattern_tag',
      desc: '',
      args: [],
    );
  }

  /// `Supper`
  String get supper_tag {
    return Intl.message(
      'Supper',
      name: 'supper_tag',
      desc: '',
      args: [],
    );
  }

  /// `Veil`
  String get veil_tag {
    return Intl.message(
      'Veil',
      name: 'veil_tag',
      desc: '',
      args: [],
    );
  }

  /// `Waterfall`
  String get waterfall_tag {
    return Intl.message(
      'Waterfall',
      name: 'waterfall_tag',
      desc: '',
      args: [],
    );
  }

  /// `Lunch`
  String get lunch_tag {
    return Intl.message(
      'Lunch',
      name: 'lunch_tag',
      desc: '',
      args: [],
    );
  }

  /// `Odometer`
  String get odometer_tag {
    return Intl.message(
      'Odometer',
      name: 'odometer_tag',
      desc: '',
      args: [],
    );
  }

  /// `Baby`
  String get baby_tag {
    return Intl.message(
      'Baby',
      name: 'baby_tag',
      desc: '',
      args: [],
    );
  }

  /// `Glasses`
  String get glasses_tag {
    return Intl.message(
      'Glasses',
      name: 'glasses_tag',
      desc: '',
      args: [],
    );
  }

  /// `Car`
  String get car_tag {
    return Intl.message(
      'Car',
      name: 'car_tag',
      desc: '',
      args: [],
    );
  }

  /// `Aircraft`
  String get aircraft_tag {
    return Intl.message(
      'Aircraft',
      name: 'aircraft_tag',
      desc: '',
      args: [],
    );
  }

  /// `Hand`
  String get hand_tag {
    return Intl.message(
      'Hand',
      name: 'hand_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rodeo`
  String get rodeo_tag {
    return Intl.message(
      'Rodeo',
      name: 'rodeo_tag',
      desc: '',
      args: [],
    );
  }

  /// `Canyon`
  String get canyon_tag {
    return Intl.message(
      'Canyon',
      name: 'canyon_tag',
      desc: '',
      args: [],
    );
  }

  /// `Meal`
  String get meal_tag {
    return Intl.message(
      'Meal',
      name: 'meal_tag',
      desc: '',
      args: [],
    );
  }

  /// `Softball`
  String get softball_tag {
    return Intl.message(
      'Softball',
      name: 'softball_tag',
      desc: '',
      args: [],
    );
  }

  /// `Alcohol`
  String get alcohol_tag {
    return Intl.message(
      'Alcohol',
      name: 'alcohol_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bride`
  String get bride_tag {
    return Intl.message(
      'Bride',
      name: 'bride_tag',
      desc: '',
      args: [],
    );
  }

  /// `Swamp`
  String get swamp_tag {
    return Intl.message(
      'Swamp',
      name: 'swamp_tag',
      desc: '',
      args: [],
    );
  }

  /// `Pie`
  String get pie_tag {
    return Intl.message(
      'Pie',
      name: 'pie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get bag_tag {
    return Intl.message(
      'Bag',
      name: 'bag_tag',
      desc: '',
      args: [],
    );
  }

  /// `Joker`
  String get joker_tag {
    return Intl.message(
      'Joker',
      name: 'joker_tag',
      desc: '',
      args: [],
    );
  }

  /// `Supervillain`
  String get supervillain_tag {
    return Intl.message(
      'Supervillain',
      name: 'supervillain_tag',
      desc: '',
      args: [],
    );
  }

  /// `Army`
  String get army_tag {
    return Intl.message(
      'Army',
      name: 'army_tag',
      desc: '',
      args: [],
    );
  }

  /// `Canoe`
  String get canoe_tag {
    return Intl.message(
      'Canoe',
      name: 'canoe_tag',
      desc: '',
      args: [],
    );
  }

  /// `Selfie`
  String get selfie_tag {
    return Intl.message(
      'Selfie',
      name: 'selfie_tag',
      desc: '',
      args: [],
    );
  }

  /// `Rickshaw`
  String get rickshaw_tag {
    return Intl.message(
      'Rickshaw',
      name: 'rickshaw_tag',
      desc: '',
      args: [],
    );
  }

  /// `Barn`
  String get barn_tag {
    return Intl.message(
      'Barn',
      name: 'barn_tag',
      desc: '',
      args: [],
    );
  }

  /// `Archery`
  String get archery_tag {
    return Intl.message(
      'Archery',
      name: 'archery_tag',
      desc: '',
      args: [],
    );
  }

  /// `Aerospace engineering`
  String get aerospace_engineering_tag {
    return Intl.message(
      'Aerospace engineering',
      name: 'aerospace_engineering_tag',
      desc: '',
      args: [],
    );
  }

  /// `Storm`
  String get storm_tag {
    return Intl.message(
      'Storm',
      name: 'storm_tag',
      desc: '',
      args: [],
    );
  }

  /// `Helmet`
  String get helmet_tag {
    return Intl.message(
      'Helmet',
      name: 'helmet_tag',
      desc: '',
      args: [],
    );
  }

  /// `Months`
  String get toggle_months {
    return Intl.message(
      'Months',
      name: 'toggle_months',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get toggle_days {
    return Intl.message(
      'Days',
      name: 'toggle_days',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get toggle_date {
    return Intl.message(
      'Date',
      name: 'toggle_date',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get toggle_tags {
    return Intl.message(
      'Tags',
      name: 'toggle_tags',
      desc: '',
      args: [],
    );
  }

  /// `Feedback & bug report`
  String get feedback_bug_report {
    return Intl.message(
      'Feedback & bug report',
      name: 'feedback_bug_report',
      desc: '',
      args: [],
    );
  }

  /// `Private Photos`
  String get private_photos {
    return Intl.message(
      'Private Photos',
      name: 'private_photos',
      desc: '',
      args: [],
    );
  }

  /// `Recent Tags`
  String get recent_tags {
    return Intl.message(
      'Recent Tags',
      name: 'recent_tags',
      desc: '',
      args: [],
    );
  }

  /// `We need access to your photo library so you can start organizing your photos with picPics. Don't worry your data will never leave your device!`
  String get ask_photo_library_permission {
    return Intl.message(
      'We need access to your photo library so you can start organizing your photos with picPics. Don\'t worry your data will never leave your device!',
      name: 'ask_photo_library_permission',
      desc: '',
      args: [],
    );
  }

  /// `You can "tap & hold" on your photos to tag multiple photos at once.`
  String get tutorial_multiselect {
    return Intl.message(
      'You can "tap & hold" on your photos to tag multiple photos at once.',
      name: 'tutorial_multiselect',
      desc: '',
      args: [],
    );
  }

  /// `Hide your private photos with a pin code protection, keeping them safe.`
  String get tutorial_secret {
    return Intl.message(
      'Hide your private photos with a pin code protection, keeping them safe.',
      name: 'tutorial_secret',
      desc: '',
      args: [],
    );
  }

  /// `Enable Face ID`
  String get enable_faceid {
    return Intl.message(
      'Enable Face ID',
      name: 'enable_faceid',
      desc: '',
      args: [],
    );
  }

  /// `Enable Touch ID`
  String get enable_touchid {
    return Intl.message(
      'Enable Touch ID',
      name: 'enable_touchid',
      desc: '',
      args: [],
    );
  }

  /// `Enable Fingerprint`
  String get enable_fingerprint {
    return Intl.message(
      'Enable Fingerprint',
      name: 'enable_fingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Enable Iris Scanner`
  String get enable_irisscanner {
    return Intl.message(
      'Enable Iris Scanner',
      name: 'enable_irisscanner',
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

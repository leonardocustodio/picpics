// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "You completed your ${number} free daily pics, do you want to continue?";

  static m2(url) => "To organize all your photos go to ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Access code"),
    "access_code_sent" : MessageLookupByLibrary.simpleMessage("An access key was sent to user@email.com"),
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Adicione múltiplas tags"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Add tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Add tags"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organize multiple photos at once"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("All Search Tags"),
    "always" : MessageLookupByLibrary.simpleMessage("Always"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("The subscription is "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-renewable."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Cancel anytime"),
    "close" : MessageLookupByLibrary.simpleMessage("Close"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Confirm your registration email to receive your access code"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Confirm secret key"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continue"),
    "country" : MessageLookupByLibrary.simpleMessage("country"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("For us to be able to send your daily challenges we need authorization to send notifications, so, it is necessary that you authorize the notifications in the options of your cell phone"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Daily goal"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("Está na hora de completar o seu desáfio. Entre no picPics para completá-lo!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Desafio diário"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("This device has no photo in the gallery, so there is no photo that can be tagged."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Do you want to unhide this photo?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Don\'t ask again"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Export all gallery"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Export Library"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Family"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Easily find your photos"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Foods"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Forgot secret key?"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Full Screen"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Access permissions"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("To start organizing your photos, we need authorization to access them"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("To organize your photos we need access to your photo gallery"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("TO HAVE ALL THESE FEATURES"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Get premium now!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("GET PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Home"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("How many pics"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Infinite tags"),
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Keep asking"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Your photo is now safe on picPics. Do you want to delete it from your camera roll?"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Lock down your private photos with a PIN passcode."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Lock your photos"),
    "month" : MessageLookupByLibrary.simpleMessage("month"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("New secret key"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("No Ads"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("No Previous Purchase"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("You don\'t have any tagged photos yet"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("No tags found"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Could not find a valid subscription purchase."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Notification time"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Open gallery"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Photos that have already been tagged"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Organized Photos"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Parties"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Pets"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Photos not yet organized"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Photo Gallery"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Photo location"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Now your photos will be always organized"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - Photo Manager"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ALL FEATURES WITHOUT ADS"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Get Premium Account"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Watch video ad to continue"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Protect your personal photos with encryption only accessible with a PIN password."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Rate this app"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Require secret key"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restore purchase"),
    "save" : MessageLookupByLibrary.simpleMessage("save"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Save location"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Screenshots"),
    "search" : MessageLookupByLibrary.simpleMessage("Search..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("No pictures were found with all tags on it."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Search results"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Secret key successfully created!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Secret Photos"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Share with friends"),
    "sign" : MessageLookupByLibrary.simpleMessage("Sign"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sports"),
    "start" : MessageLookupByLibrary.simpleMessage("Start"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Start tagging"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Suggestions"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Tag multiple photos at once"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Take a look at this app!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Terms of Use"),
    "time" : MessageLookupByLibrary.simpleMessage("Time"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Travel"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("We bring a daily package for you to gradually organize your library."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organize your photos by adding tags, like \"family\", \"pets\", or whatever you want."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("After adding the tags to your photo, just swipe to go to the next one."),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Vacation"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("To view your hidden photos, release the lock in the application settings. You can unlock them with your PIN."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Welcome!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Work"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 min"),
    "year" : MessageLookupByLibrary.simpleMessage("year"),
    "yes" : MessageLookupByLibrary.simpleMessage("Yes"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("You are premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Your secret key")
  };
}

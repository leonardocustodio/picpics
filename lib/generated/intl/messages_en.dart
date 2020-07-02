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
    "add_tag" : MessageLookupByLibrary.simpleMessage("Add tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Add tags"),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("All Search Tags"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("The subscription is "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-renewable."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Cancel anytime"),
    "close" : MessageLookupByLibrary.simpleMessage("Close"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continue"),
    "country" : MessageLookupByLibrary.simpleMessage("country"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("For us to be able to send your daily challenges we need authorization to send notifications, so, it is necessary that you authorize the notifications in the options of your cell phone"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Daily goal"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("This device has no photo in the gallery, so there is no photo that can be tagged."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Export all gallery"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Export Library"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Family"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Foods"),
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
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "month" : MessageLookupByLibrary.simpleMessage("month"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("No Ads"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("No Previous Purchase"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("You don\'t have any tagged photos yet"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("No tags found"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Could not find a valid subscription purchase."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Notification time"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
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
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ALL FEATURES WITHOUT ADS"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Get Premium Account"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Watch video ad to continue"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Rate this app"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restore purchase"),
    "save" : MessageLookupByLibrary.simpleMessage("save"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Save location"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Sreenshots"),
    "search" : MessageLookupByLibrary.simpleMessage("Search..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("No pictures were found with all tags on it."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Search results"),
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
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("We bring a daily package for you to gradually organize your library."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organize your photos by adding tags, like \"family\", \"pets\", or whatever you want."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("After adding the tags to your photo, just swipe to go to the next one."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Welcome!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Work"),
    "year" : MessageLookupByLibrary.simpleMessage("year"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("You are premium!")
  };
}

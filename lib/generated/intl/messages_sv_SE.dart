// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a sv_SE locale. All the
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
  String get localeName => 'sv_SE';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "Du har slutfört dina ${number} gratis dagliga bilder, vill du fortsätta?";

  static m2(url) => "För att organisera alla dina foton går du till ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Lägg till tagg"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Lägg till taggar"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Prenumerationen är "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-förnybar."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Avbryt"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Avbryt när som helst"),
    "close" : MessageLookupByLibrary.simpleMessage("Stäng"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Fortsätt"),
    "country" : MessageLookupByLibrary.simpleMessage("land"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Daglig utmaning"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("För att vi ska kunna skicka dina dagliga utmaningar behöver vi behörighet för att skicka aviseringar, vilket innebär att du måste godkänna aviseringar i din mobiltelefons inställningar"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Dagligt mål"),
    "delete" : MessageLookupByLibrary.simpleMessage("Radera"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Den här enheten har inga foton i galleriet, så det finns inga foton som kan taggas."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Redigera tagg"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exportera hela galleriet"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportera bibliotek"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Familj"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Mat"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Helskärm"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Åtkomstbehörigheter"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("För att börja organisera dina foton behöver vi behörighet för att komma åt dem"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("För att organisera dina bilder behöver vi tillgång till ditt fotogalleri"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("FÖR ATT HA ALLA FUNKTIONERNA"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Få premium nu!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("FÅ PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Hem"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Hur många bilder"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Oändliga taggar"),
    "month" : MessageLookupByLibrary.simpleMessage("månad"),
    "next" : MessageLookupByLibrary.simpleMessage("Nästa"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Inga annonser"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Inga tidigare köp"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Du har inga taggade foton än"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Inga taggar hittades"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Det gick inte att hitta ett giltigt prenumerationsköp."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Aviseringstid"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Aviseringar"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Öppna galleriet"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Foton som redan har taggats"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Organiserade foton"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Fester"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Husdjur"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Foton ännu inte organiserade"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Fotogalleri"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Fotoplats"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Nu är dina foton alltid organiserade"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ALLA FUNKTIONER UTAN ANNONSER"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Skaffa premiumkonto"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Se videoannonsen för att fortsätta"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Integritetspolicy"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Betygsätt appen"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Återställ köp"),
    "save" : MessageLookupByLibrary.simpleMessage("spara"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Spara plats"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Skärmdumpar"),
    "search" : MessageLookupByLibrary.simpleMessage("Sök..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Sökresultat"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Inställningar"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Dela med vänner"),
    "sign" : MessageLookupByLibrary.simpleMessage("Tecken"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sport"),
    "start" : MessageLookupByLibrary.simpleMessage("Starta"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Börja tagga"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Förslag"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Tagga flera foton samtidigt"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Ta en titt på appen!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Användarvillkor"),
    "time" : MessageLookupByLibrary.simpleMessage("Tid"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Resa"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Vi ger dig ett dagligt paket för att successivt organisera ditt bibliotek."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organisera dina foton genom att lägga till taggar, som \"familj\", \"husdjur\" eller vad du vill."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Efter du har lagt till taggar på ditt foto, sveper du för att gå vidare till nästa."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Välkommen!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Arbete"),
    "year" : MessageLookupByLibrary.simpleMessage("år"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Du har premium!")
  };
}

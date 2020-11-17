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

  static m0(email) => "En åtkomstnyckel skickades till ${email}";

  static m1(howMany) => "${Intl.plural(howMany, zero: 'Inga foton har valts', one: '1 foto valt', other: '${howMany} foton valda')}";

  static m2(number) => "Du har slutfört dina ${number} gratis dagliga bilder, vill du fortsätta?";

  static m3(url) => "För att organisera alla dina foton går du till ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Åtkomstkod"),
    "access_code_sent" : m0,
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Lägg till flera taggar"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Lägg till tagg"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Lägg till taggar"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organisera flera bilder samtidigt"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Alla söktaggar"),
    "always" : MessageLookupByLibrary.simpleMessage("Alltid"),
    "ask_photo_library_permission" : MessageLookupByLibrary.simpleMessage("Vi behöver åtkomst till ditt fotobibliotek så att du kan börja organisera dina foton med picPics. Oroa dig inte, dina data kommer aldrig att lämna din enhet!"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Prenumerationen är "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-förnybar."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Avbryt"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Avbryt när som helst"),
    "close" : MessageLookupByLibrary.simpleMessage("Stäng"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Bekräfta din registrerings-e-post för att få din åtkomstkod"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Bekräfta hemlig nyckel"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Fortsätt"),
    "country" : MessageLookupByLibrary.simpleMessage("land"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Daglig utmaning"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("För att vi ska kunna skicka dina dagliga utmaningar behöver vi behörighet för att skicka aviseringar, vilket innebär att du måste godkänna aviseringar i din mobiltelefons inställningar"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Dagligt mål"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("Radera"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Den här enheten har inga foton i galleriet, så det finns inga foton som kan taggas."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Vill du visa detta foto?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Fråga inte igen"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Redigera tagg"),
    "email" : MessageLookupByLibrary.simpleMessage("E-post"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exportera hela galleriet"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportera bibliotek"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Familj"),
    "feedback_bug_report" : MessageLookupByLibrary.simpleMessage("Feedback och fel"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Hitta enkelt dina foton"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Mat"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Har du glömt din hemliga nyckel?"),
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
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Fortsätt attfråga"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Ditt foto är nu säkert på picPics. Vill du ta bort det från din kamerarulle?"),
    "language" : MessageLookupByLibrary.simpleMessage("Språk"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Lås dina privata foton med enPIN-kod."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Lås dina foton"),
    "month" : MessageLookupByLibrary.simpleMessage("månad"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Ny hemlig nyckel"),
    "next" : MessageLookupByLibrary.simpleMessage("Nästa"),
    "no" : MessageLookupByLibrary.simpleMessage("Nej"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Inga annonser"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Inga tidigare köp"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Du har inga taggade foton än"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Inga taggar hittades"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Det gick inte att hitta ett giltigt prenumerationsköp."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Aviseringstid"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Aviseringar"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Öppna galleriet"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Foton som redan har taggats"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Organiserade foton"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Fester"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Husdjur"),
    "photo_gallery_count" : m1,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Foton ännu inte organiserade"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Fotogalleri"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Fotoplats"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Nu är dina foton alltid organiserade"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - Photo Manager"),
    "premium_modal_description" : m2,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ALLA FUNKTIONER UTAN ANNONSER"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Skaffa premiumkonto"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Se videoannonsen för att fortsätta"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Integritetspolicy"),
    "private_photos" : MessageLookupByLibrary.simpleMessage("Privata foton"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Skydda dina personliga foton med kryptering, endast tillgängliga med en PIN-kod."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Betygsätt appen"),
    "recent_tags" : MessageLookupByLibrary.simpleMessage("Senaste taggar"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Kräv hemlig nyckel"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Återställ köp"),
    "save" : MessageLookupByLibrary.simpleMessage("spara"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Spara plats"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Skärmdumpar"),
    "search" : MessageLookupByLibrary.simpleMessage("Sök..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Inga bilder hittades med alla taggar på"),
    "search_results" : MessageLookupByLibrary.simpleMessage("Sökresultat"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Hemlig nyckel har skapats!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Hemliga foton"),
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
    "take_a_look_description" : m3,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Användarvillkor"),
    "time" : MessageLookupByLibrary.simpleMessage("Tid"),
    "toggle_date" : MessageLookupByLibrary.simpleMessage("Datum"),
    "toggle_days" : MessageLookupByLibrary.simpleMessage("Dagar"),
    "toggle_months" : MessageLookupByLibrary.simpleMessage("Månader"),
    "toggle_tags" : MessageLookupByLibrary.simpleMessage("Taggar"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Resa"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Vi ger dig ett dagligt paket för att successivt organisera ditt bibliotek."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organisera dina foton genom att lägga till taggar, som \"familj\", \"husdjur\" eller vad du vill."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Efter du har lagt till taggar på ditt foto, sveper du för att gå vidare till nästa."),
    "tutorial_multiselect" : MessageLookupByLibrary.simpleMessage("Du kan trycka och hålla ned på dina foton för att tagga flera foton samtidigt."),
    "tutorial_secret" : MessageLookupByLibrary.simpleMessage("Dölj dina privata foton med ett PIN-kodskydd, för att hålla dem säkra."),
    "unlimited_private_pics" : MessageLookupByLibrary.simpleMessage("Obegränsat med privata foton"),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Semester"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Om du vill se dina dolda foton avaktiverar du låset i programinställningarna. Du kan göra det med din PIN-kod."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Välkommen!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Arbete"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 min"),
    "year" : MessageLookupByLibrary.simpleMessage("år"),
    "yes" : MessageLookupByLibrary.simpleMessage("Ja"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Du har premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Din hemliga nyckel")
  };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'nl';

  static String m0(email) =>
      "Er is een toegangssleutel verzonden naar ${email}";

  static String m1(howMany) => Intl.plural(howMany,
      zero: 'Geen foto\'s geselecteerd',
      one: '1 foto geselecteerd',
      other: '${howMany} foto\'s geselecteerd');

  static String m2(url) => "Ga naar ${url} om al uw foto's te ordenen";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "access_code": MessageLookupByLibrary.simpleMessage("Toegangscode"),
        "access_code_sent": m0,
        "add_multiple_tags":
            MessageLookupByLibrary.simpleMessage("Voeg meerdere tags toe"),
        "add_tag": MessageLookupByLibrary.simpleMessage("Tag toevoegen"),
        "add_tags": MessageLookupByLibrary.simpleMessage("Voeg tags toe"),
        "allTags": MessageLookupByLibrary.simpleMessage("All Tags"),
        "all_at_once": MessageLookupByLibrary.simpleMessage(
            "Orden meerdere foto's tegelijk"),
        "all_search_tags":
            MessageLookupByLibrary.simpleMessage("Alle zoektags"),
        "always": MessageLookupByLibrary.simpleMessage("Altijd"),
        "ask_photo_library_permission": MessageLookupByLibrary.simpleMessage(
            "We hebben toegang nodig tot uw fotobibliotheek zodat u uw foto's kunt gaan organiseren met picPics. Maakt u zich geen zorgen, uw gegevens zullen uw apparaat nooit verlaten!"),
        "auto_renewable_first_part":
            MessageLookupByLibrary.simpleMessage("Het abonnement is "),
        "auto_renewable_second_part":
            MessageLookupByLibrary.simpleMessage("automatisch vernieuwbaar."),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuleren"),
        "cancel_anytime": MessageLookupByLibrary.simpleMessage(
            "U kunt op elk moment annuleren"),
        "close": MessageLookupByLibrary.simpleMessage("Sluiten"),
        "confirm_email": MessageLookupByLibrary.simpleMessage(
            "Bevestig uw registratie-e-mail om uw toegangscode te ontvangen"),
        "confirm_secret_key":
            MessageLookupByLibrary.simpleMessage("Bevestig de geheime sleutel"),
        "continue_string": MessageLookupByLibrary.simpleMessage("Doorgaan met"),
        "country": MessageLookupByLibrary.simpleMessage("land"),
        "daily_challenge":
            MessageLookupByLibrary.simpleMessage("Dagelijkse uitdaging"),
        "daily_challenge_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "Om uw dagelijkse uitdagingen te kunnen verzenden, hebben we toestemming nodig om meldingen te verzenden, dus het is noodzakelijk dat u de meldingen autoriseert in de opties van uw mobiele telefoon"),
        "daily_goal": MessageLookupByLibrary.simpleMessage("Dagelijks doel"),
        "daily_notification_description": MessageLookupByLibrary.simpleMessage(
            "It's time to complete your picPics daily challenge!"),
        "daily_notification_title":
            MessageLookupByLibrary.simpleMessage("Daily challenge"),
        "delete": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "device_has_no_pics": MessageLookupByLibrary.simpleMessage(
            "Dit apparaat heeft geen foto in de galerij, dus er is geen foto die kan worden getagd."),
        "disable_secret": MessageLookupByLibrary.simpleMessage(
            "Wilt u deze foto zichtbaar maken?"),
        "dont_ask_again":
            MessageLookupByLibrary.simpleMessage("Vraag niet opnieuw"),
        "edit_tag": MessageLookupByLibrary.simpleMessage("Label bewerken"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "enable_faceid":
            MessageLookupByLibrary.simpleMessage("Schakel Face ID in"),
        "enable_fingerprint":
            MessageLookupByLibrary.simpleMessage("Vingerafdruk inschakelen"),
        "enable_irisscanner":
            MessageLookupByLibrary.simpleMessage("Schakel Iris Scanner in"),
        "enable_touchid":
            MessageLookupByLibrary.simpleMessage("Schakel Touch ID in"),
        "export_all_gallery":
            MessageLookupByLibrary.simpleMessage("Exporteer alle galerijen"),
        "export_library":
            MessageLookupByLibrary.simpleMessage("Bibliotheek exporteren"),
        "family_tag": MessageLookupByLibrary.simpleMessage("Familie"),
        "feedback_bug_report":
            MessageLookupByLibrary.simpleMessage("Feedback en bugrapport"),
        "find_easily":
            MessageLookupByLibrary.simpleMessage("Vind gemakkelijk uw foto's"),
        "finishing": MessageLookupByLibrary.simpleMessage("Finishing..."),
        "foods_tag": MessageLookupByLibrary.simpleMessage("Eten"),
        "forgot_secret_key":
            MessageLookupByLibrary.simpleMessage("Geheime sleutel vergeten?"),
        "full_screen": MessageLookupByLibrary.simpleMessage("Volledig scherm"),
        "gallery_access_permission":
            MessageLookupByLibrary.simpleMessage("Toegangsrechten"),
        "gallery_access_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "Om te beginnen met het organiseren van uw foto's, hebben we toestemming nodig om ze te openen"),
        "gallery_access_reason": MessageLookupByLibrary.simpleMessage(
            "Om uw foto's te ordenen, hebben we toegang tot uw fotogalerij nodig"),
        "home_tag": MessageLookupByLibrary.simpleMessage("Huis"),
        "how_many_pics": MessageLookupByLibrary.simpleMessage("Hoeveel foto's"),
        "infinite_tags": MessageLookupByLibrary.simpleMessage("Oneindige tags"),
        "keep_asking": MessageLookupByLibrary.simpleMessage("Blijf vragen"),
        "keep_safe": MessageLookupByLibrary.simpleMessage(
            "Je foto is nu veilig op picPics. Wilt u deze van uw filmrol verwijderen?"),
        "language": MessageLookupByLibrary.simpleMessage("Taal"),
        "lock_with_pin": MessageLookupByLibrary.simpleMessage(
            "Vergrendel uw privéfoto's met een pincode."),
        "lock_your_photos":
            MessageLookupByLibrary.simpleMessage("Vergrendel uw foto's"),
        "month": MessageLookupByLibrary.simpleMessage("maand"),
        "new_secret_key":
            MessageLookupByLibrary.simpleMessage("Nieuwe geheime sleutel"),
        "next": MessageLookupByLibrary.simpleMessage("Volgende"),
        "no": MessageLookupByLibrary.simpleMessage("Nee"),
        "no_ads": MessageLookupByLibrary.simpleMessage("Geen Advertenties"),
        "no_photos_were_tagged": MessageLookupByLibrary.simpleMessage(
            "There are no more photos to organize."),
        "no_previous_purchase":
            MessageLookupByLibrary.simpleMessage("Geen eerdere aankoop"),
        "no_tagged_photos": MessageLookupByLibrary.simpleMessage(
            "Je hebt nog geen getagde foto's"),
        "no_tags_found":
            MessageLookupByLibrary.simpleMessage("Geen tags gevonden"),
        "no_valid_subscription": MessageLookupByLibrary.simpleMessage(
            "Kan geen geldige abonnementsaankoop vinden."),
        "notification_time":
            MessageLookupByLibrary.simpleMessage("Meldingstijd"),
        "notifications": MessageLookupByLibrary.simpleMessage("Kennisgevingen"),
        "ny_tag": MessageLookupByLibrary.simpleMessage("NY"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "open_gallery": MessageLookupByLibrary.simpleMessage("Galerij openen"),
        "organized_photos_description":
            MessageLookupByLibrary.simpleMessage("Foto's die al zijn getagd"),
        "organized_photos_title":
            MessageLookupByLibrary.simpleMessage("Geordende foto's"),
        "parties_tag": MessageLookupByLibrary.simpleMessage("Feestjes"),
        "pets_tag": MessageLookupByLibrary.simpleMessage("Huisdieren"),
        "photo_gallery_count": m1,
        "photo_gallery_description":
            MessageLookupByLibrary.simpleMessage("Foto's nog niet geordend"),
        "photo_gallery_title":
            MessageLookupByLibrary.simpleMessage("Fotogallerij"),
        "photo_location": MessageLookupByLibrary.simpleMessage("Fotolocatie"),
        "photos_always_organized": MessageLookupByLibrary.simpleMessage(
            "Nu worden uw foto's altijd geordend"),
        "picpics_photo_manager":
            MessageLookupByLibrary.simpleMessage("picPics - Fotomanager"),
        "privacy_policy": MessageLookupByLibrary.simpleMessage("Privacybeleid"),
        "private_photos": MessageLookupByLibrary.simpleMessage("Prive-foto's"),
        "protect_with_encryption": MessageLookupByLibrary.simpleMessage(
            "Bescherm uw persoonlijke foto's met codering die alleen toegankelijk is met een pincode."),
        "rate_this_app":
            MessageLookupByLibrary.simpleMessage("Beoordeel deze app"),
        "recent_tags": MessageLookupByLibrary.simpleMessage("Recente tags"),
        "require_secret_key": MessageLookupByLibrary.simpleMessage(
            "Stel geheime sleutel als vereist"),
        "restore_purchase":
            MessageLookupByLibrary.simpleMessage("Herstel aankoop"),
        "save": MessageLookupByLibrary.simpleMessage("opslaan"),
        "save_location": MessageLookupByLibrary.simpleMessage("Bewaarlocatie"),
        "screenshots_tag":
            MessageLookupByLibrary.simpleMessage("Schermafbeeldingen"),
        "search": MessageLookupByLibrary.simpleMessage("Zoeken..."),
        "search_all_tags_not_found": MessageLookupByLibrary.simpleMessage(
            "Er zijn geen afbeeldingen gevonden met alle tags erop"),
        "search_results":
            MessageLookupByLibrary.simpleMessage("Zoekresultaten"),
        "secret_key_created": MessageLookupByLibrary.simpleMessage(
            "Geheime sleutel met succes aangemaakt!"),
        "secret_photos": MessageLookupByLibrary.simpleMessage("Geheime foto's"),
        "selfies_tag": MessageLookupByLibrary.simpleMessage("Selfies"),
        "settings": MessageLookupByLibrary.simpleMessage("Instellingen"),
        "share_with_friends":
            MessageLookupByLibrary.simpleMessage("Delen met vrienden"),
        "sign": MessageLookupByLibrary.simpleMessage("Tekenen"),
        "sports_tag": MessageLookupByLibrary.simpleMessage("Sport"),
        "start": MessageLookupByLibrary.simpleMessage("Beginnen"),
        "start_tagging":
            MessageLookupByLibrary.simpleMessage("Begin met taggen"),
        "suggestions": MessageLookupByLibrary.simpleMessage("Suggesties"),
        "tag_multiple_photos_at_once": MessageLookupByLibrary.simpleMessage(
            "Label meerdere foto's tegelijk"),
        "take_a_look":
            MessageLookupByLibrary.simpleMessage("Bekijk deze app eens!"),
        "take_a_look_description": m2,
        "terms_of_use":
            MessageLookupByLibrary.simpleMessage("Gebruiksvoorwaarden"),
        "time": MessageLookupByLibrary.simpleMessage("Tijd"),
        "toggle_date": MessageLookupByLibrary.simpleMessage("Datum"),
        "toggle_days": MessageLookupByLibrary.simpleMessage("Dagen"),
        "toggle_months": MessageLookupByLibrary.simpleMessage("Maanden"),
        "toggle_tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "travel_tag": MessageLookupByLibrary.simpleMessage("Reizen"),
        "tsqr_tag": MessageLookupByLibrary.simpleMessage("Times Square"),
        "tutorial_daily_package": MessageLookupByLibrary.simpleMessage(
            "We brengen u een dagelijks pakket om uw bibliotheek geleidelijk te organiseren."),
        "tutorial_however_you_want": MessageLookupByLibrary.simpleMessage(
            "Organiseer uw foto's door tags toe te voegen, zoals 'familie', 'huisdieren' of wat u maar wilt."),
        "tutorial_just_swipe": MessageLookupByLibrary.simpleMessage(
            "Nadat u de tags aan uw foto heeft toegevoegd, swiped u gewoon om naar de volgende te gaan."),
        "tutorial_multiselect": MessageLookupByLibrary.simpleMessage(
            "U kunt op uw foto's \"tikken en vasthouden\" om meerdere foto's tegelijk te taggen."),
        "tutorial_secret": MessageLookupByLibrary.simpleMessage(
            "Verberg uw privéfoto's met een pincodebescherming, zodat ze veilig zijn."),
        "unlimited_private_pics":
            MessageLookupByLibrary.simpleMessage("Onbeperkt privéfoto's"),
        "vacation_tag": MessageLookupByLibrary.simpleMessage("Vakantie"),
        "view_hidden_photos": MessageLookupByLibrary.simpleMessage(
            "Om uw verborgen foto's te zien ontgrendelt u het slot in de applicatie-instellingen. U kunt ze ontgrendelen met uw PIN."),
        "welcome": MessageLookupByLibrary.simpleMessage("Welkom!"),
        "work_tag": MessageLookupByLibrary.simpleMessage("Werk"),
        "x_minutes": MessageLookupByLibrary.simpleMessage("20 minuten"),
        "year": MessageLookupByLibrary.simpleMessage("jaar"),
        "yes": MessageLookupByLibrary.simpleMessage("Ja"),
        "your_secret_key":
            MessageLookupByLibrary.simpleMessage("Uw geheime sleutel")
      };
}

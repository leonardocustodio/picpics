// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
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
  String get localeName => 'de';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Keine Fotos ausgewählt', one: '1 Foto ausgewählt', other: '${howMany} Fotos ausgewählt')}";

  static m1(number) => "Sie haben die ${number} Ihrer täglich kostenlosen Bilder fertiggestellt, möchten Sie fortfahren?";

  static m2(url) => "Gehen Sie zu ${url}, um alle Ihre Fotos zu organisieren.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Zugangscode"),
    "access_code_sent" : MessageLookupByLibrary.simpleMessage("Ein Zugangsschlüssel wurde an user@email.com gesendet."),
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Mehrere Tags hinzufügen"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Tag hinzufügen"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Tags hinzufügen"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organisieren Sie mehrere Fotos gleichzeitig."),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Alle Suche-Tags"),
    "always" : MessageLookupByLibrary.simpleMessage("Immer"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Das Abonnement "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("ist automatisch erneuerbar."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Abbrechen"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("kann jederzeit gekündigt werden."),
    "close" : MessageLookupByLibrary.simpleMessage("Schließen"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Bestätigen Sie Ihre Registrierungs-E-Mail und erhalten Sie Ihren Zugangscode."),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Bestätigen Sie den Geheimschlüssel."),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Fortsetzen"),
    "country" : MessageLookupByLibrary.simpleMessage("Land"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Tägliche Herausforderung"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Damit wir Ihre täglichen Herausforderungen senden können, benötigen wir eine Autorisierung zum Senden von Benachrichtigungen. Daher ist es erforderlich, dass Sie die Benachrichtigungen in den Optionen Ihres Mobiltelefons autorisieren."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Tägliches Ziel"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("Löschen"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Dieses Gerät hat kein Foto in der Galerie, daher gibt es kein Foto, das markiert werden kann."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Möchten Sie dieses Foto anzeigen?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Nicht erneut fragen"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Tag bearbeiten"),
    "email" : MessageLookupByLibrary.simpleMessage("E-Mail-Adresse"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Alle Galerien exportieren"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Bibliothek exportieren"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Familie"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Finden Sie leicht Ihre Fotos."),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Lebensmittel"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Geheimschlüssel vergessen?"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Vollbildschirm"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Zugriffsberechtigungen"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Um Ihre Fotos organisieren zu können, benötigen wir eine Berechtigung für den Zugriff."),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Um Ihre Fotos zu organisieren, benötigen wir Zugriff auf Ihre Fotogalerie."),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("ERHALTEN SIE ALLE DIESE FUNKTIONEN"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Holen Sie sich jetzt Premium!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("PREMIUM HOLEN"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Zuhause"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Wie viele Bilder"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Unendliche Tags"),
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Erneut fragen"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Ihr Foto in picPics ist jetzt sicher. Möchten Sie es von Ihrer Kamerarolle löschen?"),
    "language" : MessageLookupByLibrary.simpleMessage("Sprache"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Sperren Sie Ihre privaten Fotos mit einem PIN-Passcode."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Sperren Sie Ihre Fotos"),
    "month" : MessageLookupByLibrary.simpleMessage("Monat"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Neuer Geheimschlüssel"),
    "next" : MessageLookupByLibrary.simpleMessage("Nächstes"),
    "no" : MessageLookupByLibrary.simpleMessage("Nein"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Keine Werbung"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Kein vorheriger Kauf"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Sie haben noch keine getaggten Fotos"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Keine Tags gefunden"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Es konnte kein gültiger Abonnementkauf gefunden werden."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Benachrichtigungszeit"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Galerie öffnen"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Bereits markierte Fotos"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Organisierte Fotos"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Partys"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Haustiere"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Noch nicht organisierte Fotos"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Fotogalerie"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Fotostandort"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Jetzt werden Ihre Fotos immer organisiert sein"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics – Fotomanager"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ALLE FUNKTIONEN OHNE WERBUNG"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Holen Sie sich ein Premium-Konto"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Sehen Sie sich die Videoanzeige an, um fortzufahren."),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Datenschutzbestimmungen"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Schützen Sie Ihre persönlichen Fotos mit einer Verschlüsselung, auf die nur mit einem PIN-Passwort zugegriffen werden kann."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Bewerten Sie diese App"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Geheimschlüssel anfordern"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Kauf wiederherstellen"),
    "save" : MessageLookupByLibrary.simpleMessage("speichern"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Speicherort"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Screenshots"),
    "search" : MessageLookupByLibrary.simpleMessage("Suche..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Es wurden keine Bilder mit allen Tags gefunden."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Suchergebnisse"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Der Geheimschlüssel wurde erfolgreich erstellt!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Geheime Fotos"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Einstellungen"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Mit Freunden teilen"),
    "sign" : MessageLookupByLibrary.simpleMessage("Zeichen"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sport"),
    "start" : MessageLookupByLibrary.simpleMessage("Start"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Starten Sie das Taggen"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Vorschläge"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Kennzeichnen Sie mehrere Fotos gleichzeitig."),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Schauen Sie sich diese App an!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Nutzungsbedingungen"),
    "time" : MessageLookupByLibrary.simpleMessage("Zeit"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Reise"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Wir bieten Ihnen ein tägliches Paket, mit dem Sie Ihre Bibliothek schrittweise organisieren können."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organisieren Sie Ihre Fotos, indem Sie Tags wie \"Familie\", \"Haustiere\" oder was Sie möchten hinzufügen."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Wischen Sie nach dem Hinzufügen der Tags zu Ihrem Foto einfach, um zum nächsten zu gelangen."),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Urlaub"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Deaktivieren Sie die Sperre in den App-Einstellungen, um versteckte Fotos anzuzeigen. Sie können diese Option mit Ihrer PIN freischalten."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Herzlich willkommen!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Arbeit"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 Minuten"),
    "year" : MessageLookupByLibrary.simpleMessage("Jahr"),
    "yes" : MessageLookupByLibrary.simpleMessage("Ja"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Du bist Premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Ihr Geheimschlüssel")
  };
}

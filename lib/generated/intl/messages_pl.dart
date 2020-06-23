// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "Skończyłeś swoje ${number} codzienne zdjęcia, czy chcesz kontynuować?";

  static m2(url) => "Aby uporządkować wszystkie zdjęcia, przejdź do ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Dodaj tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Dodaj tagi"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Subskrypcja jest "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("autoodnawialne."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Anuluj"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Anuluj w dowolnym momencie"),
    "close" : MessageLookupByLibrary.simpleMessage("Blisko"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Kontyntynuj"),
    "country" : MessageLookupByLibrary.simpleMessage("kraj"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Wyzwanie dnia"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Abyśmy mogli wysyłać codzienne wyzwania, potrzebujemy autoryzacji do wysyłania powiadomień, dlatego konieczne jest, abyś autoryzował powiadomienia w opcjach swojego telefonu komórkowego"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Dzienny cel"),
    "delete" : MessageLookupByLibrary.simpleMessage("Usunąć"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("To urządzenie nie ma zdjęcia w galerii, więc nie ma zdjęcia, które można oznaczyć."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Edytuj tag"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Eksportuj całą galerię"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Eksportuj bibliotekę"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Rodzina"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Foods"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Pełny ekran"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Uprawnienia dostępu"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Aby rozpocząć porządkowanie zdjęć, potrzebujemy autoryzacji, aby uzyskać do nich dostęp"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Aby uporządkować Twoje zdjęcia, potrzebujemy dostępu do Twojej galerii zdjęć"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("MIEĆ WSZYSTKIE TE CECHY"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Zdobądź premię już teraz!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("POBIERZ PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Dom"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Ile zdjęć"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Nieskończone tagi"),
    "language" : MessageLookupByLibrary.simpleMessage("Język"),
    "month" : MessageLookupByLibrary.simpleMessage("miesiąc"),
    "next" : MessageLookupByLibrary.simpleMessage("Kolejny"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Bez reklam"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Brak poprzedniego zakupu"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Nie masz jeszcze żadnych oznaczonych zdjęć"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Nie znaleziono tagów"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Nie można znaleźć prawidłowego zakupu subskrypcji."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Czas powiadomienia"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Powiadomienia"),
    "ok" : MessageLookupByLibrary.simpleMessage("ok"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Otwórz galerię"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Photos that have already been tagged"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Zorganizowane zdjęcia"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Strony"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Zwierzęta"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Zdjęcia jeszcze nie zorganizowane"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galeria zdjęć"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Lokalizacja zdjęcia"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Teraz Twoje zdjęcia będą zawsze uporządkowane"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("WSZYSTKIE FUNKCJE BEZ REKLAM"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Uzyskaj konto premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Obejrzyj reklamę wideo, aby kontynuować"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Polityka prywatności"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Oceń tę aplikację"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Przywróć zakup"),
    "save" : MessageLookupByLibrary.simpleMessage("zapisać"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Zapisz lokalizację"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Zrzuty ekranu"),
    "search" : MessageLookupByLibrary.simpleMessage("Szukaj..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Wyniki wyszukiwania"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Samojebki"),
    "settings" : MessageLookupByLibrary.simpleMessage("Ustawienia"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Podziel się z przyjaciółmi"),
    "sign" : MessageLookupByLibrary.simpleMessage("Znak"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sporty"),
    "start" : MessageLookupByLibrary.simpleMessage("Początek"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Rozpocznij tagowanie"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Propozycje"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Oznacz wiele zdjęć jednocześnie"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Spójrz na tę aplikację!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Warunki korzystania"),
    "time" : MessageLookupByLibrary.simpleMessage("Czas"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Podróżować"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Przynosimy codzienny pakiet, aby stopniowo uporządkować bibliotekę."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Uporządkuj swoje zdjęcia, dodając tagi, takie jak „rodzina”, „zwierzęta” lub cokolwiek chcesz."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Po dodaniu tagów do zdjęcia po prostu przesuń palcem, aby przejść do następnego."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Witamy!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Praca"),
    "year" : MessageLookupByLibrary.simpleMessage("rok"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Jesteś premium!")
  };
}

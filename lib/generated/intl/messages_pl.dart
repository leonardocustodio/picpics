// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl locale. All the
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
  String get localeName => 'pl';

  static String m0(email) => "Klucz dostępu został wysłany na adres ${email}";

  static String m1(howMany) => Intl.plural(howMany,
      zero: 'Nie wybrano zdjęć',
      one: 'Wybrano 1 zdjęcie',
      other: 'Wybrano ${howMany} zdjęć');

  static String m2(url) =>
      "Aby uporządkować wszystkie zdjęcia, przejdź do ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "access_code": MessageLookupByLibrary.simpleMessage("Kod dostępu"),
        "access_code_sent": m0,
        "add_multiple_tags":
            MessageLookupByLibrary.simpleMessage("Tagi Adicione múltiplas"),
        "add_tag": MessageLookupByLibrary.simpleMessage("Dodaj tag"),
        "add_tags": MessageLookupByLibrary.simpleMessage("Dodaj tagi"),
        "allTags": MessageLookupByLibrary.simpleMessage("All Tags"),
        "all_at_once": MessageLookupByLibrary.simpleMessage(
            "Organizuj wiele zdjęć jednocześnie"),
        "all_search_tags":
            MessageLookupByLibrary.simpleMessage("Wszystkie tagi wyszukiwania"),
        "always": MessageLookupByLibrary.simpleMessage("Zawsze"),
        "ask_photo_library_permission": MessageLookupByLibrary.simpleMessage(
            "Potrzebujemy dostępu do Twojej biblioteki zdjęć, abyś mógł zacząć porządkować swoje zdjęcia za pomocą picPics. Nie martw się, że Twoje dane nigdy nie opuszczą Twojego urządzenia!"),
        "auto_renewable_first_part":
            MessageLookupByLibrary.simpleMessage("Subskrypcja jest "),
        "auto_renewable_second_part":
            MessageLookupByLibrary.simpleMessage("autoodnawialne."),
        "cancel": MessageLookupByLibrary.simpleMessage("Anuluj"),
        "cancel_anytime":
            MessageLookupByLibrary.simpleMessage("Anuluj w dowolnym momencie"),
        "close": MessageLookupByLibrary.simpleMessage("Blisko"),
        "confirm_email": MessageLookupByLibrary.simpleMessage(
            "Potwierdź swój e-mail rejestracyjny, aby otrzymać kod dostępu"),
        "confirm_secret_key":
            MessageLookupByLibrary.simpleMessage("Potwierdź tajny klucz"),
        "continue_string": MessageLookupByLibrary.simpleMessage("Kontyntynuj"),
        "country": MessageLookupByLibrary.simpleMessage("kraj"),
        "daily_challenge":
            MessageLookupByLibrary.simpleMessage("Wyzwanie dnia"),
        "daily_challenge_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "Abyśmy mogli wysyłać codzienne wyzwania, potrzebujemy autoryzacji do wysyłania powiadomień, dlatego konieczne jest, abyś autoryzował powiadomienia w opcjach swojego telefonu komórkowego"),
        "daily_goal": MessageLookupByLibrary.simpleMessage("Dzienny cel"),
        "daily_notification_description": MessageLookupByLibrary.simpleMessage(
            "It's time to complete your picPics daily challenge!"),
        "daily_notification_title":
            MessageLookupByLibrary.simpleMessage("Daily challenge"),
        "delete": MessageLookupByLibrary.simpleMessage("Usunąć"),
        "device_has_no_pics": MessageLookupByLibrary.simpleMessage(
            "To urządzenie nie ma zdjęcia w galerii, więc nie ma zdjęcia, które można oznaczyć."),
        "disable_secret":
            MessageLookupByLibrary.simpleMessage("Chcesz odkryć to zdjęcie?"),
        "dont_ask_again":
            MessageLookupByLibrary.simpleMessage("Nie pytaj ponownie"),
        "edit_tag": MessageLookupByLibrary.simpleMessage("Edytuj tag"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "enable_faceid": MessageLookupByLibrary.simpleMessage("Włącz Face ID"),
        "enable_fingerprint":
            MessageLookupByLibrary.simpleMessage("Włącz odcisk palca"),
        "enable_irisscanner":
            MessageLookupByLibrary.simpleMessage("Włącz skaner tęczówki"),
        "enable_touchid":
            MessageLookupByLibrary.simpleMessage("Włącz Touch ID"),
        "export_all_gallery":
            MessageLookupByLibrary.simpleMessage("Eksportuj całą galerię"),
        "export_library":
            MessageLookupByLibrary.simpleMessage("Eksportuj bibliotekę"),
        "family_tag": MessageLookupByLibrary.simpleMessage("Rodzina"),
        "feedback_bug_report":
            MessageLookupByLibrary.simpleMessage("Opinie i błędy"),
        "find_easily":
            MessageLookupByLibrary.simpleMessage("Łatwo znajduj swoje zdjęcia"),
        "finishing": MessageLookupByLibrary.simpleMessage("Finishing..."),
        "foods_tag": MessageLookupByLibrary.simpleMessage("Foods"),
        "forgot_secret_key":
            MessageLookupByLibrary.simpleMessage("Zapomniałeś tajnego klucza?"),
        "full_screen": MessageLookupByLibrary.simpleMessage("Pełny ekran"),
        "gallery_access_permission":
            MessageLookupByLibrary.simpleMessage("Uprawnienia dostępu"),
        "gallery_access_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "Aby rozpocząć porządkowanie zdjęć, potrzebujemy autoryzacji, aby uzyskać do nich dostęp"),
        "gallery_access_reason": MessageLookupByLibrary.simpleMessage(
            "Aby uporządkować Twoje zdjęcia, potrzebujemy dostępu do Twojej galerii zdjęć"),
        "home_tag": MessageLookupByLibrary.simpleMessage("Dom"),
        "how_many_pics": MessageLookupByLibrary.simpleMessage("Ile zdjęć"),
        "infinite_tags":
            MessageLookupByLibrary.simpleMessage("Nieskończone tagi"),
        "keep_asking": MessageLookupByLibrary.simpleMessage("Pytaj dalej"),
        "keep_safe": MessageLookupByLibrary.simpleMessage(
            "Twoje zdjęcie jest teraz bezpieczne na picPics. Czy chcesz go usunąć z rolki aparatu?"),
        "language": MessageLookupByLibrary.simpleMessage("Język"),
        "lock_with_pin": MessageLookupByLibrary.simpleMessage(
            "Zablokuj swoje prywatne zdjęcia za pomocą kodu PIN."),
        "lock_your_photos":
            MessageLookupByLibrary.simpleMessage("Zablokuj swoje zdjęcia"),
        "month": MessageLookupByLibrary.simpleMessage("miesiąc"),
        "new_secret_key":
            MessageLookupByLibrary.simpleMessage("Nowy tajny klucz"),
        "next": MessageLookupByLibrary.simpleMessage("Kolejny"),
        "no": MessageLookupByLibrary.simpleMessage("Nie"),
        "no_ads": MessageLookupByLibrary.simpleMessage("Bez reklam"),
        "no_photos_were_tagged": MessageLookupByLibrary.simpleMessage(
            "There are no more photos to organize."),
        "no_previous_purchase":
            MessageLookupByLibrary.simpleMessage("Brak poprzedniego zakupu"),
        "no_tagged_photos": MessageLookupByLibrary.simpleMessage(
            "Nie masz jeszcze żadnych oznaczonych zdjęć"),
        "no_tags_found":
            MessageLookupByLibrary.simpleMessage("Nie znaleziono tagów"),
        "no_valid_subscription": MessageLookupByLibrary.simpleMessage(
            "Nie można znaleźć prawidłowego zakupu subskrypcji."),
        "notification_time":
            MessageLookupByLibrary.simpleMessage("Czas powiadomienia"),
        "notifications": MessageLookupByLibrary.simpleMessage("Powiadomienia"),
        "ny_tag": MessageLookupByLibrary.simpleMessage("NY"),
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "open_gallery": MessageLookupByLibrary.simpleMessage("Otwórz galerię"),
        "organized_photos_description": MessageLookupByLibrary.simpleMessage(
            "Photos that have already been tagged"),
        "organized_photos_title":
            MessageLookupByLibrary.simpleMessage("Zorganizowane zdjęcia"),
        "parties_tag": MessageLookupByLibrary.simpleMessage("Strony"),
        "pets_tag": MessageLookupByLibrary.simpleMessage("Zwierzęta"),
        "photo_gallery_count": m1,
        "photo_gallery_description": MessageLookupByLibrary.simpleMessage(
            "Zdjęcia jeszcze nie zorganizowane"),
        "photo_gallery_title":
            MessageLookupByLibrary.simpleMessage("Galeria zdjęć"),
        "photo_location":
            MessageLookupByLibrary.simpleMessage("Lokalizacja zdjęcia"),
        "photos_always_organized": MessageLookupByLibrary.simpleMessage(
            "Teraz Twoje zdjęcia będą zawsze uporządkowane"),
        "picpics_photo_manager":
            MessageLookupByLibrary.simpleMessage("picPics - Menedżer zdjęć"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Polityka prywatności"),
        "private_photos":
            MessageLookupByLibrary.simpleMessage("Zdjęcia prywatne"),
        "protect_with_encryption": MessageLookupByLibrary.simpleMessage(
            "Chroń swoje osobiste zdjęcia za pomocą szyfrowania dostępnego tylko za pomocą hasła PIN."),
        "rate_this_app":
            MessageLookupByLibrary.simpleMessage("Oceń tę aplikację"),
        "recent_tags": MessageLookupByLibrary.simpleMessage("Ostatnie tagi"),
        "require_secret_key":
            MessageLookupByLibrary.simpleMessage("Wymagaj tajnego klucza"),
        "restore_purchase":
            MessageLookupByLibrary.simpleMessage("Przywróć zakup"),
        "save": MessageLookupByLibrary.simpleMessage("zapisać"),
        "save_location":
            MessageLookupByLibrary.simpleMessage("Zapisz lokalizację"),
        "screenshots_tag":
            MessageLookupByLibrary.simpleMessage("Zrzuty ekranu"),
        "search": MessageLookupByLibrary.simpleMessage("Szukaj..."),
        "search_all_tags_not_found": MessageLookupByLibrary.simpleMessage(
            "Nie znaleziono zdjęć ze wszystkimi tagami"),
        "search_results":
            MessageLookupByLibrary.simpleMessage("Wyniki wyszukiwania"),
        "secret_key_created": MessageLookupByLibrary.simpleMessage(
            "Tajny klucz został pomyślnie utworzony!"),
        "secret_photos": MessageLookupByLibrary.simpleMessage("Tajne zdjęcia"),
        "selfies_tag": MessageLookupByLibrary.simpleMessage("Samojebki"),
        "settings": MessageLookupByLibrary.simpleMessage("Ustawienia"),
        "share_with_friends":
            MessageLookupByLibrary.simpleMessage("Podziel się z przyjaciółmi"),
        "sign": MessageLookupByLibrary.simpleMessage("Znak"),
        "sports_tag": MessageLookupByLibrary.simpleMessage("Sporty"),
        "start": MessageLookupByLibrary.simpleMessage("Początek"),
        "start_tagging":
            MessageLookupByLibrary.simpleMessage("Rozpocznij tagowanie"),
        "suggestions": MessageLookupByLibrary.simpleMessage("Propozycje"),
        "tag_multiple_photos_at_once": MessageLookupByLibrary.simpleMessage(
            "Oznacz wiele zdjęć jednocześnie"),
        "take_a_look":
            MessageLookupByLibrary.simpleMessage("Spójrz na tę aplikację!"),
        "take_a_look_description": m2,
        "terms_of_use":
            MessageLookupByLibrary.simpleMessage("Warunki korzystania"),
        "time": MessageLookupByLibrary.simpleMessage("Czas"),
        "toggle_date": MessageLookupByLibrary.simpleMessage("Data"),
        "toggle_days": MessageLookupByLibrary.simpleMessage("Dni"),
        "toggle_months": MessageLookupByLibrary.simpleMessage("Miesięcy"),
        "toggle_tags": MessageLookupByLibrary.simpleMessage("Tagi"),
        "travel_tag": MessageLookupByLibrary.simpleMessage("Podróżować"),
        "tsqr_tag": MessageLookupByLibrary.simpleMessage("Times Square"),
        "tutorial_daily_package": MessageLookupByLibrary.simpleMessage(
            "Przynosimy codzienny pakiet, aby stopniowo uporządkować bibliotekę."),
        "tutorial_however_you_want": MessageLookupByLibrary.simpleMessage(
            "Uporządkuj swoje zdjęcia, dodając tagi, takie jak „rodzina”, „zwierzęta” lub cokolwiek chcesz."),
        "tutorial_just_swipe": MessageLookupByLibrary.simpleMessage(
            "Po dodaniu tagów do zdjęcia po prostu przesuń palcem, aby przejść do następnego."),
        "tutorial_multiselect": MessageLookupByLibrary.simpleMessage(
            "Możesz „dotknąć i przytrzymać” swoje zdjęcia, aby oznaczyć tagami wiele zdjęć naraz."),
        "tutorial_secret": MessageLookupByLibrary.simpleMessage(
            "Ukryj swoje prywatne zdjęcia za pomocą kodu PIN, aby były bezpieczne."),
        "unlimited_private_pics": MessageLookupByLibrary.simpleMessage(
            "Nieograniczone prywatne zdjęcia"),
        "vacation_tag": MessageLookupByLibrary.simpleMessage("Wakacje"),
        "view_hidden_photos": MessageLookupByLibrary.simpleMessage(
            "Aby wyświetlić ukryte zdjęcia, odblokuj w ustawieniach aplikacji. Możesz je odblokować za pomocą kodu PIN."),
        "welcome": MessageLookupByLibrary.simpleMessage("Witamy!"),
        "work_tag": MessageLookupByLibrary.simpleMessage("Praca"),
        "x_minutes": MessageLookupByLibrary.simpleMessage("20 minut"),
        "year": MessageLookupByLibrary.simpleMessage("rok"),
        "yes": MessageLookupByLibrary.simpleMessage("tak"),
        "your_secret_key":
            MessageLookupByLibrary.simpleMessage("Twój tajny klucz")
      };
}

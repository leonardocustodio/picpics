// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Nessuna foto selezionata', one: '1 foto selezionata', other: '${howMany} foto selezionate')}";

  static m1(number) => "Hai completato ${number} immagini giornaliere gratuite, vuoi continuare?";

  static m2(url) => "Per organizzare tutte le tue foto vai a ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Codice d\'accesso"),
    "access_code_sent" : MessageLookupByLibrary.simpleMessage("Una chiave di accesso è stata inviata a utente@email.com"),
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Aggiungi molteplici tag"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Aggiungi Tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Aggiungi i tag"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organizza più foto contemporaneamente"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Tutti i tag di ricerca"),
    "always" : MessageLookupByLibrary.simpleMessage("Sempre"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("L\'abbonamento è "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("rinnovabile automaticamente."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annulla"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Annulla in qualsiasi momento"),
    "close" : MessageLookupByLibrary.simpleMessage("Chiudi"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Conferma la tua email di registrazione per ricevere il tuo codice di accesso"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Conferma chiave segreta"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continua"),
    "country" : MessageLookupByLibrary.simpleMessage("nazione"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Sfida quotidiana"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Per poter inviare le tue sfide quotidiane abbiamo bisogno dell\'autorizzazione per inviare notifiche, quindi è necessario autorizzare le notifiche nelle opzioni del tuo cellulare"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Obiettivo giornaliero"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("Elimina"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Questo dispositivo non ha foto nella galleria, quindi non ci sono foto che possono essere taggate."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Vuoi mostrare questa foto?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Non chiedere di nuovo"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Modifica tag"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Esporta tutta la galleria"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Esporta libreria"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Famiglia"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Trova facilmente le tue foto"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Alimenti"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Hai dimenticato la chiave segreta?"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("A schermo intero"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Autorizzazioni di accesso"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Per iniziare a organizzare le tue foto, abbiamo bisogno dell\'autorizzazione per accedervi"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Per organizzare le tue foto abbiamo bisogno di accedere alla tua galleria fotografica"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("PER AVERE TUTTE QUESTE CARATTERISTICHE"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Ottieni la versione premium ora!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("OTTIENI LA VERSIONE PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Casa"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Quante foto"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Tag infiniti"),
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Continua a chiedere"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("La tua foto è ora al sicuro su picPics. Vuoi eliminarlo dal rullino fotografico?"),
    "language" : MessageLookupByLibrary.simpleMessage("Linguaggio"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Blocca le tue foto private con un codice PIN."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Blocca le tue foto"),
    "month" : MessageLookupByLibrary.simpleMessage("mese"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Nuova chiave segreta"),
    "next" : MessageLookupByLibrary.simpleMessage("Successivo"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Nessuna pubblicità"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Nessun acquisto precedente"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Non hai ancora foto taggate"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Nessun tag trovato"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Impossibile trovare un acquisto in abbonamento valido."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Tempo di notifica"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifiche"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Galleria aperta"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Foto che sono già state taggate"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Foto organizzate"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Feste"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Animali"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Foto non ancora organizzate"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galleria foto"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Posizione della foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Ora le tue foto saranno sempre organizzate"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - Gestore di foto"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("TUTTE LE CARATTERISTICHE SENZA ANNUNCI"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Ottieni un account Premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Guarda l\'annuncio video per continuare"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Informativa sulla privacy"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Proteggi le tue foto personali con la crittografia accessibile solo con una password PIN."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Valuta questa applicazione"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Richiedi chiave segreta"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Ripristina acquisto"),
    "save" : MessageLookupByLibrary.simpleMessage("Salva"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Salva la posizione"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Screenshot"),
    "search" : MessageLookupByLibrary.simpleMessage("Ricerca..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Non sono state trovate immagini con tutti i tag su di essa"),
    "search_results" : MessageLookupByLibrary.simpleMessage("Risultati di ricerca"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Chiave segreta creata con successo!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Foto segrete"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfie"),
    "settings" : MessageLookupByLibrary.simpleMessage("Impostazioni"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Condividi con gli amici"),
    "sign" : MessageLookupByLibrary.simpleMessage("Registrati"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sport"),
    "start" : MessageLookupByLibrary.simpleMessage("Inizia"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Inizia a taggare"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Suggerimenti"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Tagga più foto contemporaneamente"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Dai un\'occhiata a questa app!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Condizioni d\'uso"),
    "time" : MessageLookupByLibrary.simpleMessage("Orario"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Viaggio"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Ti offriamo un pacchetto giornaliero per organizzare gradualmente la tua biblioteca."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organizza le tue foto aggiungendo tag, come \"famiglia\", \"animali domestici\" o qualsiasi cosa tu voglia."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Dopo aver aggiunto i tag alla tua foto, basta scorrere per passare al successivo."),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Vacanza"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Per visualizzare le tue foto nascoste, disattiva il blocco nelle impostazioni dell\'applicazione. Puoi sbloccarle con il tuo PIN."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Benvenuto!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Lavoro"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 min"),
    "year" : MessageLookupByLibrary.simpleMessage("anno"),
    "yes" : MessageLookupByLibrary.simpleMessage("Sì"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Sei premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("La tua chiave segreta")
  };
}

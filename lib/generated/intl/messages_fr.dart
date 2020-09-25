// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Aucune photo sélectionnée', one: '1 photo sélectionnée', other: '${howMany} photos sélectionnées')}";

  static m1(number) => "Vous avez terminé vos ${number} photos quotidiennes gratuites, voulez-vous continuer ?";

  static m2(url) => "Pour organiser toutes vos photos, accédez à ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Code d\'accès"),
    "access_code_sent" : MessageLookupByLibrary.simpleMessage("Une clé d\'accès a été envoyée à user@email.com"),
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Ajouter de multiples mots clés"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Ajouter une étiquette"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Ajouter des étiquettes"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organisez plusieurs photos à la fois"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Toutes les mots clés de recherche"),
    "always" : MessageLookupByLibrary.simpleMessage("Toujours"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("L\'abonnement est "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("renouvelable automatiquement."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Annuler à tout moment"),
    "close" : MessageLookupByLibrary.simpleMessage("Fermer"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Confirmez votre courriel d\'inscription pour recevoir votre code d\'accès"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Confirmer la clé secrète"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuer"),
    "country" : MessageLookupByLibrary.simpleMessage("pays"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Défi quotidien"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Pour que nous puissions envoyer vos défis quotidiens, nous avons besoin d\'une autorisation pour envoyer des notifications, il est donc nécessaire que vous autorisiez les notifications dans les options de votre téléphone portable"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objectif quotidien"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("Supprimer"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Cet appareil n\'a pas de photo dans la galerie, il n\'y a donc aucune photo qui puisse être étiquetée."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Voulez-vous afficher cette photo ?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Ne plus demander"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Modifier l\'étiquette"),
    "email" : MessageLookupByLibrary.simpleMessage("Courriel"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exporter toute la galerie"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exporter la bibliothèque"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Famille"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Trouvez facilement vos photos"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Aliments"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Vous avez oublié la clé secrète ?"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Plein écran"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Autorisations d\'accès"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Pour commencer à organiser vos photos, nous avons besoin d\'une autorisation pour y accéder"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Pour organiser vos photos, nous devons avoir accès à votre galerie de photos"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("POUR AVOIR TOUTES CES FONCTIONNALITÉS"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Devenez un utilisateur Premium maintenant !"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("DEVENEZ PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Accueil"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Combien de photos"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Étiquettes infinies"),
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Continuer à demander"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Votre photo est désormais en sécurité sur picPics. Voulez-vous la supprimer de votre pellicule ?"),
    "language" : MessageLookupByLibrary.simpleMessage("Langue"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Verrouillez vos photos privées avec un code PIN."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Verrouillez vos photos"),
    "month" : MessageLookupByLibrary.simpleMessage("mois"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Nouvelle clé secrète"),
    "next" : MessageLookupByLibrary.simpleMessage("Suivant"),
    "no" : MessageLookupByLibrary.simpleMessage("Non"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Pas de pubs"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Aucun achat précédent"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Vous n\'avez pas encore de photos étiquetées"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Aucune étiquette trouvée"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Impossible de trouver un achat d\'abonnement valide."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Heure de notification"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("New York"),
    "ok" : MessageLookupByLibrary.simpleMessage("D\'accord"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Ouvrir la galerie"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Photos déjà étiquetées"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Photos organisées"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Soirées"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Animaux domestiques"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Photos pas encore organisées"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galerie de photos"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Emplacement de la photo"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Désormais, vos photos seront toujours organisées"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - Gestionnaire de photos"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("TOUTES LES FONCTIONNALITÉS SANS PUBLICITÉ"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obtenez un compte premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Regardez l\'annonce vidéo pour continuer"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Politique de confidentialité"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Protégez vos photos personnelles avec un cryptage accessible uniquement avec un mot de passe PIN."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Noter cette application"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Exiger une clé secrète"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurer l\'achat"),
    "save" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Enregistrer l\'emplacement"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Captures d\'écran"),
    "search" : MessageLookupByLibrary.simpleMessage("Chercher..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Aucune image n\'a été trouvée avec tous les mots clés saisis"),
    "search_results" : MessageLookupByLibrary.simpleMessage("Résultats de la recherche"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Clé secrète créée avec succès !"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Photos secrètes"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Paramètres"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Partager avec des amis"),
    "sign" : MessageLookupByLibrary.simpleMessage("Souscrire"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sports"),
    "start" : MessageLookupByLibrary.simpleMessage("Démarrer"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Commencer l\'étiquetage"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Suggestions"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Étiqueter plusieurs photos à la fois"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Jetez un oeil à cette application !"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Conditions d\'utilisation"),
    "time" : MessageLookupByLibrary.simpleMessage("Heure"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Voyage"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Nous vous proposons un forfait quotidien pour organiser progressivement votre bibliothèque."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organisez vos photos en y ajoutant des étiquettes, telles que \"famille\", \"animaux de compagnie\" ou tout ce que vous voulez."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Après avoir ajouté les étiquettes à votre photo, faites simplement glisser pour passer à la suivante."),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Vacances"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Pour afficher vos photos occultes, libérez le verrouillage dans les paramètres de l\'application. Vous pouvez le déverrouiller avec votre code PIN."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bienvenue !"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Travail"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 min"),
    "year" : MessageLookupByLibrary.simpleMessage("an"),
    "yes" : MessageLookupByLibrary.simpleMessage("Oui"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Vous êtes utilisateur Premium !"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Votre clé secrète")
  };
}

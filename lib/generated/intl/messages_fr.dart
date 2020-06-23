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

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "Vous avez terminé vos ${number} photos quotidiennes gratuites, voulez-vous continuer ?";

  static m2(url) => "Pour organiser toutes vos photos, accédez à ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Ajouter une étiquette"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Ajouter des étiquettes"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("L\'abonnement est "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("renouvelable automatiquement."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Annuler à tout moment"),
    "close" : MessageLookupByLibrary.simpleMessage("Fermer"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuer"),
    "country" : MessageLookupByLibrary.simpleMessage("pays"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Défi quotidien"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Pour que nous puissions envoyer vos défis quotidiens, nous avons besoin d\'une autorisation pour envoyer des notifications, il est donc nécessaire que vous autorisiez les notifications dans les options de votre téléphone portable"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objectif quotidien"),
    "delete" : MessageLookupByLibrary.simpleMessage("Supprimer"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Cet appareil n\'a pas de photo dans la galerie, il n\'y a donc aucune photo qui puisse être étiquetée."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Modifier l\'étiquette"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exporter toute la galerie"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exporter la bibliothèque"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Famille"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Aliments"),
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
    "language" : MessageLookupByLibrary.simpleMessage("Langue"),
    "month" : MessageLookupByLibrary.simpleMessage("mois"),
    "next" : MessageLookupByLibrary.simpleMessage("Suivant"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Pas de pubs"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Aucun achat précédent"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Vous n\'avez pas encore de photos étiquetées"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Aucune étiquette trouvée"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Impossible de trouver un achat d\'abonnement valide."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Heure de notification"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifications"),
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
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("TOUTES LES FONCTIONNALITÉS SANS PUBLICITÉ"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obtenez un compte premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Regardez l\'annonce vidéo pour continuer"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Politique de confidentialité"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Noter cette application"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurer l\'achat"),
    "save" : MessageLookupByLibrary.simpleMessage("sauvegarder"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Enregistrer l\'emplacement"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Captures d\'écran"),
    "search" : MessageLookupByLibrary.simpleMessage("Chercher..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Résultats de la recherche"),
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
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Nous vous proposons un forfait quotidien pour organiser progressivement votre bibliothèque."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organisez vos photos en y ajoutant des étiquettes, telles que \"famille\", \"animaux de compagnie\" ou tout ce que vous voulez."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Après avoir ajouté les étiquettes à votre photo, faites simplement glisser pour passer à la suivante."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bienvenue !"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Travail"),
    "year" : MessageLookupByLibrary.simpleMessage("an"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Vous êtes utilisateur Premium !")
  };
}

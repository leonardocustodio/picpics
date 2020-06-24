// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "Has completado tu ${number} de fotos diarias gratis, ¿quieres continuar?";

  static m2(url) => "Para organizar todas tus fotos, ve a ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Añadir etiqueta"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Añadir etiquetas"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("La suscripción se "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("renueva automáticamente."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Puedes cancelar en cualquier momento"),
    "close" : MessageLookupByLibrary.simpleMessage("Cerrar"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "country" : MessageLookupByLibrary.simpleMessage("país"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Desafío diario"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Para que podamos enviar tus desafíos diarios, necesitamos autorización para enviar notificaciones, por lo tanto, es necesario que autorices las notificaciones en las opciones de tu teléfono celular"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objetivo diario"),
    "delete" : MessageLookupByLibrary.simpleMessage("Eliminar"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Este dispositivo no tiene ninguna foto en la galería, por lo que no hay fotos que se puedan etiquetar."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Editar etiqueta"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exportar toda la galería"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportar biblioteca"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Familia"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Alimentos"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Pantalla completa"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Permisos de acceso"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Para comenzar a organizar tus fotos, necesitamos autorización para acceder a ellas."),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Para organizar tus fotos, necesitamos acceder a tu galería de fotos."),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("PARA TENER TODAS ESTAS FUNCIONES"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("¡Hazte Premium ahora!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("HAZTE PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Casa"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Cuántas fotos"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Etiquetas infinitas"),
    "language" : MessageLookupByLibrary.simpleMessage("Idioma"),
    "month" : MessageLookupByLibrary.simpleMessage("mes"),
    "next" : MessageLookupByLibrary.simpleMessage("Siguiente"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Sin anuncios"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("No hay ninguna compra previa"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Aún no tienes ninguna foto etiquetada"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("No se encontró ninguna etiqueta"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("No se pudo encontrar ninguna compra de suscripción válida."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Hora de la notificación"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notificaciones"),
    "ok" : MessageLookupByLibrary.simpleMessage("Aceptar"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Abrir galería"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Fotos que ya se han etiquetado"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Fotos organizadas"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Fiestas"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Mascotas"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Fotos aún no organizadas"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galería de fotos"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Ubicación de la foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Ahora tus fotos siempre estarán organizadas"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("TODAS LAS FUNCIONES SIN ANUNCIOS"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obtener cuenta Premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Ver anuncio de vídeo para continuar"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Política de privacidad"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Califica esta aplicación"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurar compra"),
    "save" : MessageLookupByLibrary.simpleMessage("guardar"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Guardar dirección"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Capturas de pantalla"),
    "search" : MessageLookupByLibrary.simpleMessage("Buscar..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Resultados de la búsqueda"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Ajustes"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Compartir con amigos"),
    "sign" : MessageLookupByLibrary.simpleMessage("Firmar"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Deportes"),
    "start" : MessageLookupByLibrary.simpleMessage("Iniciar"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Comienza a etiquetar"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Sugerencias"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Etiqueta varias fotos a la vez"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("¡Echa un vistazo a esta aplicación!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Términos de uso"),
    "time" : MessageLookupByLibrary.simpleMessage("Hora"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Viajes"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Ofrecemos un paquete diario para que puedas organizar tu biblioteca gradualmente."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organiza tus fotos añadiendo etiquetas, como \'familia\', \'mascotas\' o lo que quieras."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Después de añadir las etiquetas a tu foto, simplemente desliza para pasar a la siguiente."),
    "welcome" : MessageLookupByLibrary.simpleMessage("¡Bienvenido!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Trabajo"),
    "year" : MessageLookupByLibrary.simpleMessage("año"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("¡Eres Premium!")
  };
}

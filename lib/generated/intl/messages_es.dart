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

  static m0(email) => "Se envió una clave de acceso a ${email}";

  static m1(howMany) => "${Intl.plural(howMany, zero: 'No hay ninguna foto seleccionada', one: '1 foto seleccionada', other: '${howMany} fotos seleccionadas')}";

  static m2(number) => "Has completado tu ${number} de fotos diarias gratis, ¿quieres continuar?";

  static m3(url) => "Para organizar todas tus fotos, ve a ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Código de acceso"),
    "access_code_sent" : m0,
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Añade múltiples etiquetas"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Añadir etiqueta"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Añadir etiquetas"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organiza varias fotos a la vez"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Todas las etiquetas de búsqueda"),
    "always" : MessageLookupByLibrary.simpleMessage("Siempre"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("La suscripción se "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("renueva automáticamente."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Puedes cancelar en cualquier momento"),
    "close" : MessageLookupByLibrary.simpleMessage("Cerrar"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Confirma tu correo electrónico de registro para recibir tu código de acceso"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Confirmar clave secreta"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "country" : MessageLookupByLibrary.simpleMessage("país"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Desafío diario"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Para que podamos enviar tus desafíos diarios, necesitamos autorización para enviar notificaciones, por lo tanto, es necesario que autorices las notificaciones en las opciones de tu teléfono celular"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objetivo diario"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("Eliminar"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Este dispositivo no tiene ninguna foto en la galería, por lo que no hay fotos que se puedan etiquetar."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("¿Quieres mostrar esta foto?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("No volver a preguntar"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Editar etiqueta"),
    "email" : MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exportar toda la galería"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportar biblioteca"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Familia"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Encuentra tus fotos fácilmente"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Alimentos"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("¿Olvidaste la clave secreta?"),
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
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Seguir preguntando"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Tu foto ahora está segura en picPics. ¿Quieres eliminarla del carrete de tu cámara?"),
    "language" : MessageLookupByLibrary.simpleMessage("Idioma"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Bloquea tus fotos privadas con un código PIN."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Bloquea tus fotos"),
    "month" : MessageLookupByLibrary.simpleMessage("mes"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Nueva clave secreta"),
    "next" : MessageLookupByLibrary.simpleMessage("Siguiente"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Sin anuncios"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("No hay ninguna compra previa"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Aún no tienes ninguna foto etiquetada"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("No se encontró ninguna etiqueta"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("No se pudo encontrar ninguna compra de suscripción válida."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Hora de la notificación"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notificaciones"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("Nueva York"),
    "ok" : MessageLookupByLibrary.simpleMessage("Aceptar"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Abrir galería"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Fotos que ya se han etiquetado"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Fotos organizadas"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Fiestas"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Mascotas"),
    "photo_gallery_count" : m1,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Fotos aún no organizadas"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galería de fotos"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Ubicación de la foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Ahora tus fotos siempre estarán organizadas"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics: Administrador de fotos"),
    "premium_modal_description" : m2,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("TODAS LAS FUNCIONES SIN ANUNCIOS"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obtener cuenta Premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Ver anuncio de vídeo para continuar"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Política de privacidad"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Protege tus fotos personales con cifrado al que sólo se puede acceder con una contraseña PIN."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Califica esta aplicación"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Requerir clave secreta"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurar compra"),
    "save" : MessageLookupByLibrary.simpleMessage("guardar"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Guardar dirección"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Capturas de pantalla"),
    "search" : MessageLookupByLibrary.simpleMessage("Buscar..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("No se encontraron imágenes con todas las etiquetas"),
    "search_results" : MessageLookupByLibrary.simpleMessage("Resultados de la búsqueda"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("¡Clave secreta creada correctamente!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Fotos secretas"),
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
    "take_a_look_description" : m3,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Términos de uso"),
    "time" : MessageLookupByLibrary.simpleMessage("Hora"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Viajes"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Ofrecemos un paquete diario para que puedas organizar tu biblioteca gradualmente."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organiza tus fotos añadiendo etiquetas, como \'familia\', \'mascotas\' o lo que quieras."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Después de añadir las etiquetas a tu foto, simplemente desliza para pasar a la siguiente."),
    "unlimited_private_pics" : MessageLookupByLibrary.simpleMessage("Fotos privadas ilimitadas"),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Vacaciones"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Para ver tus fotos ocultas, retira el bloqueo en los ajustes de la aplicación. Puedes desbloquearlas con tu PIN."),
    "welcome" : MessageLookupByLibrary.simpleMessage("¡Bienvenido!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Trabajo"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 minutos"),
    "year" : MessageLookupByLibrary.simpleMessage("año"),
    "yes" : MessageLookupByLibrary.simpleMessage("Sí"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("¡Eres Premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Tu clave secreta")
  };
}

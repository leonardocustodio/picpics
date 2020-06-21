// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
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
  String get localeName => 'pt';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Nenhuma foto selecionada', one: '1 foto selecionada', other: '${howMany} fotos selecionadas')}";

  static m1(number) => "Você completo seus ${number} pics diários gratuítos, deseja continuar?";

  static m2(url) => "Para organizar suas fotos, veja neste link: ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Add tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Add tags"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("A assinatura é "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-renovável."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Cancele a qualquer momento"),
    "close" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "country" : MessageLookupByLibrary.simpleMessage("país"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Desafio diário"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Para podermos enviar seus desafios diários, precisamos de autorização para enviar notificações; portanto, é necessário que você autorize as notificações nas opções do seu telefone celular."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objetivo diário"),
    "delete" : MessageLookupByLibrary.simpleMessage("Deletar"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Esse dispositivo não tem nenhuma foto na galeria, assim não há nenhuma foto que possa ser taggeada."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Editar tag"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exporte toda galeria"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportar biblioteca"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Família"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Comidas"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Tela cheia"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Permissão de acesso"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Para começarmos a organizar suas fotos, precisamos de autorização para acessá-las\""),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Para organizar suas fotos precisamos de acesso a sua galeria"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("PARA TER TODOS OS RECURSOS"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Seja premium agora!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("SEJA PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Casa"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Quantas fotos?"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Tags a vontade"),
    "month" : MessageLookupByLibrary.simpleMessage("mês"),
    "next" : MessageLookupByLibrary.simpleMessage("Próximo"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Sem propagandas"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Nenhuma compra encontrada"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Você não tem nenhuma foto taggeada ainda"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Nenhuma tag encontrada"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Não foi possível encontrar uma compra de assinatura válida."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Horário da notificação"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notificações"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Abrir galeria"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Fotos que já foram taggeadas"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Fotos organizadas"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Festas"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Pets"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Fotos ainda não organizadas"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galeria de fotos"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Local da foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Agora suas fotos estarão sempre organizadas"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("Todos os recursos e sem anuncios"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obter conta premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Assista ao anúncio para continuar"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Política de privacidade"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Avalie esse app"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurar compra"),
    "save" : MessageLookupByLibrary.simpleMessage("economize"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Confirmar localização"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Sreenshots"),
    "search" : MessageLookupByLibrary.simpleMessage("Pesquisar..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Resultados da busca"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfies"),
    "settings" : MessageLookupByLibrary.simpleMessage("Opções"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Compartilhar"),
    "sign" : MessageLookupByLibrary.simpleMessage("Por"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Sports"),
    "start" : MessageLookupByLibrary.simpleMessage("Começar"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Começe a taggear"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Sugestões"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Marque várias fotos de uma vez só"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Dê uma olhada nesse aplicativo!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Termos de uso"),
    "time" : MessageLookupByLibrary.simpleMessage("Horário"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Viagens"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Trazemos diariamente um pacote para você organizar aos poucos sua biblioteca."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organize suas fotos adicionando tags, como \"família\", \"pets\", ou o que você quiser."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Depois de adicionar as tags na sua foto, basta fazer um swipe para ir para a próxima."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bem-vindo!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Trabalho"),
    "year" : MessageLookupByLibrary.simpleMessage("ano"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Você é premium!")
  };
}

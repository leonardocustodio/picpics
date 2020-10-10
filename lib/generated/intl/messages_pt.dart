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

  static m0(email) => "Um código de acesso foi enviado para ${email}";

  static m1(howMany) => "${Intl.plural(howMany, zero: 'Nenhuma foto selecionada', one: '1 foto selecionada', other: '${howMany} fotos selecionadas')}";

  static m2(number) => "Você completo seus ${number} pics diários gratuítos, deseja continuar?";

  static m3(url) => "Para organizar suas fotos, veja neste link: ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("Código de Acesso"),
    "access_code_sent" : m0,
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("Adicione múltiplas tags"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("Add tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Add tags"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("Organize multiple photos at once"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("Não há mais nenhuma foto para organizar."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Todas as tags da pesquisa"),
    "always" : MessageLookupByLibrary.simpleMessage("Always"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("A assinatura é "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("auto-renovável."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Cancele a qualquer momento"),
    "close" : MessageLookupByLibrary.simpleMessage("Fechar"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("Confirm your registration email to receive your access code"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("Confirme a chave"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Continuar"),
    "country" : MessageLookupByLibrary.simpleMessage("país"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Desafio diário"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Para podermos enviar seus desafios diários, precisamos de autorização para enviar notificações; portanto, é necessário que você autorize as notificações nas opções do seu telefone celular."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Objetivo diário"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("Está na hora de completar o seu desáfio. Entre no picPics para completá-lo!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Desafio diário"),
    "delete" : MessageLookupByLibrary.simpleMessage("Deletar"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Esse dispositivo não tem nenhuma foto na galeria, assim não há nenhuma foto que possa ser taggeada."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("Deseja desocultar esta foto?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("Não pergunte mais"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Editar tag"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Exporte toda galeria"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Exportar biblioteca"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Família"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("Easily find your photos"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Comidas"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("Forgot secret key?"),
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
    "keep_asking" : MessageLookupByLibrary.simpleMessage("Pergunte sempre"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("Sua foto agora está segura no picPics. Deseja excluí-la do rolo da câmera?"),
    "language" : MessageLookupByLibrary.simpleMessage("Lingua"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("Lock down your private photos with a PIN passcode."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("Lock your photos"),
    "month" : MessageLookupByLibrary.simpleMessage("mês"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("Nova chave secreta"),
    "next" : MessageLookupByLibrary.simpleMessage("Próximo"),
    "no" : MessageLookupByLibrary.simpleMessage("Não"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Sem propagandas"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Nenhuma compra encontrada"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Você não tem nenhuma foto taggeada ainda"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Nenhuma tag encontrada"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Não foi possível encontrar uma compra de assinatura válida."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Horário da notificação"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notificações"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Abrir galeria"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Fotos que já foram taggeadas"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Fotos organizadas"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Festas"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Pets"),
    "photo_gallery_count" : m1,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Fotos não organizadas"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galeria de fotos"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Local da foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Agora suas fotos estarão sempre organizadas"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - Photo Manager"),
    "premium_modal_description" : m2,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("Todos os recursos e sem anuncios"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Obter conta premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Assista ao anúncio para continuar"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Política de privacidade"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("Protect your personal photos with encryption only accessible with a PIN password."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Avalie esse app"),
    "recent_tags" : MessageLookupByLibrary.simpleMessage("Recent Tags"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("Require secret key"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Restaurar compra"),
    "save" : MessageLookupByLibrary.simpleMessage("economize"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Confirmar localização"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Screenshots"),
    "search" : MessageLookupByLibrary.simpleMessage("Pesquisar..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Nenhuma foto foi encontrada com todas as tags."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Resultados da busca"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("Chave secreta criada com sucesso!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("Fotos Secretas"),
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
    "take_a_look_description" : m3,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Termos de uso"),
    "time" : MessageLookupByLibrary.simpleMessage("Horário"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Viagens"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("Times Square"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Trazemos diariamente um pacote para você organizar aos poucos sua biblioteca."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Organize suas fotos adicionando tags, como \"família\", \"pets\", ou o que você quiser."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Depois de adicionar as tags na sua foto, basta fazer um swipe para ir para a próxima."),
    "unlimited_private_pics" : MessageLookupByLibrary.simpleMessage("Fotos privadas ilimitadas"),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("Vacation"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("Para ver suas fotos ocultas, libere o bloqueio nas configurações do aplicativo. Você pode desbloqueá-las com seu PIN."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Bem-vindo!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Trabalho"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 min"),
    "year" : MessageLookupByLibrary.simpleMessage("ano"),
    "yes" : MessageLookupByLibrary.simpleMessage("Sim"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Você é premium!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("Sua chave secreta")
  };
}

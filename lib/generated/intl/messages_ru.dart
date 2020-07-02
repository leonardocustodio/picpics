// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "Вы обработали свои ${number} бесплатных ежедневных фото. Хотите продолжить?";

  static m2(url) => "Чтобы упорядочить все свои фотографии, перейдите по ссылке ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Добавить тег"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Добавить теги"),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("All Search Tags"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Подписка "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("продлевается автоматически."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Можно отменить в любое время"),
    "close" : MessageLookupByLibrary.simpleMessage("Закрыть"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Продолжить"),
    "country" : MessageLookupByLibrary.simpleMessage("страна"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Ежедневное задание"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Чтобы мы могли отправлять вам ежедневные задания, нам нужно разрешение на отправку уведомлений, поэтому вам необходимо разрешить уведомления в настройках вашего мобильного телефона."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Ежедневная цель"),
    "delete" : MessageLookupByLibrary.simpleMessage("Удалить"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("На этом устройстве нет фотографий в галерее, поэтому нет фотографии для разметки тегами."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Изменить тег"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Экспорт всей галереи"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Экспорт библиотеки"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Семья"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Продукты"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("На весь экран"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Права доступа"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Для организации ваших фотографий нам нужна авторизация доступа к ним."),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Для организации ваших фотографий нам нужен доступ к вашей фотогалерее"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("ЧТОБЫ ПОЛУЧИТЬ ВСЕ ЭТИ ФУНКЦИИ"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Получите Премиум сейчас!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("ПОЛУЧИТЕ ПРЕМИУМ"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Дом"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Сколько фото"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Бесконечные теги"),
    "language" : MessageLookupByLibrary.simpleMessage("язык"),
    "month" : MessageLookupByLibrary.simpleMessage("месяц"),
    "next" : MessageLookupByLibrary.simpleMessage("Далее"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Без рекламы"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Нет предыдущей покупки"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("У вас еще нет фотографий с тегами"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Теги не найдены"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Не удалось найти действительную покупку подписки."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Время уведомления"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Уведомления"),
    "ok" : MessageLookupByLibrary.simpleMessage("Хорошо"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Открыть галерею"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Уже отмеченные тегами фотографии"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Упорядоченные фотографии"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Вечеринки"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Питомцы"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Фотографии еще не упорядочены"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Фотогалерея"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Расположение фото"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Теперь ваши фотографии будут всегда упорядочены"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ВСЕ ФУНКЦИИ БЕЗ РЕКЛАМЫ"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Получить Премиум-аккаунт"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Для продолжения просмотрите видео-рекламу"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Политика конфиденциальности"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Оцените это приложение"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Восстановить покупку"),
    "save" : MessageLookupByLibrary.simpleMessage("Сохранить"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Сохранить местоположение"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Скриншоты"),
    "search" : MessageLookupByLibrary.simpleMessage("Поиск..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("No pictures were found with all tags on it."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Результаты поиска"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Селфи"),
    "settings" : MessageLookupByLibrary.simpleMessage("Настройки"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Поделиться с друзьями"),
    "sign" : MessageLookupByLibrary.simpleMessage("Подписать"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Спорт"),
    "start" : MessageLookupByLibrary.simpleMessage("Начать"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Начать разметку"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Предложения"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Разметка нескольких фото одновременно"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Взгляните на это приложение!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Условия использования"),
    "time" : MessageLookupByLibrary.simpleMessage("Время"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Путешествия"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Мы предоставляем вам ежедневный пакет, позволяющей постепенно упорядочить вашу библиотеку."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Организуйте свои фотографии, добавив к ним теги «семья», «питомцы», или какие вы сами хотите."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("После добавления тегов к фотографии просто проведите пальцем, чтобы перейти к следующему."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Добро пожаловать!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Работа"),
    "year" : MessageLookupByLibrary.simpleMessage("год"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Вы получили Премиум!")
  };
}

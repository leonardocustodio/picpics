// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja_JP locale. All the
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
  String get localeName => 'ja_JP';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'No photos selected', one: '1 photo selected', other: '${howMany} photos selected')}";

  static m1(number) => "You completed your ${number} free daily pics, do you want to continue?";

  static m2(url) => "すべての写真を整理するには、${url} にアクセスしてください";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("タグを付ける"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("タグを付ける"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("サブスクリプションは"),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("自動更新可能。"),
    "cancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("いつでもキャンセル"),
    "close" : MessageLookupByLibrary.simpleMessage("終了"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("続ける"),
    "country" : MessageLookupByLibrary.simpleMessage("国"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("デイリーチャレンジ"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("デイリーチャレンジをお届けするには、ユーザーの通知受信の許可が必要です。そのため、携帯電話のオプションで通知受信を許可にしてください。"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("デイリーゴール"),
    "delete" : MessageLookupByLibrary.simpleMessage("削除"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("このデバイスのギャラリーには写真がないため、タグ付けできる写真はありません。"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("タグを編集"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("すべてのギャラリーをエクスポート"),
    "export_library" : MessageLookupByLibrary.simpleMessage("ライブラリをエクスポート"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("家族"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("食べ物"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("全画面表示"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("アクセス許可"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("写真の整理を開始するには、写真にアクセスするための許可が必要です"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("写真を整理するにはフォトギャラリーにアクセスする必要があります"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("これらのすべての機能を利用する"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("今すぐプレミアムを購入しましょう！"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("プレミアムを購入"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("ホーム"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("写真の数"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("無数のタグ"),
    "month" : MessageLookupByLibrary.simpleMessage("月"),
    "next" : MessageLookupByLibrary.simpleMessage("次"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("広告なし"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("以前の購入はありません"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("タグ付けされた写真はまだありません"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("タグが見つかりません"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("有効なサブスクリプション購入が見つかりませんでした。"),
    "notification_time" : MessageLookupByLibrary.simpleMessage("通知時間"),
    "notifications" : MessageLookupByLibrary.simpleMessage("通知"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("ギャラリーを開く"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("タグ付けされている写真"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("整理された写真"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("パーティー"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("ペット"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("写真はまだ整理されていません"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("フォトギャラリー"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("写真の場所"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("これでいつでも写真が整理されます"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("広告なしのすべての機能"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("プレミアムアカウントを購入"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("続行するにはビデオ広告をご覧ください"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("このアプリを評価する"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("購入商品を復元"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "save_location" : MessageLookupByLibrary.simpleMessage("位置を保存"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("スクリーンショット"),
    "search" : MessageLookupByLibrary.simpleMessage("検索..."),
    "search_results" : MessageLookupByLibrary.simpleMessage("結果を検索"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("自撮り"),
    "settings" : MessageLookupByLibrary.simpleMessage("設定"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("友だちとシェア"),
    "sign" : MessageLookupByLibrary.simpleMessage("サイン"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("スポーツ"),
    "start" : MessageLookupByLibrary.simpleMessage("開始"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("タグ付けを開始"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("提案"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("一度に複数の写真にタグを付ける"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("このアプリを見てください！"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("利用規約"),
    "time" : MessageLookupByLibrary.simpleMessage("時間"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("旅行"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("ライブラリは徐々に整理できるよう、デイリーパッケージをお届けします。"),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("「家族」、「ペット」など、好きなタグを付けて写真を整理できます。"),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("写真にタグを付けた後はスワイプするだけで次の写真に移動できます。"),
    "welcome" : MessageLookupByLibrary.simpleMessage("ようこそ！"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("仕事"),
    "year" : MessageLookupByLibrary.simpleMessage("年"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("プレミアムのユーザーになりました！")
  };
}

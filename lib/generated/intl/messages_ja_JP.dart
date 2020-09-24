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

  static m0(howMany) => "${Intl.plural(howMany, zero: '写真が選択されていません', one: '1 枚の写真を選択しました', other: '${howMany} 枚の写真を選択しました')}";

  static m1(number) => "${number}無料のデイリー写真を完了しました。続けますか？";

  static m2(url) => "すべての写真を整理するには、${url} にアクセスしてください";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("アクセスコード"),
    "access_code_sent" : MessageLookupByLibrary.simpleMessage("アクセスキーが user@email.com に送信されました"),
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("複数のタグを追加"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("タグを付ける"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("タグを付ける"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("一度に複数の写真を整理"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("すべての検索タグ"),
    "always" : MessageLookupByLibrary.simpleMessage("常時"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("サブスクリプションは"),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("自動更新可能。"),
    "cancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("いつでもキャンセル"),
    "close" : MessageLookupByLibrary.simpleMessage("終了"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("登録メールを確認してアクセスコードを受け取る"),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("秘密の鍵を確認"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("続ける"),
    "country" : MessageLookupByLibrary.simpleMessage("国"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("デイリーチャレンジ"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("デイリーチャレンジをお届けするには、ユーザーの通知受信の許可が必要です。そのため、携帯電話のオプションで通知受信を許可にしてください。"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("デイリーゴール"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("削除"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("このデバイスのギャラリーには写真がないため、タグ付けできる写真はありません。"),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("この写真を非表示しますか？"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("質問はもうしないでください。"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("タグを編集"),
    "email" : MessageLookupByLibrary.simpleMessage("E メール"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("すべてのギャラリーをエクスポート"),
    "export_library" : MessageLookupByLibrary.simpleMessage("ライブラリをエクスポート"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("家族"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("写真を簡単に見つける"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("食べ物"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("秘密の鍵を忘れましたか？"),
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
    "keep_asking" : MessageLookupByLibrary.simpleMessage("質問を続ける"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("これで写真は picPics で安全になりました。カメラロールから削除しますか？"),
    "language" : MessageLookupByLibrary.simpleMessage("言語"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("PIN パスコードを使用してプライベートな写真をロックします。"),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("写真をロックする"),
    "month" : MessageLookupByLibrary.simpleMessage("月"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("新しい秘密の鍵"),
    "next" : MessageLookupByLibrary.simpleMessage("次"),
    "no" : MessageLookupByLibrary.simpleMessage("いいえ"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("広告なし"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("以前の購入はありません"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("タグ付けされた写真はまだありません"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("タグが見つかりません"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("有効なサブスクリプション購入が見つかりませんでした。"),
    "notification_time" : MessageLookupByLibrary.simpleMessage("通知時間"),
    "notifications" : MessageLookupByLibrary.simpleMessage("通知"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
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
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - フォトマネージャー"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("広告なしのすべての機能"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("プレミアムアカウントを購入"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("続行するにはビデオ広告をご覧ください"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("PIN パスワードでのみアクセスできる暗号化でパーソナルな写真を保護します。"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("このアプリを評価する"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("秘密の鍵が必要"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("購入商品を復元"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "save_location" : MessageLookupByLibrary.simpleMessage("位置を保存"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("スクリーンショット"),
    "search" : MessageLookupByLibrary.simpleMessage("検索..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("すべてのタグが付いた画像は見つかりませんでした"),
    "search_results" : MessageLookupByLibrary.simpleMessage("結果を検索"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("秘密の鍵が正常に作成されました！"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("秘密の写真"),
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
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("タイムズスクエア"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("ライブラリは徐々に整理できるよう、デイリーパッケージをお届けします。"),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("「家族」、「ペット」など、好きなタグを付けて写真を整理できます。"),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("写真にタグを付けた後はスワイプするだけで次の写真に移動できます。"),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("休暇"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("非表示の写真を表示するには、アプリケーションの設定でロックを解除してください。ロックの解除はお持ちのPIN\nで行うことができます。"),
    "welcome" : MessageLookupByLibrary.simpleMessage("ようこそ！"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("仕事"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20 分"),
    "year" : MessageLookupByLibrary.simpleMessage("年"),
    "yes" : MessageLookupByLibrary.simpleMessage("はい"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("プレミアムのユーザーになりました！"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("秘密の鍵")
  };
}

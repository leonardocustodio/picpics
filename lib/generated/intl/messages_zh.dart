// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static m0(howMany) => "${Intl.plural(howMany, zero: '未选择照片', one: '已选择1张照片', other: '已选择${howMany}张照片')}";

  static m1(number) => "您已完成您的${number}张免费每日图片，是否要继续？";

  static m2(url) => "要整理所有照片，请访问${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("添加标签"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("添加标签"),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("所有搜寻标签"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("订阅为"),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("自动续订。"),
    "cancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("随时取消"),
    "close" : MessageLookupByLibrary.simpleMessage("关闭"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("继续"),
    "country" : MessageLookupByLibrary.simpleMessage("国家"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("每日挑战"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("为了让我们能够发送您的每日挑战，我们需要授权来发送通知，因此您需要在手机选项中授权通知权限"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("每日目标"),
    "delete" : MessageLookupByLibrary.simpleMessage("删除"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("此设备的图库中没有照片，因此没有可以添加标签的照片。"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("编辑标签"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("导出所有图库"),
    "export_library" : MessageLookupByLibrary.simpleMessage("导出图库"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("家庭"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("食品"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("全屏"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("访问权限"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("要开始整理您的照片，我们需要授权以访问它们"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("要整理您的照片，我们需要访问您的照片库"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("享受所有这些功能"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("立即获取高级版！"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("获取高级版"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("居家"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("多少图片"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("无限标签"),
    "language" : MessageLookupByLibrary.simpleMessage("语言"),
    "month" : MessageLookupByLibrary.simpleMessage("月"),
    "next" : MessageLookupByLibrary.simpleMessage("下一个"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("无广告"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("没有之前的购买"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("您还没有添加了标签的照片"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("未找到标签"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("找不到有效的订阅购买。"),
    "notification_time" : MessageLookupByLibrary.simpleMessage("通知时间"),
    "notifications" : MessageLookupByLibrary.simpleMessage("通知"),
    "ok" : MessageLookupByLibrary.simpleMessage("确定"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("打开图库"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("已添加标签的照片"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("已整理的照片"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("派对"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("宠物"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("尚未整理的照片"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("照片库"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("照片位置"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("现在，您的照片将始终井井有条"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("所有功能，无广告"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("获取高级账户"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("观看视频广告以继续"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("隐私政策"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("评价这个App"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("恢复购买"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "save_location" : MessageLookupByLibrary.simpleMessage("保存位置"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("截屏"),
    "search" : MessageLookupByLibrary.simpleMessage("搜索..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("未找到带有所有标签的图片。"),
    "search_results" : MessageLookupByLibrary.simpleMessage("搜索结果"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("自拍"),
    "settings" : MessageLookupByLibrary.simpleMessage("设置"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("和朋友分享"),
    "sign" : MessageLookupByLibrary.simpleMessage("签"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("体育"),
    "start" : MessageLookupByLibrary.simpleMessage("开始"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("开始添加标签"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("建议"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("一次给多张照片添加标签"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("看看这个App！"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("使用条款"),
    "time" : MessageLookupByLibrary.simpleMessage("时间"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("旅行"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("我们为您带来每日包，以逐步整理您的图库。"),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("通过添加标签（例如“家庭”、“宠物”或任何您想要的标签）来整理照片。"),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("将标签添加到照片后，只需滑动即可前往下一个。"),
    "welcome" : MessageLookupByLibrary.simpleMessage("欢迎！"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("工作"),
    "year" : MessageLookupByLibrary.simpleMessage("年"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("您是高级版用户！")
  };
}

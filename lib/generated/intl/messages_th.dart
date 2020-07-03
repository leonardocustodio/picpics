// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a th locale. All the
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
  String get localeName => 'th';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'ไม่มีรูปที่เลือก', one: 'เลือก 1 ภาพ', other: 'เลือก ${howMany} ภาพ')}";

  static m1(number) => "คุณทำภาพถ่ายฟรีประจำวันครบ ${number} แล้ว ต้องการทำต่อไหม?";

  static m2(url) => "ไปที่ ${url} เพื่อจัดหมวดหมู่ภาพถ่ายทั้งหมด";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("เพิ่มแท็ก"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("เพิ่มแท็ก"),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("แท็กค้นหาทั้งหมด"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("การสมัครสมาชิกนี้"),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("มีการต่ออายุโดยอัตโนมัติ"),
    "cancel" : MessageLookupByLibrary.simpleMessage("ยกเลิก"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("ยกเลิกได้เสมอ"),
    "close" : MessageLookupByLibrary.simpleMessage("ปิด"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("ไปต่อ"),
    "country" : MessageLookupByLibrary.simpleMessage("ประเทศ"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("คำท้าประจำวัน"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("เนื่องจากการส่งคำท้าประจำวันจำเป็นต้องได้รับอนุญาตในการส่งการแจ้งเตือนด้วย เพราะฉะนั้นผู้ใช้จึงจำเป็นต้องเปิดให้อนุญาตแจ้งเตือนในโทรศัพท์มือถือ"),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("เป้าหมายประจำวัน"),
    "delete" : MessageLookupByLibrary.simpleMessage("ลบ"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("อุปกรณ์นี้ไม่มีภาพถ่ายในคลังภาพจึงไม่สามารถติดแท็กภาพถ่ายได้"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("แก้ไขแท็ก"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("ส่งออกไปที่คลังภาพได้ทั้งหมด"),
    "export_library" : MessageLookupByLibrary.simpleMessage("ส่งออกคลังภาพ"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("ครอบครัว"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("อาหาร"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("เต็มจอ"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("การให้สิทธิ์เข้าถึงข้อมูล"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("แอปจำเป็นต้องได้รับอนุญาตการเข้าถึงข้อมูลเพื่อเริ่มขั้นตอนการจัดหมวดหมู่ภาพถ่าย"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("แอปจำเป็นต้องเข้าถึงคลังภาพเพื่อจัดหมวดหมู่ภาพถ่าย"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("เพื่อใช้คุณสมบัติทั้งหมดนี้"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("เปลี่ยนไปใช้แบบพรีเมียมเลยตอนนี้!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("เปลี่ยนไปเป็นพรีเมียม"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("บ้าน"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("มีภาพถ่ายเท่าไร"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("แท็กแบบอินฟินิตี้"),
    "language" : MessageLookupByLibrary.simpleMessage("ภาษา"),
    "month" : MessageLookupByLibrary.simpleMessage("เดือน"),
    "next" : MessageLookupByLibrary.simpleMessage("ต่อไป"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("ไร้โฆษณา"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("ไม่มีการสั่งซื้อครั้งก่อนหน้า"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("คุณยังไม่มีภาพถ่ายที่ติดแท็ก"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("ไม่พบแท็ก"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("ไม่พบการสมัครสมาชิกที่ใช้งานได้"),
    "notification_time" : MessageLookupByLibrary.simpleMessage("เวลาแจ้งเตือน"),
    "notifications" : MessageLookupByLibrary.simpleMessage("การแจ้งเตือน"),
    "ok" : MessageLookupByLibrary.simpleMessage("ตกลง"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("เปิดคลังภาพ"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("ภาพถ่ายติดแท็กแล้ว"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("ภาพถ่ายที่จัดหมวดหมู่แล้ว"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("ปาร์ตี้"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("สัตว์เลี้ยง"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("ภาพถ่ายที่ยังไม่ได้รับการจัดหมวดหมู่"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("คลังภาพ"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("สถานที่ที่ถ่ายภาพนี้"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("จากนี้ภาพถ่ายของคุณจะไม่กระจัดกระจายอีกต่อไปแล้ว"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ใช้ทุกคุณสมบัติแบบไร้โฆษณา"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("เปลี่ยนเป็นบัญชีแบบพรีเมียม"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("ดูวิดีโอโฆษณาเพื่อไปต่อ"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("นโยบายความเป็นส่วนตัว"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("ให้คะแนนแอป"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("เรียกการซื้อคืน"),
    "save" : MessageLookupByLibrary.simpleMessage("บันทึก"),
    "save_location" : MessageLookupByLibrary.simpleMessage("บันทึกตำแหน่ง"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("สกรีนช็อต"),
    "search" : MessageLookupByLibrary.simpleMessage("ค้นหา..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("ไม่พบรูปภาพพร้อมแท็กทั้งหมดในนั้น"),
    "search_results" : MessageLookupByLibrary.simpleMessage("ผลการค้นหา"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("เซลฟี่"),
    "settings" : MessageLookupByLibrary.simpleMessage("การตั้งค่า"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("แชร์ให้เพื่อนดู"),
    "sign" : MessageLookupByLibrary.simpleMessage("ลงทะเบียบใช้แบบ"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("กีฬา"),
    "start" : MessageLookupByLibrary.simpleMessage("เริ่ม"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("เริ่มติดแท็กภาพถ่าย"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("แนะนำ"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("ติดแท็กภาพถ่ายหลายภาพในครั้งเดียว"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("ดูแอปนี้!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("ข้อกำหนดการใช้งาน"),
    "time" : MessageLookupByLibrary.simpleMessage("เวลา"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("ท่องเที่ยว"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("เราเตรียมแพ็คเก็จประจำวันไว้ให้เพื่อที่คุณจะได้ค่อยๆจัดหมวดหมู่ในคลังไปเรื่อยๆ"),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("จัดหมวดหมู่ภาพด้วยการติดแท็ก อย่างเช่น \'ครอบครัว\' \'สัตว์เลี้ยง\' หรืออะไรก็ได้ที่คุณต้องการ"),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("หลังจากเพิ่มแท็กแล้วก็แค่ปัดไปที่ภาพต่อไป"),
    "welcome" : MessageLookupByLibrary.simpleMessage("ยินดีต้อนรับ!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("ที่ทำงาน"),
    "year" : MessageLookupByLibrary.simpleMessage("ปี"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("คุณคือชาวพรีเมียม!")
  };
}

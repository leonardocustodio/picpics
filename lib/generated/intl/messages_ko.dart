// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
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
  String get localeName => 'ko';

  static m0(email) => "${email}으로 액세스 키를 보냈습니다.";

  static m1(howMany) => "${Intl.plural(howMany, zero: '선택된 사진이 없습니다', one: '사진 1장이 선택됨', other: '사진 ${howMany}장이 선택됨')}";

  static m2(number) => "${number} 무료 일일 사진을 완성했습니다. 계속 하시겠습니까?";

  static m3(url) => "모든 사진을 정리정돈하려면 ${url}로 이동하십시오.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "access_code" : MessageLookupByLibrary.simpleMessage("액세스 코드"),
    "access_code_sent" : m0,
    "add_multiple_tags" : MessageLookupByLibrary.simpleMessage("다수의 태그 추가"),
    "add_tag" : MessageLookupByLibrary.simpleMessage("태그 추가"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("태그 추가"),
    "all_at_once" : MessageLookupByLibrary.simpleMessage("한 번에 여러 장의 사진 정리"),
    "all_photos_were_tagged" : MessageLookupByLibrary.simpleMessage("There are no more photos to organize."),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("모든 검색 태그"),
    "always" : MessageLookupByLibrary.simpleMessage("항상"),
    "ask_photo_library_permission" : MessageLookupByLibrary.simpleMessage("picPics로 사진 정리를 시작하려면 사진 라이브러리에 액세스해야합니다. 데이터가 장치를 떠나지 않을 것이라고 걱정하지 마십시오!"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("구독은"),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("자동 갱신 가능."),
    "cancel" : MessageLookupByLibrary.simpleMessage("취소"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("언제든지 취소 가능"),
    "close" : MessageLookupByLibrary.simpleMessage("닫기"),
    "confirm_email" : MessageLookupByLibrary.simpleMessage("액세스 코드를 받으려면 등록 이메일을 확인하세요."),
    "confirm_secret_key" : MessageLookupByLibrary.simpleMessage("비밀 키 확인"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("계속"),
    "country" : MessageLookupByLibrary.simpleMessage("국가"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("일일 챌린지"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("저희가 매일 챌린지를 보내려면 알림을 보낼 수있는 권한이 필요하므로 휴대 전화 옵션에서 알림을 승인해야합니다."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("일일 목표"),
    "daily_notification_description" : MessageLookupByLibrary.simpleMessage("It\'s time to complete your picPics daily challenge!"),
    "daily_notification_title" : MessageLookupByLibrary.simpleMessage("Daily challenge"),
    "delete" : MessageLookupByLibrary.simpleMessage("삭제"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("이 기기에는 갤러리에 사진이 없으므로 태그를 지정할 수 있는 사진이 없습니다."),
    "disable_secret" : MessageLookupByLibrary.simpleMessage("이 사진의 숨김을 해제하시겠습니까?"),
    "dont_ask_again" : MessageLookupByLibrary.simpleMessage("다시 묻지 않기"),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("태그 편집"),
    "email" : MessageLookupByLibrary.simpleMessage("이메일"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("모든 갤러리 내보내기"),
    "export_library" : MessageLookupByLibrary.simpleMessage("라이브러리 내보내기"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("가족"),
    "feedback_bug_report" : MessageLookupByLibrary.simpleMessage("피드백 및 버그 신고"),
    "find_easily" : MessageLookupByLibrary.simpleMessage("쉽게 사진 찾기"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("음식"),
    "forgot_secret_key" : MessageLookupByLibrary.simpleMessage("비밀 키를 잊으셨나요?"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("전체 화면"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("액세스 권한"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("사진 정리정돈을 시작하려면 사진에 액세스 할 수 있는 권한이 필요합니다"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("사진을 정리정돈하려면 사진 갤러리에 액세스해야 합니다"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("이 모든 기능을 사용할 수 있습니다"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("지금 프리미엄 가입하기!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("프리미엄 가입하기"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("집"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("사진 장수"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("무한 태그"),
    "keep_asking" : MessageLookupByLibrary.simpleMessage("계속 물어보기"),
    "keep_safe" : MessageLookupByLibrary.simpleMessage("이제 picPics에서 사진이 안전합니다. 카메라 롤에서 삭제하시겠습니까?"),
    "language" : MessageLookupByLibrary.simpleMessage("언어"),
    "lock_with_pin" : MessageLookupByLibrary.simpleMessage("PIN 암호로 개인 사진을 잠급니다."),
    "lock_your_photos" : MessageLookupByLibrary.simpleMessage("사진 잠금"),
    "month" : MessageLookupByLibrary.simpleMessage("월"),
    "new_secret_key" : MessageLookupByLibrary.simpleMessage("새로운 비밀 키"),
    "next" : MessageLookupByLibrary.simpleMessage("다음"),
    "no" : MessageLookupByLibrary.simpleMessage("아니요"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("광고 없음"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("이전 구매가 없습니다"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("아직 태그된 사진이 없습니다"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("태그를 찾을 수 없습니다"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("유효한 구독 구매를 찾을 수 없습니다."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("알림 시간"),
    "notifications" : MessageLookupByLibrary.simpleMessage("알림"),
    "ny_tag" : MessageLookupByLibrary.simpleMessage("NY"),
    "ok" : MessageLookupByLibrary.simpleMessage("확인"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("오픈 갤러리"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("이미 태그된 사진"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("정리된 사진"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("파티"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("반려 동물"),
    "photo_gallery_count" : m1,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("아직 정리되지 않은 사진"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("사진 갤러리"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("사진 위치"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("이제 항상 사진을 정리정돈할 수 있습니다"),
    "picpics_photo_manager" : MessageLookupByLibrary.simpleMessage("picPics - 사진 관리자"),
    "premium_modal_description" : m2,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("ADS가 없는 모든 기능"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("프리미엄 계정 가입"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("계속하려면 비디오 광고를 시청하세요"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("개인정보 보호정책"),
    "private_photos" : MessageLookupByLibrary.simpleMessage("개인 사진"),
    "protect_with_encryption" : MessageLookupByLibrary.simpleMessage("PIN 암호로만 액세스할 수있는 암호화로 개인 사진을 보호하십시오."),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("이 앱을 평가해주십시오"),
    "recent_tags" : MessageLookupByLibrary.simpleMessage("최근 태그"),
    "require_secret_key" : MessageLookupByLibrary.simpleMessage("비밀 키가 필요합니다"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("구매 복원"),
    "save" : MessageLookupByLibrary.simpleMessage("저장"),
    "save_location" : MessageLookupByLibrary.simpleMessage("위치 저장"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("스크린샷"),
    "search" : MessageLookupByLibrary.simpleMessage("검색..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("모든 태그가 있는 사진을 찾을 수 없습니다."),
    "search_results" : MessageLookupByLibrary.simpleMessage("검색 결과"),
    "secret_key_created" : MessageLookupByLibrary.simpleMessage("비밀 키가 생성되었습니다!"),
    "secret_photos" : MessageLookupByLibrary.simpleMessage("비밀 사진"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("셀카"),
    "settings" : MessageLookupByLibrary.simpleMessage("설정"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("친구들과 공유"),
    "sign" : MessageLookupByLibrary.simpleMessage("사인"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("스포츠"),
    "start" : MessageLookupByLibrary.simpleMessage("시작"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("태그 시작"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("제안"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("한 번에 여러 장의 사진에 태그 달기"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("이 앱을 살펴보세요!"),
    "take_a_look_description" : m3,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("이용 약관"),
    "time" : MessageLookupByLibrary.simpleMessage("시간"),
    "toggle_date" : MessageLookupByLibrary.simpleMessage("날짜 별"),
    "toggle_days" : MessageLookupByLibrary.simpleMessage("일"),
    "toggle_months" : MessageLookupByLibrary.simpleMessage("월"),
    "toggle_tags" : MessageLookupByLibrary.simpleMessage("태그"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("여행"),
    "tsqr_tag" : MessageLookupByLibrary.simpleMessage("타임 스퀘어"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("라이브러리를 꾸준히 정리정돈할 수 있도록 매일 패키지를 준비합니다."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("\'가족\', \'반려동물\' 등 원하는 태그를 추가하여 사진을 정리정돈하십시오."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("사진에 태그를 추가한 후 스와이프하면 다음 태그로 이동합니다."),
    "unlimited_private_pics" : MessageLookupByLibrary.simpleMessage("무제한 개인 사진"),
    "vacation_tag" : MessageLookupByLibrary.simpleMessage("휴가"),
    "view_hidden_photos" : MessageLookupByLibrary.simpleMessage("숨겨진 사진을 보려면, 앱 설정에서 잠금을 해제하십시오. PIN으로 잠금 해제할 수 있습니다."),
    "welcome" : MessageLookupByLibrary.simpleMessage("환영합니다!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("직장"),
    "x_minutes" : MessageLookupByLibrary.simpleMessage("20분"),
    "year" : MessageLookupByLibrary.simpleMessage("년"),
    "yes" : MessageLookupByLibrary.simpleMessage("예"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("귀하는 프리미엄 고객입니다!"),
    "your_secret_key" : MessageLookupByLibrary.simpleMessage("내 비밀 키")
  };
}

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hi locale. All the
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
  String get localeName => 'hi';

  static m0(email) => "एक पहुंच कुंजी ${email} पर भेजी गई थी";

  static m1(howMany) =>
      "${Intl.plural(howMany, zero: 'कोई फ़ोटो नहीं चुना गया', one: '1 फ़ोटो चयनित', other: '${howMany} फ़ोटो चयनित')}";

  static m2(number) =>
      "आपने अपनी ${number} निःशुल्क दैनिक तस्वीरें पूरी कर ली हैं, क्या आप जारी रखना चाहते हैं?";

  static m3(url) => "अपनी सभी तस्वीरों को व्यवस्थित करने के लिए ${url} पर जाएं";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "access_code": MessageLookupByLibrary.simpleMessage("एक्सेस कोड"),
        "access_code_sent": m0,
        "add_multiple_tags":
            MessageLookupByLibrary.simpleMessage("अनंत टैग जोड़ें"),
        "add_tag": MessageLookupByLibrary.simpleMessage("टैग जोड़ो"),
        "add_tags": MessageLookupByLibrary.simpleMessage("टैग लगा दो"),
        "all_at_once": MessageLookupByLibrary.simpleMessage(
            "एक साथ कई फ़ोटो व्यवस्थित करें"),
        "all_photos_were_tagged": MessageLookupByLibrary.simpleMessage(
            "There are no more photos to organize."),
        "all_search_tags": MessageLookupByLibrary.simpleMessage("सभी खोज टैग"),
        "always": MessageLookupByLibrary.simpleMessage("हमेशा"),
        "ask_photo_library_permission": MessageLookupByLibrary.simpleMessage(
            "हमें आपकी फोटो लाइब्रेरी तक पहुंचने की आवश्यकता है ताकि आप अपनी तस्वीरों को पिकनिक के साथ व्यवस्थित करना शुरू कर सकें। चिंता न करें कि आपका डेटा आपके डिवाइस को कभी नहीं छोड़ेगा!"),
        "auto_renewable_first_part":
            MessageLookupByLibrary.simpleMessage("सदस्यता है "),
        "auto_renewable_second_part":
            MessageLookupByLibrary.simpleMessage("ऑटो-नवीकरणीय"),
        "cancel": MessageLookupByLibrary.simpleMessage("रद्द करें"),
        "cancel_anytime":
            MessageLookupByLibrary.simpleMessage("कभी भी रद्द करें"),
        "close": MessageLookupByLibrary.simpleMessage("बंद करें"),
        "confirm_email": MessageLookupByLibrary.simpleMessage(
            "अपना एक्सेस कोड प्राप्त करने के लिए अपने पंजीकरण ईमेल की पुष्टि करें"),
        "confirm_secret_key":
            MessageLookupByLibrary.simpleMessage("गुप्त कुंजी की पुष्टि करें"),
        "continue_string": MessageLookupByLibrary.simpleMessage("जारी रखें"),
        "country": MessageLookupByLibrary.simpleMessage("देश"),
        "daily_challenge": MessageLookupByLibrary.simpleMessage("दैनिक चुनौती"),
        "daily_challenge_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "हमें आपकी दैनिक चुनौतियों को भेजने में सक्षम होने के लिए, हमें सूचनाएं भेजने के लिए प्राधिकरण की आवश्यकता है, इसलिए, यह आवश्यक है कि आप अपने सेल फोन के विकल्पों में सूचनाओं को अधिकृत करें."),
        "daily_goal": MessageLookupByLibrary.simpleMessage("दैनिक लक्ष्य"),
        "daily_notification_description": MessageLookupByLibrary.simpleMessage(
            "It\'s time to complete your picPics daily challenge!"),
        "daily_notification_title":
            MessageLookupByLibrary.simpleMessage("Daily challenge"),
        "delete": MessageLookupByLibrary.simpleMessage("हटाएं"),
        "device_has_no_pics": MessageLookupByLibrary.simpleMessage(
            "इस डिवाइस में गैलरी में कोई फोटो नहीं है, इसलिए कोई भी फोटो नहीं है जिसे टैग किया जा सके."),
        "disable_secret": MessageLookupByLibrary.simpleMessage(
            "क्या आप इस फ़ोटो को अनहाइड करना चाहते हैं?"),
        "dont_ask_again":
            MessageLookupByLibrary.simpleMessage("फिर से मत पूछो"),
        "edit_tag": MessageLookupByLibrary.simpleMessage("टैग संपादित करें"),
        "email": MessageLookupByLibrary.simpleMessage("ईमेल"),
        "enable_faceid": MessageLookupByLibrary.simpleMessage("Face ID सक्षम"),
        "enable_fingerprint":
            MessageLookupByLibrary.simpleMessage("फिंगरप्रिंट सक्षम करें"),
        "enable_irisscanner":
            MessageLookupByLibrary.simpleMessage("आईरिस स्कैनर सक्षम करें"),
        "enable_touchid":
            MessageLookupByLibrary.simpleMessage("Touch ID सक्षम"),
        "export_all_gallery":
            MessageLookupByLibrary.simpleMessage("सभी गैलरी निर्यात करें"),
        "export_library":
            MessageLookupByLibrary.simpleMessage("निर्यात लाइब्रेरी"),
        "family_tag": MessageLookupByLibrary.simpleMessage("परिवार"),
        "feedback_bug_report":
            MessageLookupByLibrary.simpleMessage("प्रतिक्रिया और बग रिपोर्ट"),
        "find_easily": MessageLookupByLibrary.simpleMessage(
            "आसानी से अपनी तस्वीरें खोजें"),
        "foods_tag": MessageLookupByLibrary.simpleMessage("फूड्स"),
        "forgot_secret_key":
            MessageLookupByLibrary.simpleMessage("गुप्त कुंजी भूल गए?"),
        "full_screen": MessageLookupByLibrary.simpleMessage("पूर्ण स्क्रीन"),
        "gallery_access_permission":
            MessageLookupByLibrary.simpleMessage("पहुंच की अनुमति"),
        "gallery_access_permission_description":
            MessageLookupByLibrary.simpleMessage(
                "अपनी तस्वीरों को व्यवस्थित करने के लिए, हमें उन्हें एक्सेस करने के लिए प्राधिकरण की आवश्यकता है"),
        "gallery_access_reason": MessageLookupByLibrary.simpleMessage(
            "अपनी तस्वीरों को व्यवस्थित करने के लिए हमें आपकी फोटो गैलरी तक पहुंचने की आवश्यकता है"),
        "get_premium_description":
            MessageLookupByLibrary.simpleMessage("सभी फीचर्स हैं"),
        "get_premium_now":
            MessageLookupByLibrary.simpleMessage("अब प्रीमियम प्राप्त करें!"),
        "get_premium_title":
            MessageLookupByLibrary.simpleMessage("प्रीमियम प्राप्त करें"),
        "home_tag": MessageLookupByLibrary.simpleMessage("घर"),
        "how_many_pics": MessageLookupByLibrary.simpleMessage("कितने पिक्स"),
        "infinite_tags": MessageLookupByLibrary.simpleMessage("अनंत टैग"),
        "keep_asking": MessageLookupByLibrary.simpleMessage("पूछते रहो"),
        "keep_safe": MessageLookupByLibrary.simpleMessage(
            "आपकी तस्वीर अब पिकनिक पर सुरक्षित है. क्या आप इसे अपने कैमरा रोल से हटाना चाहते हैं?"),
        "language": MessageLookupByLibrary.simpleMessage("भाषा"),
        "lock_with_pin": MessageLookupByLibrary.simpleMessage(
            "पिन पासकोड के साथ अपनी निजी तस्वीरें लॉक करें."),
        "lock_your_photos":
            MessageLookupByLibrary.simpleMessage("अपनी तस्वीरों को लॉक करें"),
        "month": MessageLookupByLibrary.simpleMessage("महीना"),
        "new_secret_key":
            MessageLookupByLibrary.simpleMessage("नई गुप्त कुंजी"),
        "next": MessageLookupByLibrary.simpleMessage("आगे"),
        "no": MessageLookupByLibrary.simpleMessage("नहीं"),
        "no_ads": MessageLookupByLibrary.simpleMessage("विज्ञापन नहीं"),
        "no_previous_purchase":
            MessageLookupByLibrary.simpleMessage("कोई पिछली खरीद नहीं"),
        "no_tagged_photos": MessageLookupByLibrary.simpleMessage(
            "आपके पास अभी तक कोई टैग फ़ोटो नहीं है"),
        "no_tags_found":
            MessageLookupByLibrary.simpleMessage("कोई टैग नहीं मिला"),
        "no_valid_subscription": MessageLookupByLibrary.simpleMessage(
            "मान्य सदस्यता खरीद नहीं मिली."),
        "notification_time":
            MessageLookupByLibrary.simpleMessage("अधिसूचना का समय"),
        "notifications": MessageLookupByLibrary.simpleMessage("सूचनाएं"),
        "ny_tag": MessageLookupByLibrary.simpleMessage("न्यूयॉर्क"),
        "ok": MessageLookupByLibrary.simpleMessage("ठीक है"),
        "open_gallery": MessageLookupByLibrary.simpleMessage("गैलरी खोलें"),
        "organized_photos_description": MessageLookupByLibrary.simpleMessage(
            "तस्वीरें जो पहले ही टैग की जा चुकी हैं"),
        "organized_photos_title":
            MessageLookupByLibrary.simpleMessage("आयोजित फोटो"),
        "parties_tag": MessageLookupByLibrary.simpleMessage("दल"),
        "pets_tag": MessageLookupByLibrary.simpleMessage("पालतू जानवर"),
        "photo_gallery_count": m1,
        "photo_gallery_description": MessageLookupByLibrary.simpleMessage(
            "तस्वीरें अभी तक व्यवस्थित नहीं हैं"),
        "photo_gallery_title":
            MessageLookupByLibrary.simpleMessage("चित्र प्रदर्शनी"),
        "photo_location": MessageLookupByLibrary.simpleMessage("फोटो स्थान"),
        "photos_always_organized": MessageLookupByLibrary.simpleMessage(
            "अब आपकी तस्वीरें हमेशा व्यवस्थित रहेंगी"),
        "picpics_photo_manager":
            MessageLookupByLibrary.simpleMessage("पिकपिक्स - फोटो मैनेजर"),
        "premium_modal_description": m2,
        "premium_modal_get_premium_description":
            MessageLookupByLibrary.simpleMessage(
                "विज्ञापन के बिना सभी विशेषताएं"),
        "premium_modal_get_premium_title":
            MessageLookupByLibrary.simpleMessage("प्रीमियम खाता प्राप्त करें"),
        "premium_modal_watch_ad": MessageLookupByLibrary.simpleMessage(
            "जारी रखने के लिए वीडियो विज्ञापन देखें"),
        "privacy_policy": MessageLookupByLibrary.simpleMessage("गोपनीयता नीति"),
        "private_photos": MessageLookupByLibrary.simpleMessage("निजी तस्वीरें"),
        "protect_with_encryption": MessageLookupByLibrary.simpleMessage(
            "केवल पिन पासवर्ड के साथ पहुंच योग्य एन्क्रिप्शन वाली अपनी निजी फ़ोटो को सुरक्षित रखें."),
        "rate_this_app":
            MessageLookupByLibrary.simpleMessage("इस ऐप्लिकेशन को रेट करें"),
        "recent_tags": MessageLookupByLibrary.simpleMessage("हाल का टैग"),
        "require_secret_key":
            MessageLookupByLibrary.simpleMessage("गुप्त कुंजी की आवश्यकता है"),
        "restore_purchase":
            MessageLookupByLibrary.simpleMessage("पुनःस्थापन क्रय"),
        "save": MessageLookupByLibrary.simpleMessage("सहेजें"),
        "save_location": MessageLookupByLibrary.simpleMessage("स्थान सहेजें"),
        "screenshots_tag": MessageLookupByLibrary.simpleMessage("स्क्रीनशॉटस"),
        "search": MessageLookupByLibrary.simpleMessage("खोज..."),
        "search_all_tags_not_found": MessageLookupByLibrary.simpleMessage(
            "इस पर सभी टैग के साथ कोई चित्र नहीं मिला"),
        "search_results": MessageLookupByLibrary.simpleMessage("खोज परिणाम"),
        "secret_key_created": MessageLookupByLibrary.simpleMessage(
            "गुप्त कुंजी सफलतापूर्वक बनाई गई!"),
        "secret_photos": MessageLookupByLibrary.simpleMessage("गुप्त तस्वीरें"),
        "selfies_tag": MessageLookupByLibrary.simpleMessage("सेल्फ़ीज़"),
        "settings": MessageLookupByLibrary.simpleMessage("समायोजन"),
        "share_with_friends":
            MessageLookupByLibrary.simpleMessage("दोस्तों के साथ बांटें"),
        "sign": MessageLookupByLibrary.simpleMessage("संकेत"),
        "sports_tag": MessageLookupByLibrary.simpleMessage("खेल"),
        "start": MessageLookupByLibrary.simpleMessage("शुरू करें"),
        "start_tagging":
            MessageLookupByLibrary.simpleMessage("टैग करना शुरू करें"),
        "suggestions": MessageLookupByLibrary.simpleMessage("सुझाव"),
        "tag_multiple_photos_at_once":
            MessageLookupByLibrary.simpleMessage("एक साथ कई फ़ोटो टैग करें"),
        "take_a_look":
            MessageLookupByLibrary.simpleMessage("इस ऐप पर एक नज़र डालें!"),
        "take_a_look_description": m3,
        "terms_of_use": MessageLookupByLibrary.simpleMessage("उपयोग की शर्तें"),
        "time": MessageLookupByLibrary.simpleMessage("समय"),
        "toggle_date": MessageLookupByLibrary.simpleMessage("दिनांक"),
        "toggle_days": MessageLookupByLibrary.simpleMessage("दिन"),
        "toggle_months": MessageLookupByLibrary.simpleMessage("महीने"),
        "toggle_tags": MessageLookupByLibrary.simpleMessage("टैग"),
        "travel_tag": MessageLookupByLibrary.simpleMessage("यात्रा"),
        "tsqr_tag": MessageLookupByLibrary.simpleMessage("टाइम्स स्क्वायर"),
        "tutorial_daily_package": MessageLookupByLibrary.simpleMessage(
            "हम धीरे-धीरे आपके पुस्तकालय को व्यवस्थित करने के लिए एक दैनिक पैकेज लाते हैं."),
        "tutorial_however_you_want": MessageLookupByLibrary.simpleMessage(
            "टैग जोड़कर अपनी तस्वीरों को व्यवस्थित करें, जैसे \'परिवार\', \'पालतू जानवर\', या जो भी आप चाहते हैं."),
        "tutorial_just_swipe": MessageLookupByLibrary.simpleMessage(
            "अपनी फ़ोटो में टैग जोड़ने के बाद, बस अगले एक पर जाने के लिए स्वाइप करें."),
        "tutorial_multiselect": MessageLookupByLibrary.simpleMessage(
            "आप एक साथ कई फ़ोटो टैग करने के लिए अपनी तस्वीरों पर \"टैप और होल्ड\" कर सकते हैं।"),
        "tutorial_secret": MessageLookupByLibrary.simpleMessage(
            "अपनी निजी तस्वीरों को पिन कोड सुरक्षा के साथ छिपाएं, उन्हें सुरक्षित रखें।"),
        "unlimited_private_pics":
            MessageLookupByLibrary.simpleMessage("असीमित निजी तस्वीरें"),
        "vacation_tag": MessageLookupByLibrary.simpleMessage("छुट्टी"),
        "view_hidden_photos": MessageLookupByLibrary.simpleMessage(
            "अपनी छिपी तस्वीरों को देखने के लिए, एप्लिकेशन सेटिंग में लॉक जारी करें। आप उन्हें अपने पिन से अनलॉक कर सकते हैं"),
        "welcome": MessageLookupByLibrary.simpleMessage("स्वागत!"),
        "work_tag": MessageLookupByLibrary.simpleMessage("काम"),
        "x_minutes": MessageLookupByLibrary.simpleMessage("बीस मिनट"),
        "year": MessageLookupByLibrary.simpleMessage("साल"),
        "yes": MessageLookupByLibrary.simpleMessage("हाँ"),
        "you_are_premium":
            MessageLookupByLibrary.simpleMessage("आप प्रीमियम हैं!"),
        "your_secret_key":
            MessageLookupByLibrary.simpleMessage("आपकी गुप्त कुंजी")
      };
}

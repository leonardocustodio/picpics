import 'package:flutter/material.dart';

const List<int> kDefaultPhotoSize = <int>[600, 600];
const List<int> kDefaultPreviewThumbSize = <int>[100, 100];

final greyWidget = Padding(
  padding: const EdgeInsets.all(2),
  child: Container(
    padding: const EdgeInsets.all(10),
    color: Colors.grey[300],
  ),
);

const kMaxNumOfSuggestions = 6;
const kMaxNumOfRecentTags = 5;

const kSecretTagKey = 'XXXXXXXXXYYYYYYYYYZZZZZZZZZZZZ';
List<String> kRequireOptions = [
  'Immediately',
  '30 seconds',
  '1 minute',
  '2 minutes',
  '3 minutes',
  '4 minutes',
  '5 minutes'
];

const kPrimaryColor = Color(0xFF52CECE);
const kSecondaryColor = Color(0xFFFF6666);
const kYellowColor = Color(0xFFFEE067);
const kPinkColor = Color(0xFFEC56A1);
const kSuccessColor = Color(0xFF70FF98);
const kAlertColor = Color(0xFFF68C0F);
const kWarningColor = Color(0xFFE01717);
const kWhiteColor = Color(0xFFF5FAFA);
const kGrayColor = Color(0xffbfc2c3);
const kLightGrayColor = Color(0xffe2e4e5);
const kGreyPlaceholder = Color(0xFFE0E0E0);

const kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF52CECE),
    Color(0xFF6BC9DB),
  ],
);

const kSecondaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFFF6666),
    Color(0xFFFF7878),
  ],
);

const kCardYellowGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFDFB300),
    Color(0xFFFFD93F),
  ],
);

const kPinkGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFEC56A1),
    Color(0xFFED74B1),
  ],
);

const kYellowGradient = LinearGradient(
  begin: Alignment(-0.07, -0.3),
  end: Alignment(1.2, 1.05),
  colors: [
    Color.fromRGBO(232, 191, 27, 0.7),
    Color.fromRGBO(242, 206, 59, 0.7),
  ],
);

var kGrayBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(19.0),
  border: Border.all(
    color: Color(0xff979a9b),
  ),
);

const kWhiteTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: kWhiteColor,
  fontSize: 12,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

const kGrayTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: Color(0xff979a9b),
  fontSize: 12,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

const kGraySettingsFieldTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: Color(0xff606566),
  fontSize: 12,
  fontWeight: FontWeight.w300,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

const kGraySettingsValueTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: Color(0xff606566),
  fontSize: 18,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
);

const kGraySettingsBoldTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: Color(0xff979a9b),
  fontSize: 16,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

const kBottomSheetTextStyle = TextStyle(
  color: Color(0xff707070),
  fontSize: 14,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w700,
);

const kBottomSheetTitleTextStyle = TextStyle(
  color: Color(0xff707070),
  fontSize: 19,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w300,
);

const kPremiumButtonTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: kPinkColor,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

const kLoginDescriptionTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: kWhiteColor,
  fontSize: 28,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
);

const kLoginButtonTextStyle = TextStyle(
  fontFamily: 'Lato',
  color: Color(0xfff5fafa),
  fontSize: 16,
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
  letterSpacing: -0.4099999964237213,
);

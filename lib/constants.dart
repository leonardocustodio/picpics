import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF52CECE);
const kSecondaryColor = Color(0xFFFF6666);
const kYellowColor = Color(0xFFFEE067);
const kPinkColor = Color(0xFFF1be5CA7);
const kSucessColor = Color(0xFF70FF98);
const kAlertColor = Color(0xFFF68C0F);
const kWarningColor = Color(0xFFE01717);
const kWhiteColor = Color(0xFFF5FAFA);
const kGrayColor = const Color(0xffbfc2c3);
const kLightGrayColor = const Color(0xffe2e4e5);

const kPrimaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color(0xFF52CECE),
    const Color(0xFF6BC9DB),
  ],
);

const kSecondaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color(0xFFFF6666),
    const Color(0xFFFF7878),
  ],
);

const kCardYellowGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color(0xFFDFB300),
    const Color(0xFFFFD93F),
  ],
);

const kPinkGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    const Color(0xFFEC56A1),
    const Color(0xFFED74B1),
  ],
);

const kYellowGradient = LinearGradient(
  begin: Alignment(-0.07, -0.3),
  end: Alignment(1.2, 1.05),
  colors: [
    const Color.fromRGBO(232, 191, 27, 0.7),
    const Color.fromRGBO(242, 206, 59, 0.7),
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
  fontSize: 16,
  fontFamily: 'Lato',
  fontWeight: FontWeight.w700,
);

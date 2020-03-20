import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF52CECE);
const kSecondaryColor = Color(0xFFFF6666);
const kYellowColor = Color(0xFFFEE067);
const kPinkColor = Color(0xFFCC0066);
const kSucessColor = Color(0xFF70FF98);
const kAlertColor = Color(0xFFF68C0F);
const kWarningColor = Color(0xFFE01717);
const kWhiteColor = Color(0xFFF5FAFA);
const kGrayColor = const Color(0xffbfc2c3);

const kPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xFF52CECE),
    const Color(0xFF6BC9DB),
  ],
);

const kSecondaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xFFFF6666),
    const Color(0xFFFF7878),
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

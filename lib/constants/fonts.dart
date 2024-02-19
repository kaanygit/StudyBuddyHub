import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Open Serif Bold

final Color backgroundColor = Color(0xFFf4f7fb);
final Color backgroundColorTwo = Color(0xFFF6F7F6);
final Color textColor = Color(0xFF8526fa);
final Color textColorTwo = Color(0xFF7b63fb);
final Color textColorThree = Color(0xFF808080);
final Color geminiTextColor = Color(0xFF177AFF);
final Color textColorFour = Color(0xFF2B4C84);

TextStyle fontStyle(double fontSizes, Color fontColor, FontWeight fontWeights) {
  return GoogleFonts.openSans(
      fontSize: fontSizes, color: fontColor, fontWeight: fontWeights);
}

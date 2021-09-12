import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryColor = Color(0xFFFFFFFF);
const Color kSecondaryColor = Color(0xFF333333);

const Color kDarkPrimaryColor = Color(0xFF0C1014);
const Color kDarkSecondaryColor = kPrimaryColor;

final TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.poppins(
    fontSize: 93,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
    color: Colors.black.withOpacity(0.85),
  ),
  headline2: GoogleFonts.poppins(
    fontSize: 58,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
    color: Colors.black.withOpacity(0.85),
  ),
  headline3: GoogleFonts.poppins(
    fontSize: 46,
    fontWeight: FontWeight.w400,
  ),
  headline4: GoogleFonts.poppins(
    fontSize: 33,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Colors.black.withOpacity(0.85),
  ),
  headline5: GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.85),
  ),
  headline6: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: Colors.black.withOpacity(0.85),
  ),
  subtitle1: GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: Colors.black.withOpacity(0.85),
  ),
  subtitle2: GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black.withOpacity(0.85),
  ),
  bodyText1: GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: Colors.black.withOpacity(0.60),
  ),
  bodyText2: GoogleFonts.openSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Colors.black.withOpacity(0.60),
  ),
  button: GoogleFonts.openSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.openSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: Colors.black.withOpacity(0.60),
  ),
  overline: GoogleFonts.openSans(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: Colors.black.withOpacity(0.50),
  ),
);

final ThemeData lightTheme = ThemeData(
  primaryColor: kPrimaryColor,
  accentColor: kSecondaryColor,
  scaffoldBackgroundColor: kPrimaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    textTheme: TextTheme(subtitle1: textTheme.subtitle1),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: kDarkPrimaryColor,
    unselectedItemColor: Colors.grey,
  ),
  cardColor: kPrimaryColor,
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: kDarkPrimaryColor,
  accentColor: kDarkSecondaryColor,
  scaffoldBackgroundColor: kDarkPrimaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme:
      textTheme.apply(displayColor: kPrimaryColor, bodyColor: kPrimaryColor),
  appBarTheme: AppBarTheme(
    textTheme:
        textTheme.apply(displayColor: kPrimaryColor, bodyColor: kPrimaryColor),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0D1015),
    selectedItemColor: kDarkSecondaryColor,
    unselectedItemColor: Colors.grey,
  ),
  cardColor: const Color(0xFF141921),
);

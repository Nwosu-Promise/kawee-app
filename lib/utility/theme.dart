import 'package:flutter/material.dart';
import 'colours.dart';

final ThemeData buildTheme = _builderTheme();

ThemeData _builderTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    accentColor: secondaryColor,
    primaryColor: primaryColour,
    secondaryHeaderColor: primaryColour,
    appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        color: primaryColour,
        iconTheme: base.iconTheme.copyWith(color: white, size: 20),
        textTheme: base.textTheme.copyWith(
            title: TextStyle(
          color: black87,
        ))),

    iconTheme: IconThemeData(color: white, size: 20),
    buttonTheme: ButtonThemeData(
        buttonColor: primaryColour,
        disabledColor: disablePrimaryColour,
       // shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary),
    bottomAppBarTheme: BottomAppBarTheme(color: black54, elevation: 2),
    scaffoldBackgroundColor: bgWhite,
    tabBarTheme: TabBarTheme(
      labelColor: white,
      unselectedLabelColor: black54,
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: primaryColour),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    ),
  );
}

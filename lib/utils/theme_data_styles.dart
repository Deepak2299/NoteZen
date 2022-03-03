import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    print(isDarkTheme);
    return ThemeData(
//      primarySwatch: isDarkTheme ? Colors.red : Colors.white,
      primaryColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
//      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      scaffoldBackgroundColor: isDarkTheme ? Color(0xff303030) : Colors.white,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primaryColorDark: isDarkTheme ? Colors.grey[300] : Colors.grey[800],
      primaryColorLight: isDarkTheme ? Colors.grey[800] : Colors.white,
      secondaryHeaderColor: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
      shadowColor: isDarkTheme ? Color(0xff282828) : Colors.grey[200],
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,

      appBarTheme: isDarkTheme
          ? AppBarTheme(
              brightness: Brightness.dark,
              color: Colors.grey[900],
              elevation: 2,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              actionsIconTheme: IconThemeData(color: Colors.white),
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              elevation: 2,
              iconTheme: IconThemeData(
                color: Colors.grey[900],
              ),
              actionsIconTheme: IconThemeData(color: Colors.grey[900]),
              textTheme: TextTheme(
                headline6: TextStyle(
//            fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[900],
                ),
              ),
            ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(
            isDarkTheme ? Colors.white : Colors.black),
        trackColor: MaterialStateProperty.all(Colors.grey[500]),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: !isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme ? Colors.white : Colors.black,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomTheme {

  static getTheme(){

    return ThemeData(
      fontFamily: 'Outfit',
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold

        )
      )
    );

  }

}
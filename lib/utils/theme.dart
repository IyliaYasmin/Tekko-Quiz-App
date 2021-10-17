import 'package:flutter/material.dart';

class OurTheme {
  Color _lightGreen = Color.fromARGB(255, 213, 235, 220);
  Color _lightGrey = Color.fromARGB(255, 164, 164, 164);
  Color _darkerGrey = Color.fromARGB(255, 119, 124, 135);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: _lightGreen,
      primaryColor: _lightGreen,
      accentColor: _lightGrey,
      secondaryHeaderColor: _darkerGrey,
      hintColor: _lightGrey,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: _lightGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: _lightGreen,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: _darkerGrey,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}

// class DarkLightTheme {
//   bool _light = true;

//   ThemeData buildTheme() {
//     if (_light) {
//       return ThemeData(
//           accentColor: Colors.pink,
//           brightness: Brightness.light,
//           primaryColor: Colors.blue);
//     } else {
//       return ThemeData(
//           accentColor: Colors.red,
//           brightness: Brightness.dark,
//           primaryColor: Colors.amber,
//           buttonTheme: ButtonThemeData(buttonColor: Colors.amber));
//     }
//   }
// }

// class _DarkLightThemeState extends State<DarkLightTheme> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: DarkLightTheme().buildTheme(),
//       home: Scaffold(
//         appBar: AppBar(
//             leading: Switch(
//           value: _light,
//           onChanged: (state) {
//             setState(() {
//               _light = state;
//             });
//           },
//         )),
//       ),
//     );
//   }
// }

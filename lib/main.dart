import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superheroes/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context)
                .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
          ),
        )    );
  }
}

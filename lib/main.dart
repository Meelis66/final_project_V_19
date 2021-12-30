import 'package:flutter/material.dart';
import 'package:shared_preferences_kool/data/moor_db.dart';
import 'package:shared_preferences_kool/screens/home.dart';
import 'package:shared_preferences_kool/screens/settings.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SPSettings settings = SPSettings();

    return Provider(
      create: (context) => BlogDb(),
      child: MaterialApp(
        title: 'Final App V 19',
        theme: ThemeData(
          //fontFamily: 'Raleway',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

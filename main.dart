import 'package:flutter/material.dart';
import 'dart:io';
import 'package:project/LoginPage.dart';
import 'package:project/lab_18/ApiListPage.dart';
import 'package:project/lab_18/CountryStateDropdownPage.dart';
import 'package:project/lab_18/JsonDemoPage.dart';
import 'SplashScreen.dart';
import 'CRUD_Page.dart';
import 'lab_18/TodoListPage.dart';
import 'lab_18/myDatabase.dart';
import 'lab_18/JsonDemoPage.dart';
import 'lab_18/CountryStateDropdownPage.dart';
import 'lab_18/PersonListScreen.dart';
import 'lab_18/PersonAddScreen.dart';

Future<void> resetDatabase() async {
  // Delete database file (for development/testing only)
  final db = MyDatabase();
  await db.initDB();
}

void main()  {
  WidgetsFlutterBinding.ensureInitialized();

  //  Uncomment during development if schema changes
  //  await resetDatabase();

runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Project',
          theme: ThemeData(primarySwatch: Colors.pink),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.pink),
          ),
          themeMode: currentMode,
          home: SplashScreen(),
        );
      },
    );
  }
}
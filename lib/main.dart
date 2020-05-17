import 'package:flutter/material.dart';
import 'package:plan_it_on/config/config.dart';
import 'HomePage.dart';
import 'login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        accentColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AskLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

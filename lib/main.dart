import 'package:flutter/material.dart';
import 'package:plan_it_on/config/config.dart';
import 'HomePage.dart';
import 'loginui.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool login=prefs.getBool('login');
  runApp(login==null?MyApp1():login?MyApp():MyApp1());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass-it-on',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        accentColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        'login':(context)=>AskLogin(),
        'homepage':(context)=>HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass-it-on',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        accentColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AskLogin(),
      routes: {
        'login':(context)=>AskLogin(),
        'homepage':(context)=>HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


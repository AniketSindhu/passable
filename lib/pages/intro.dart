import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:plan_it_on/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreenState extends StatefulWidget {
  @override
  _IntroScreenStateState createState() => _IntroScreenStateState();
}

class _IntroScreenStateState extends State<IntroScreenState> {
 List<Slide> slides = new List();

 @override
 void initState() {
   super.initState();

   slides.add(
     new Slide(
       title: "Events at your fingertip",
       description: "Get all upcoming events based on your location with every detail like location, date, time & etc",
       pathImage: "assets/intro1.png",
       backgroundColor: Color(0xfff5a623),
     ),
   );
   slides.add(
     new Slide(
       title: "Online Events",
       description: "Enjoy online events in this pandemic period",
       pathImage: "assets/intro4.png",
       backgroundColor: Color(0xff203152),
     ),
   );
   slides.add(
     new Slide(
       title: "Buy Passes",
       description:
       "Buy passes/tickets to the event easily, Smooth entry by scanning the QR code on the pass",
       pathImage: "assets/intro3.png",
       backgroundColor: Color(0xff9932CC),
     ),
   );
   slides.add(
     new Slide(
       title: "Notification/Reminders",
       description:
       "Never miss any announcement or reminder related to the event you joined.",
       pathImage: "assets/intro2.png",
       backgroundColor: Color(0xff203152),
     ),
   );
 }

 void onDonePress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first', false);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
 }

 @override
 Widget build(BuildContext context) {
   return new IntroSlider(
     slides: this.slides,
     onDonePress: this.onDonePress,
   );
 }
}


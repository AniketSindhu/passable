import 'package:flutter/material.dart';
import 'package:plan_it_on/config/size.dart';
import 'config/config.dart';
import 'package:google_fonts/google_fonts.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            color:AppColors.secondary,
            height:height/3,
            width: width,
            child:Container(
              margin: EdgeInsets.symmetric(horizontal:width/15,vertical:height/15),
              child: Text("Pass'it'on",style:GoogleFonts.creteRound(textStyle:TextStyle(color: Colors.deepPurple[900],fontSize:30,fontWeight: FontWeight.bold))),
            )
          )
      ],),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/config/size.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
  double height=SizeConfig.getHeight(context);
  double width=SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children:<Widget>[
          Container(
            margin: EdgeInsets.only(left:width/15,top:height/15,right:width/15,bottom:height/30),
            width: width,
            child: Text('Search',style: GoogleFonts.montserrat(fontSize:20,fontWeight:FontWeight.w800),)
          )
        ]
      )
    );
  }
}
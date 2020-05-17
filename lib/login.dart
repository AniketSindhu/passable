import 'package:flutter/material.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';
import 'clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

class AskLogin extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  login(){
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: AppColors.tertiary),   
        child: ClipRRect(borderRadius: BorderRadius.only( 
          topLeft: Radius.circular(100.0), 
          topRight: Radius.circular(100.0)), 
          child: Container( child: ListView(
           children:<Widget>[ListTile(title:Text("hey"),)]
          ))
        )
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: AppColors.secondary,
      body: Column(
        children:<Widget>[
          SizedBox(height:height/20,),
          Expanded(
            child: Center(
              child:RichText(
                text: TextSpan(
                  children:<TextSpan>[
                    TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold))),
                    TextSpan(text:"it",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.tertiary,fontSize:45,fontWeight: FontWeight.bold))),
                    TextSpan(text:"'on",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold)))
                  ] 
                )
              ),
            ),
          ),
          SizedBox(height:height/20,),
          SvgPicture.asset(
            'assets/login.svg',
            width: width,
            height: height/3,
            ),
          SizedBox(height:height/10),
          Column(
            children: <Widget>[
              RaisedButton(
                highlightElevation: 0.0,
                splashColor: AppColors.tertiary,
                highlightColor: AppColors.tertiary,
                elevation: 0.0,
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.heebo(textStyle:TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 28))
                ),
                  onPressed: () {
                    login();
                  },
              ),
              SizedBox(height:height/40),
              OutlineButton(
                highlightedBorderColor: AppColors.tertiary,
                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                highlightElevation: 0.0,
                splashColor: AppColors.tertiary,
                color: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                child: Text("REGISTER",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 28),),
                  onPressed: () { 
                  },
              ),
            ],
          ),
          Expanded(
            child: Align(
              child: ClipPath(
                child: Container(
                  color: Colors.white,
                  height: 300,
                ),
                clipper: BottomWaveClipper(),
              ),
            alignment: Alignment.bottomCenter,
            ),
          )
        ]
      ),
    );
  }
}


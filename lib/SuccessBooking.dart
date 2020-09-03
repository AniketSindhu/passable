import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';

import 'Pass.dart';

class Success extends StatefulWidget {
  final String payment_id;
  final String eventCode;
  final String passCode;
  final bool isOnline;
  Success({this.eventCode,this.payment_id,this.passCode,this.isOnline});
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    var width= SizeConfig.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Event Booked",),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Lottie.asset('assets/success.json',width:width*0.8,repeat: false ),
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: Text('Booking successful',style: GoogleFonts.roboto(fontSize:30,fontWeight: FontWeight.w800)),
              ),
              SizedBox(height:10),
              Text('PaymentId:${widget.payment_id}',style: TextStyle(fontSize:18),),
              SizedBox(height:30),
              RaisedButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Pass(widget.passCode, widget.eventCode, widget.isOnline); 
                  }));
                },
                child: Text('View Pass',style: TextStyle(fontSize:20,color: Colors.black)),
                color: AppColors.secondary,
                splashColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
              ),
              SizedBox(height:10),
              RaisedButton(
                onPressed:(){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), ModalRoute.withName("/homepage"));
                },
                child: Text('Go to Home page',style: TextStyle(fontSize:20,color: Colors.black)),
                color: AppColors.secondary,
                splashColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
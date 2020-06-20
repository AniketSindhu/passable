import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'clipper.dart';
import 'config/config.dart';
import 'package:social_media_buttons/social_media_buttons.dart';

class Pass extends StatefulWidget {
  @override
  String passCode;
  DocumentSnapshot details;
  Pass(this.passCode,this.details);
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      body: Stack(
        children: [
          Align(
           child: ClipPath(
             child: Container(
                color: AppColors.secondary,
               height: 150,
             ),
             clipper: BottomWaveClipper(),
            ),
           alignment: Alignment.bottomCenter,
            ),
          Container(
            child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:width/15,vertical:height/15),
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children:<TextSpan>[
                              TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                              TextSpan(text:"it",style:GoogleFonts.lora(textStyle:TextStyle(color: Colors.pink[600],fontSize:35,fontWeight: FontWeight.bold))),
                              TextSpan(text:"'on",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold)))
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal:width/15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:<Widget>[
                        Container(
                          width: width/1.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              SizedBox(height:5),
                              Text("${widget.details.data['eventName']}",style: TextStyle(fontSize:25,fontWeight:FontWeight.w700),textAlign: TextAlign.left,),
                              SizedBox(height:20),
                              Text("DATE & TIME",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                              Text('${DateFormat('dd-MM-yyyy, hh:mm a').format(widget.details.data['eventDateTime'].toDate())}',style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                              SizedBox(height:10),
                              Text("PASS CODE",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                              Text("${widget.passCode}",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                              SizedBox(height: 10,),
                              Text("ADDRESS",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                              Text("${widget.details.data['eventAddress']}",style: TextStyle(fontSize:14,fontWeight:FontWeight.w500),textAlign: TextAlign.left,),
                            ],
                          ),
                        ),
                        SizedBox(width:8),
                        Expanded(child: Image.network(widget.details.data['eventBanner'],height: height/5,alignment: Alignment.centerRight,))
                      ]
                    ),  
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20,0),
                        child: QrImage(
                          data: widget.passCode,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("One Pass, One Entry",style: TextStyle(color:Colors.red,fontSize: 25,fontWeight: FontWeight.w700),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:<Widget>[
                        SocialMediaButton.facebook(url:'',size:35,color: AppColors.primary,),
                        SocialMediaButton.instagram(url: '',size:35,color: AppColors.primary,),
                        SocialMediaButton.twitter(url: '',size: 35,color: AppColors.primary,),
                      ]
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
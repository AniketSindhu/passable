import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Widgets/clipper.dart';
import 'config/config.dart';
import 'package:social_media_buttons/social_media_buttons.dart';

class Pass extends StatefulWidget {
  final String passCode;
  final bool isOnline;
  final String eventCode;
  Pass(this.passCode,this.eventCode,this.isOnline);
  @override
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  DocumentSnapshot passDetails;
  
  void getPassDetails()async{
    if(widget.isOnline){
      passDetails = await Firestore.instance.collection('OnlineEvents').document(widget.eventCode).collection('guests').document(widget.passCode).get();
      setState(() {
      });
    }
    else{
      passDetails = await Firestore.instance.collection('events').document(widget.eventCode).collection('guests').document(widget.passCode).get();
      setState(() {
      });
    }
  }

  Future getDetails() async{
    if(widget.isOnline){
      final x = await Firestore.instance.collection('OnlineEvents').document(widget.eventCode).get();
      return x;
    }
    else{
      final x = await Firestore.instance.collection('events').document(widget.eventCode).get();
      return x;
    }
  }

  void initState(){
    super.initState();
    getPassDetails();
  }
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      body: FutureBuilder(
        future: getDetails(),
        builder: (context,snap){
          if(snap.connectionState==ConnectionState.waiting||!snap.hasData)
            {
              return Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60));
            }
          else{
            return 
            Stack(
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
                                  TextSpan(text:"Pass",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                                  TextSpan(text:"able",style:GoogleFonts.lora(textStyle:TextStyle(color: Colors.pink[600],fontSize:35,fontWeight: FontWeight.bold))),
                                ]
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Image.asset('assets/logo.png',height: 80,),
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
                                  Text("${snap.data['eventName']}",style: TextStyle(fontSize:25,fontWeight:FontWeight.w700),textAlign: TextAlign.left,),
                                  SizedBox(height:20),
                                  Text("DATE & TIME",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                                  Text('${DateFormat('dd-MM-yyyy, hh:mm a').format(snap.data['eventDateTime'].toDate())}',style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  SizedBox(height:10),
                                  Text("PASS CODE",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                                  Text("${widget.passCode}",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  SizedBox(height: 10,),
                                  Text("ADDRESS",style: TextStyle(fontSize:14,fontWeight:FontWeight.w400),),
                                  Text("${snap.data['isOnline']?'Online Event':snap.data['eventAddress']}",style: TextStyle(fontSize:14,fontWeight:FontWeight.w500),textAlign: TextAlign.left,),
                                ],
                              ),
                            ),
                            SizedBox(width:8),
                            Expanded(child: Image.network(snap.data['eventBanner'],height: height/5,alignment: Alignment.centerRight,))
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
                      passDetails!=null?Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Allow ${passDetails.data['ticketCount']} entries",style: TextStyle(color:Colors.red,fontSize: 25,fontWeight: FontWeight.w700),),
                      ):Container(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:<Widget>[
                            SocialMediaButton.facebook(url:'',size:35,color: AppColors.primary,),
                            SocialMediaButton.instagram(url: 'https://www.instagram.com/passiton.og/',size:35,color: AppColors.primary,),
                            SocialMediaButton.twitter(url: '',size: 35,color: AppColors.primary,),
                          ]
                        ),
                      )
                    ],
                  ),
                )
              ),
            ],
          );
        }
      }
    ),
  );
}
}
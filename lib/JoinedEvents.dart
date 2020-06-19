import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';
import 'googleSignIn.dart';
import 'loginui.dart';
class JoinedEvents extends StatefulWidget {
  String uid;
  JoinedEvents(this.uid);
  @override
  _JoinedEventsState createState() => _JoinedEventsState();
}

class _JoinedEventsState extends State<JoinedEvents> {
  var firestore=Firestore.instance;
  Future getEvents() async{
    List<String>eventCodes=[];
    final QuerySnapshot result= await firestore.collection('users').document(widget.uid).collection('eventJoined').getDocuments();
    result.documents.forEach((element)=>eventCodes.add(element.data['eventCode']));
    final QuerySnapshot joinedEventDetails=await firestore.collection('events').where("eventCode",whereIn:eventCodes).getDocuments();
    return joinedEventDetails.documents;
  }
   @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      body:Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(width/15,height/15,width/15,height/30),
            width: width,
            child: RichText(
               text: TextSpan(
                 children:<TextSpan>[
                   TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                   TextSpan(text:"it",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:35,fontWeight: FontWeight.bold))),
                  TextSpan(text:"'on",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold)))
                ]
              )
            ),
          ),
          FutureBuilder(
            future: getEvents(),
            builder:(context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Expanded(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:40)));
              }
              else if(snapshot.data.length==0)
              {
                return Column(
                  children: [
                    Container(
                      width: width,
                      height: height/2,
                      child: Center(
                       child: Padding(
                           padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(
                            'assets/event.svg',
                            semanticsLabel: 'Event Illustration'
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:height/20),
                    Text("Nothing to show up here :(")
                  ],
                );
              }
              else
              return Expanded(
                  child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder:(context,index){
                    return ListTile(title: Text("${snapshot.data[index].data['eventCode']}"),);
                  }
                ),
              );
          }),
        ],
      )
    );
  }
}
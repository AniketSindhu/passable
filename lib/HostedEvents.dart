import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/EventDetails.dart';
import 'package:plan_it_on/Widgets/eventCard.dart';
import 'package:plan_it_on/config/size.dart';
import 'Pass.dart';
import 'config/config.dart';

class HostedEvents extends StatefulWidget {
  final String uid;
  HostedEvents(this.uid);
  @override
  _HostedEventsState createState() => _HostedEventsState();
}

class _HostedEventsState extends State<HostedEvents> {
  var firestore=Firestore.instance;
  Future getEvents() async{
    List<String>eventCodes=[];
    final QuerySnapshot result= await firestore.collection('users').document(widget.uid).collection('eventsHosted').getDocuments();
    result.documents.forEach((element)=>eventCodes.add(element.data['eventCode']));
    final QuerySnapshot hostedEventDetails=await firestore.collection('events').orderBy('eventDateTime',descending: false).where("eventCode",whereIn:eventCodes).getDocuments();
    return hostedEventDetails.documents;
  }
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      body:Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(width/15,height/15,width/15,height/50),
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
          Padding(
            padding: const EdgeInsets.only(right:16.0,bottom: 10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Hosted Events",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color:Colors.redAccent),),
            ),
          ),
          FutureBuilder(
            future: getEvents(),
            builder:(context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Expanded(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:40)));
              }
              else if(snapshot.data==null)
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
                    return eventCard(snapshot.data[index], height, width, 1, context);
                  }
                ),
              );
          }),
        ],
      )
    );
  }
}
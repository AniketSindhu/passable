import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/EventDetails.dart';
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
    final QuerySnapshot hostedEventDetails=await firestore.collection('events').where("eventCode",whereIn:eventCodes).getDocuments();
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
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,20),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal:width*0.02),
                        height: height*0.3,
                        child: Card(
                          color: Colors.deepPurple[50],
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                          elevation: 4,
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(alignment:Alignment.topLeft,child: Image.network(snapshot.data[index].data['eventBanner'],fit: BoxFit.fitHeight,width: width*0.3,height:height*0.3)),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,16,8,0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("${snapshot.data[index].data['eventName']}",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize:20,color: AppColors.primary)),textAlign: TextAlign.start,)
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
                                              child: Align(
                                                alignment:Alignment.bottomLeft,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    Text('${DateFormat('hh:mm a').format(snapshot.data[index].data['eventDateTime'].toDate())}',style: TextStyle(fontWeight:FontWeight.w600,fontSize: 18),),
                                                    Text('${DateFormat('EEE, d MMMM yyyy').format(snapshot.data[index].data['eventDateTime'].toDate())}',style: TextStyle(fontWeight:FontWeight.w400,fontSize: 14),),
                                                    SizedBox(height:10),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: FlatButton(
                                                        onPressed:(){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context){return DetailPage(1, snapshot.data[index],widget.uid);}));
                                                        },
                                                        color: AppColors.tertiary,
                                                        splashColor: AppColors.primary,
                                                        child: Text("Event Details",style: TextStyle(fontWeight: FontWeight.w600),)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment:Alignment.bottomCenter,
                                child:Container(
                                  width: width,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0,10,10,5),
                                    child: Text("${snapshot.data[index].data['eventAddress']}",style:TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w500)),
                                  ),
                                  color: AppColors.secondary,
                                )
                              )
                            ]
                          ) ,
                        ),
                      ),
                    );
                  }
                ),
              );
          }),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/Widgets/eventCard.dart';
import 'package:plan_it_on/config/size.dart';
import 'config/config.dart';
class JoinedEvents extends StatefulWidget {
  final String uid;
  JoinedEvents(this.uid);
  @override
  _JoinedEventsState createState() => _JoinedEventsState();
}

class _JoinedEventsState extends State<JoinedEvents> with SingleTickerProviderStateMixin{
  var firestore=Firestore.instance;
  TabController _tabController;
  int index=0;
  Future getEvents(int index) async{
    List<String>eventCodes=[];
    if(index==0){
      final QuerySnapshot result= await firestore.collection('users').document(widget.uid).collection('eventJoined').getDocuments();
      result.documents.forEach((element)=>eventCodes.add(element.data['eventCode']));
      final QuerySnapshot joinedEventDetails=await firestore.collection('events').orderBy('eventDateTime',descending: false).where("eventCode",whereIn:eventCodes).getDocuments();
      return joinedEventDetails.documents;
    }
    else{
      final QuerySnapshot result= await firestore.collection('users').document(widget.uid).collection('eventJoined').getDocuments();
      result.documents.forEach((element)=>eventCodes.add(element.data['eventCode']));
      final QuerySnapshot joinedEventDetails=await firestore.collection('OnlineEvents').orderBy('eventDateTime',descending: false).where("eventCode",whereIn:eventCodes).getDocuments();
      return joinedEventDetails.documents;
    }
  }
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Padding(
          padding: const EdgeInsets.only(left:10,top:10),
          child: RichText(
             text: TextSpan(
               children:<TextSpan>[
                TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                TextSpan(text:"able",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:35,fontWeight: FontWeight.bold))),
              ]
            )
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (val){
            setState(() {
              index=val;
            });
          },
          labelColor: Colors.red,
          indicatorColor: AppColors.tertiary,
          tabs:<Tab>[
            Tab(text: 'Offline Events'),
            Tab(text: 'Online Events'),
          ], 
        ),
      ),
      body:TabBarView(
        controller: _tabController,
        children:[Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:16.0,bottom: 10.0,top:10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Joined Events",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color:AppColors.primary),),
              ),
            ),
            FutureBuilder(
              future: getEvents(index),
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
                else{
                  if(snapshot.data.length==0)
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
                        return eventCard(snapshot.data[index], height, width, 2, context);
                      }
                    ),
                  );
                }
            }),
          ],
        ),
      Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:16.0,bottom: 10.0,top:10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Joined Events",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color:AppColors.primary),),
              ),
            ),
            FutureBuilder(
              future: getEvents(index),
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
                else{
                  if(snapshot.data.length==0)
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
                          return eventCard(snapshot.data[index], height, width, 2, context);
                        }
                      ),
                    );
                  }
                }
            ),
          ],
        ),
      ])
    );
  }
}


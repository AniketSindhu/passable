import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class JoinedEvents extends StatefulWidget {
  String uid;
  JoinedEvents(this.uid);
  @override
  _JoinedEventsState createState() => _JoinedEventsState();
}

class _JoinedEventsState extends State<JoinedEvents> {
  var firestore=Firestore.instance;
  Future getEvents() async{
    List<String>eventCodes;
    final QuerySnapshot result= await firestore.collection('users').document(widget.uid).collection('eventJoined').getDocuments();
    result.documents.forEach((element) {eventCodes.add(element.data['eventCode']);});
    eventCodes.forEach((element)=>print(element));
    final QuerySnapshot joinedEventDetails=await firestore.collection('events').where("eventCode",whereIn:eventCodes).getDocuments();
    return joinedEventDetails.documents;
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder(
        future: getEvents(),
        builder:(context,snapshot){
          return ListView.builder(
            itemBuilder:(context,index){
              return ListTile(title: Text("ok"),);
            }
          );
      })
    );
  }
}
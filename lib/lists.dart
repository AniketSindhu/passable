import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/scanPass.dart';
import 'package:random_string/random_string.dart';
import 'Pass.dart';
import 'config/config.dart';
import 'package:flutter_show_more/flutter_show_more.dart';

class PassesAlotted extends StatefulWidget {
  final String eventCode;
  PassesAlotted(this.eventCode);
  @override
  _PassesAlottedState createState() => _PassesAlottedState();
}

class _PassesAlottedState extends State<PassesAlotted> {
  var firestore=Firestore.instance;
  Future<List<DocumentSnapshot>> users;
  Future getData()async{
    List<String>guests=[];
    final QuerySnapshot result= await firestore.collection('events').document(widget.eventCode).collection('guests').getDocuments();
    result.documents.forEach((element)=>guests.add(element.data['user']));
    final QuerySnapshot joinedGuests=await firestore.collection('users').where("uid",whereIn: guests).orderBy('name').getDocuments();
    return joinedGuests.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Joined guests')),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(child: SpinKitChasingDots(color: AppColors.secondary,size: 20,),);
            }
          else if(snapshot.hasData)
           { if(snapshot.data.length==0)
            {
              return Center(child: Text('No one joined yet :('),);
            }
            else
            return ListView.builder(
              itemCount:snapshot.data.length,
              itemBuilder:(context,index){
                return ListTile(
                 title:Text("${snapshot.data[index].data['name']}",),
                 subtitle: Text("${snapshot.data[index].data['phoneNumber']==null?snapshot.data[index].data['email']:snapshot.data[index].data['phoneNumber']}"),
                );
              }
            );
           }
        }
      ),
    );
  }
}

class ScannedList extends StatefulWidget {
  final String eventCode;
  ScannedList(this.eventCode);
  @override
  _ScannedListState createState() => _ScannedListState();
}

class _ScannedListState extends State<ScannedList> {
  var firestore=Firestore.instance;
  Future<List<DocumentSnapshot>> users;
  Future getData()async{
    List<String>guests=[];
    final QuerySnapshot result= await firestore.collection('events').document(widget.eventCode).collection('guests').where('scanned',isEqualTo:true).getDocuments();
    result.documents.forEach((element)=>guests.add(element.data['user']));
    final QuerySnapshot joinedGuests=await firestore.collection('users').where("uid",whereIn: guests).orderBy('name').getDocuments();
    return joinedGuests.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Joined guests')),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(child: SpinKitChasingDots(color: AppColors.secondary,size: 20,),);
            }
          else if(snapshot.hasData)
           { if(snapshot.data.length==0)
            {
              return Center(child: Text('No one joined yet :('),);
            }
            else
            return ListView.builder(
              itemCount:snapshot.data.length,
              itemBuilder:(context,index){
                return ListTile(
                 title:Text("${snapshot.data[index].data['name']}",),
                 subtitle: Text("${snapshot.data[index].data['phoneNumber']==null?snapshot.data[index].data['email']:snapshot.data[index].data['phoneNumber']}"),
                );
              }
            );
           }
           else
           return Container(child:Text('error'));
        }
      ),
    );
  }
}
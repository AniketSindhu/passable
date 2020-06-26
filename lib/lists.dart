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
  String eventCode;
  PassesAlotted(this.eventCode);
  @override
  _PassesAlottedState createState() => _PassesAlottedState();
}

class _PassesAlottedState extends State<PassesAlotted> {
  var firestore=Firestore.instance;
  bool flag=false;
  Future<List<DocumentSnapshot>> users;
  Future getData()async{
    List<String>guests=[];
    final QuerySnapshot result= await firestore.collection('events').document(widget.eventCode).collection('guests').getDocuments();
    result.documents.forEach((element)=>guests.add(element.data['user']));
    final QuerySnapshot joinedGuests=await firestore.collection('users').where("uid",whereIn: guests).getDocuments().whenComplete(() => flag=true);
    return joinedGuests.documents;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Joined guests')),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot){
          if(!snapshot.hasData)
            {
              return Center(child: Text('No one joined yet :('),);
            }
          else if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(child: SpinKitChasingDots(color: AppColors.secondary,size: 20,),);
            }
          else
          return ListView.builder(
            itemCount:snapshot.data.length,
            itemBuilder:(context,index){
              return ListTile(
                title:Text("${snapshot.data[index].data['name']}",style: TextStyle(color:Colors.black),),
                subtitle: Text("${snapshot.data[index].data['phoneNumber']==null?snapshot.data[index].data['email']:snapshot.data[index].data['phoneNumber']}"),
              );
            }
          );
        }
      ),
    );
  }
}
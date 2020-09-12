import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:plan_it_on/config/config.dart';

class Policy extends StatelessWidget {
  final int index;
  Policy({this.index});
  Future getPolicy() async{
    if(index==0){
      final x = await Firestore.instance.collection('policies').document('privacy').get();
      return x;
    }
    else if(index==1){
      final x = await Firestore.instance.collection('policies').document('TandC').get();
      return x;
    }
    else{ 
      final x = await Firestore.instance.collection('policies').document('cancellation').get();
      return x;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(index==0?'Privacy Policy':index==1?'Terms and Conditions':'Cancellation policy'),),
      body: SingleChildScrollView(
        child:FutureBuilder(
          future:getPolicy(),
          builder:(context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60));
              }
            else
              return Padding(
                padding: const EdgeInsets.only(left:15,right:15,top:10),
                child: Html(
                  data:snapshot.data['text'],
                  
                ),
              );
          }
        )
      ),
    );
  }
}
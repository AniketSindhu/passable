import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'Models/AnnouncementClass.dart';
import 'config/config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'Methods/firebaseAdd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Announcements extends StatefulWidget {
  final String eventCode;
  final bool isOnline;
  Announcements(this.eventCode,this.isOnline);
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(widget.isOnline?"OnlineEvents":"events").document(widget.eventCode).collection("Announcements").orderBy('timestamp',descending: true).snapshots(),
        builder:(context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child:CircularProgressIndicator()
            );
          }
          else{
            if(snapshot.data.documents.length==0){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/NoOne.json",width: MediaQuery.of(context).size.width*0.8),
                    SizedBox(height:10),
                    Text('No Announcements yet!',style: GoogleFonts.novaRound(textStyle:TextStyle(color: AppColors.secondary,fontSize:22,fontWeight:FontWeight.bold)),)
                  ],
                ),
              );
            }
            else
              return Container(
                margin: EdgeInsets.only(top:10),
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder:(context,index){
                    return announceWidget(Announce.fromDocument(snapshot.data.documents[index]),widget.eventCode);
                  } 
                ),
              );
          }
        }
      );
  }
}
                
Widget announceWidget(Announce announce,String eventCode){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(timeago.format(DateTime.parse("${announce.timestamp.toDate()}"),locale:"en"),style: TextStyle(fontWeight:FontWeight.w500,fontSize:18),),
            ],
          ),
        ),
      ),
      announce.media!=null?
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal:15),
          child:ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(announce.media,fit:BoxFit.cover,),
          )
        ):Container(),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Linkify(
          options: LinkifyOptions(looseUrl:true),
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
              }
          },
          text:
          "${announce.description}",
          overflow: TextOverflow.ellipsis,
          maxLines: 30,
          style:GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black
          ),
          linkStyle: TextStyle(color: Colors.blue),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:13.0),
        child: Divider(color: AppColors.primary,thickness: 1,),
      )
    ],
  );
}

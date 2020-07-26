import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'Models/AnnouncementClass.dart';
import 'config/config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'firebaseAdd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Announcements extends StatefulWidget {
  final bool isOwner;
  final String eventCode;
  Announcements(this.eventCode,this.isOwner);
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Announcements",),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      floatingActionButton: widget.isOwner?FloatingActionButton.extended(
        onPressed:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAnnouncement(widget.eventCode))),
        icon: Icon(Icons.add,),
        backgroundColor: AppColors.tertiary,
        splashColor: AppColors.secondary,
        label: Text("Announce",style: GoogleFonts.roboto(textStyle:TextStyle(color: Colors.black,fontWeight:FontWeight.w600))),
      ):Container(),
      body: StreamBuilder(
        stream: Firestore.instance.collection("events").document(widget.eventCode).collection("Announcements").orderBy('timestamp',descending: true).snapshots(),
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
                    return announceWidget(Announce.fromDocument(snapshot.data.documents[index]));
                  } 
                ),
              );
          }
        }
      ),
    );
  }
}
                
Widget announceWidget(Announce announce){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(timeago.format(DateTime.parse("${announce.timestamp.toDate()}"),locale:"en"),style: TextStyle(fontWeight:FontWeight.w500,fontSize:18),),
        ),
      ),
      announce.media!=null?
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal:15),
          child:ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(announce.media,fit:BoxFit.cover,),
          )
        ):Container(),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "${announce.description}",
          overflow: TextOverflow.ellipsis,
          maxLines: 30,
          style:GoogleFonts.rubik(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black
          ) 
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: Divider(color: AppColors.tertiary,thickness: 1,),
      )
    ],
  );
}

class CreateAnnouncement extends StatefulWidget {
  final String eventCode;
  CreateAnnouncement(this.eventCode);
  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  TextEditingController descriptionController =TextEditingController();
  String description;
  File _image;
  final picker = ImagePicker();
  bool uploading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Make announcement'),centerTitle: true,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            uploading=true;
          });
          FirebaseAdd().announce(widget.eventCode, descriptionController.text, _image).then((value){
              uploading=false;
              Navigator.pop(context);
            });
        },
        child: Icon(Icons.navigate_next,color: Colors.black,size:35),
        backgroundColor: AppColors.tertiary,
        splashColor: Colors.redAccent,
        ),
      body: !uploading?SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical:10,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image==null?SvgPicture.asset('assets/announce.svg',height: 300,):Container(),
                SizedBox(height:30),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "What do you want to announce?",
                    fillColor: Colors.purple,
                    hintStyle: GoogleFonts.rubik(color: Colors.purple[200],fontSize: 20,fontWeight:FontWeight.w500),
                    contentPadding: EdgeInsets.symmetric(horizontal:10)
                  ),
                  style: GoogleFonts.rubik(fontSize:22,fontWeight:FontWeight.w500),
                ),
                SizedBox(height:20),
                _image==null?Center(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_a_photo,color: AppColors.secondary,),
                        onPressed:() async{
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                        },
                        iconSize: 35,
                        splashColor: AppColors.tertiary,
                      ),
                      Text("Add an Image",style:TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                    ],
                  ),
                ):
                Container(
                  child:Center(child: Column(
                    children: [
                      Card(
                        child: Image.file(_image,width:MediaQuery.of(context).size.width*0.75),
                        elevation: 8,
                      ),
                      SizedBox(height:20),
                      IconButton(
                        icon: Icon(Icons.add_a_photo,color: AppColors.secondary,),
                        onPressed:() async{
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                        },
                        iconSize: 35,
                        splashColor: AppColors.tertiary,
                      ),
                      Text("Change Image",style:TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),   
                    ],
                  ))
                ),
              ],
            ),
          ),
        )
      ):Center(child:SpinKitDoubleBounce(color:AppColors.secondary,size: 40,)),
    );
  }
}
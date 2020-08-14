import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/Announcements.dart';
import 'package:plan_it_on/Models/user.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:random_string/random_string.dart';
import 'Pass.dart';
import 'config/config.dart';
import 'package:flutter_show_more/flutter_show_more.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String uid;
  final int currentIndex;
  DetailPage(this.currentIndex,this.post,this.uid);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController eventCodeController=TextEditingController();
  String writtenCode,passCode;
  
  void showPass()async{
    String passCode;
    await Firestore.instance.collection('users').document(widget.uid).collection('eventJoined').where('eventCode',isEqualTo:widget.post.data['eventCode']).getDocuments()
    .then((value){
      passCode=value.documents.elementAt(0).data['passCode'];
    });
    Navigator.push(context,MaterialPageRoute(builder:(context){return Pass(passCode,widget.post);}));
  }

  void getPass(BuildContext context,double height)async{
    showDialog(
      context:context,
       builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
          scrollable: true,
          backgroundColor:AppColors.secondary,
          title: Center(child: Text("Get Entry Pass",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w700,fontSize:30),)),
          content: Container(
           height: height/5,
           child: Column(
             children: [
               TextField(
                  controller: eventCodeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary,fontSize: 25,fontWeight: FontWeight.w500),
                   cursorColor: AppColors.primary,
                  autofocus: true,
                   decoration: InputDecoration(
                    hintText:"Enter event code"
                   ),
                 ),
                 Expanded(
                   child: Center(
                     child: RaisedButton(
                       onPressed:() async{
                        final x= await Firestore.instance.collection('users').document(widget.uid).collection('eventJoined').document(widget.post.data['eventCode']).get();
                         if(widget.post.data['eventCode']!=eventCodeController.text)
                           Fluttertoast.showToast(msg: "Wrong code Entered",backgroundColor: Colors.red,textColor: Colors.white);
                         else if(widget.post.data['joined']>=widget.post.data['maxAttendee'])
                           Fluttertoast.showToast(msg: "Event Full",backgroundColor: Colors.red,textColor: Colors.white);
                        else if(x.exists)
                           {
                             Fluttertoast.showToast(msg: "Event Already Joined",backgroundColor: Colors.red,textColor: Colors.white);
                          }
                         else
                        { passCode= randomAlphaNumeric(6);
                          User user;
                          final userDoc= await Firestore.instance.collection('users').document(widget.uid).get();
                         user=User.fromDocument(userDoc);
                         Firestore.instance.collection("events").document(widget.post.data['eventCode']).collection('guests').document(passCode).setData({'user':user.uid,'phone':user.phone,'email':user.email,'name':user.name,'passCode':passCode,'Scanned':false});
                         Firestore.instance.collection('users').document(widget.uid).collection('eventJoined').document(widget.post.data['eventCode']).setData({'eventCode':widget.post.data['eventCode'],'passCode':passCode});
                         Firestore.instance.collection('events').document(widget.post.data['eventCode']).updateData({'joined': widget.post.data['joined']+1});
                         Navigator.pop(context);
                         Navigator.push(context, MaterialPageRoute(builder: (context){return Pass(passCode,widget.post);}));
                        }
                     },
                     textColor: AppColors.primary,
                      child: Text("Get Pass",style: TextStyle(fontWeight:FontWeight.w600,fontSize:20),),
                      elevation: 10,
                      color: AppColors.tertiary,
                    ),
                 ),
                )
             ],
           )
          ),
        );
     }
    ).then((value) {
      eventCodeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width=SizeConfig.getWidth(context);
    double height=SizeConfig.getHeight(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Event Details",),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body:SingleChildScrollView(
        child:Container(
          margin:EdgeInsets.symmetric(horizontal:width/25,vertical: height*0.02),
          child: Column(
            children: [
              Container(
                height: height/3.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(widget.post.data['eventBanner'],width:width/2.8,height: height/3.6,fit: BoxFit.fitHeight,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 12, 10, 10),
                        child: Container(
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text("${widget.post.data['eventName']}",style: GoogleFonts.varelaRound(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize: 22))),
                              ),
                              SizedBox(height:5),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('${DateFormat('hh:mm a').format(widget.post.data['eventDateTime'].toDate())}',style: TextStyle(fontWeight:FontWeight.w600,fontSize: 18),)
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('${DateFormat('EEE, d MMMM yyyy').format(widget.post.data['eventDateTime'].toDate())}',style: TextStyle(fontWeight:FontWeight.w400,fontSize: 14),)
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        onPressed:(){
                                          widget.currentIndex==0?
                                            getPass(context, height)
                                          :showPass();
                                        },
                                        child: Text(widget.currentIndex==0?'Get Pass':'Show Pass',style: TextStyle(fontSize:16),),
                                        color: AppColors.tertiary,
                                        splashColor: AppColors.primary,
                                      ),
                                      widget.currentIndex==0?
                                      Container():
                                      RaisedButton(
                                        onPressed:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){return Announcements(widget.post.data['eventCode']);}));
                                           //make announcements
                                        },
                                        child: Text("Announcements",style: TextStyle(fontSize:16),),
                                        color: AppColors.tertiary,
                                        splashColor: AppColors.primary,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height:30),
              Align(
                child: Text('Address',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              SizedBox(height:15),
              Text('${widget.post.data['eventAddress']}',style: TextStyle(fontSize: 18),),
              SizedBox(height:20),
              Align(
                child: Text('Event Description',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              SizedBox(height:15),
              ShowMoreText(
                '${widget.post.data['eventDescription']}',
                maxLength: 50,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                showMoreText: 'show more',
                showMoreStyle: TextStyle(
                fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
                shouldShowLessText: false,
              ),
            ],
          ),
        )
      )
    );
  }
}
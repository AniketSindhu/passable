import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/scanPass.dart';
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
                           print("wrong code entered");
                         else if(widget.post.data['joined']>=widget.post.data['maxAttendee'])
                           print('Event Full');
                        else if(x.exists)
                           {
                             print('Already Joined');
                          }
                         else
                        { passCode= randomAlphaNumeric(6);
                         Firestore.instance.collection("events").document(widget.post.data['eventCode']).collection('guests').document(passCode).setData({'user':widget.uid,'passCode':passCode,'Scanned':false});
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
                                      if(widget.currentIndex==1)
                                      RaisedButton(
                                        onPressed:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context){return ScanPass(widget.post.data['eventCode']);}));
                                        },
                                        color: AppColors.tertiary,
                                        splashColor: AppColors.primary,
                                        child:Text('Scan Passes',style: TextStyle(fontSize:16),)
                                      ),
                                      RaisedButton(
                                        onPressed:(){
                                          widget.currentIndex==0?
                                            getPass(context, height):
                                          widget.currentIndex==1?
                                          {}
                                          :showPass();
                                        },
                                        child: Text(widget.currentIndex==0?'Get Pass':widget.currentIndex==1?'Edit Event':'Show Pass',style: TextStyle(fontSize:16),),
                                        color: AppColors.tertiary,
                                        splashColor: AppColors.primary,
                                      ),
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
              SizedBox(height:15),
              if(widget.currentIndex==1)
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Event Code: ${widget.post.data['eventCode']}',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600,fontSize: 18)),),
                    IconButton(
                      color: AppColors.primary,
                      splashColor: AppColors.primary,
                      highlightColor: AppColors.primary,
                      icon: Icon(Icons.share,color: Colors.black,),
                      onPressed:()async{
                        await FlutterShare.share(
                          title: 'Get entry pass for ${widget.post.data['eventName']}',
                          text: 'Enter the code ''${widget.post.data['eventCode']}'' to get an entry pass for the ${widget.post.data['eventName']} happening on ${DateFormat('dd-MM-yyyy AT hh:mm a').format(widget.post.data['eventDateTime'].toDate())}',
                          linkUrl: 'https://flutter.dev/',
                          chooserTitle: 'Get entry pass for ${widget.post.data['eventName']}'
                        );
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Align(
                child: Text('Address',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              SizedBox(height:15),
              Text('${widget.post.data['eventAddress']}',style: TextStyle(fontSize: 18),),
              SizedBox(height:20),
              if(widget.currentIndex==1)
              Align(
                child: Text('Event Dashboard',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              if(widget.currentIndex==1)Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              if(widget.currentIndex==1)SizedBox(height:10),
              if(widget.currentIndex==1)             
              Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(12.0),
                shadowColor: AppColors.secondary,
                child:InkWell(
                  child:
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Joined Guests', style: TextStyle(color: AppColors.primary)),
                              Text('${widget.post.data['joined']} / ${widget.post.data['maxAttendee']}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30.0))
                            ],
                          ),
                          Material(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.people, color: Colors.white, size: 30.0),
                              )
                            )
                          )
                        ]
                      ),
                    ),
                ),
              ),
              if(widget.currentIndex==1)SizedBox(height:10),
              if(widget.currentIndex==1)
              Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(12.0),
                shadowColor: AppColors.secondary,
                child:InkWell(
                  child:
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Scanned Passes', style: TextStyle(color: AppColors.primary)),
                              Text('0', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 30.0))
                            ],
                          ),
                          Material(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.confirmation_number, color: Colors.white, size: 30.0),
                              )
                            )
                          )
                        ]
                      ),
                    ),
                ),
              ),
              if(widget.currentIndex==1)SizedBox(height:30),
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
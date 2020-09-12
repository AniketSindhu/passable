import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:plan_it_on/pages/Announcements.dart';
import 'package:plan_it_on/Models/user.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/pages/confirmation.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Pass.dart';
import '../config/config.dart';
import 'package:flutter_show_more/flutter_show_more.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';

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
  int index=0;
  void showPass()async{
    String passCode;
    await Firestore.instance.collection('users').document(widget.uid).collection('eventJoined').where('eventCode',isEqualTo:widget.post.data['eventCode']).getDocuments()
    .then((value){
      passCode=value.documents.elementAt(0).data['passCode'];
    });
    Navigator.push(context,MaterialPageRoute(builder:(context){return Pass(passCode,widget.post.data['eventCode'],widget.post.data['isOnline']);}));
  }

void nextPage(BuildContext context,double height)async{
    final x= await Firestore.instance.collection('users').document(widget.uid).collection('eventJoined').document(widget.post.data['eventCode']).get();
    if(widget.post.data['joined']>=widget.post.data['maxAttendee'])
       Fluttertoast.showToast(msg: "Event Full",backgroundColor: Colors.red,textColor: Colors.white);
    else if(x.exists)
      {
         Fluttertoast.showToast(msg: "Event Already Joined",backgroundColor: Colors.red,textColor: Colors.white);
      }
    else if(widget.post.data['isProtected'])
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
                       onPressed:() {
                          if(widget.post.data['eventCode']==eventCodeController.text)
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyTicket(widget.post)));
                          else
                            Fluttertoast.showToast(msg: "Wrong code Entered",backgroundColor: Colors.red,textColor: Colors.white);
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
    else 
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyTicket(widget.post)));
  }

  @override
  Widget build(BuildContext context) {
    double width=SizeConfig.getWidth(context);
    double height=SizeConfig.getHeight(context);
    return Scaffold(
      bottomNavigationBar:widget.currentIndex==0?null:BottomNavigationBar(
        backgroundColor: AppColors.primary,
        currentIndex: index,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.white,
        onTap: (val){
          setState(() {
            index=val;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.info),title: Text('Details')),
          BottomNavigationBarItem(icon: Icon(FlutterIcons.announcement_mdi),title: Text('Announcements'))
        ]
      ),
      appBar: AppBar(
        title:Text(index==0?"Event Details":'Announcements',),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body:index==0?SingleChildScrollView(
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
                              Container(
                                height: 50,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText("${widget.post.data['eventName']}",style: GoogleFonts.varelaRound(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize: 28)),maxLines: 2,),
                                ),
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
                              widget.currentIndex==0?SizedBox(height:10):Container(),
                              widget.currentIndex==0?Align(
                                alignment: Alignment.topLeft,
                                child: Text('${widget.post.data['isPaid']?'₹ ${widget.post.data['ticketPrice']}':'Free'}',style: TextStyle(fontWeight:FontWeight.w600,fontSize: 20),)
                              ):Container(),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed:(){
                                          widget.currentIndex==0?
                                            nextPage(context, height)
                                            :showPass();
                                        },
                                        child: Text(widget.currentIndex==0?'Get Pass':'Show Pass',style: GoogleFonts.alata(fontSize:20),),
                                        color: AppColors.tertiary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        splashColor: AppColors.primary,
                                      ),
                                      !widget.post.data['isOnline']?Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.secondary, width: 1),
                                          color: AppColors.tertiary,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.location_on),
                                          iconSize: 25,
                                          onPressed: (){
                                            launch('https://www.google.com/maps/search/?api=1&query=${widget.post.data["position"]["geopoint"].latitude.toString()},${widget.post.data["position"]["geopoint"].longitude.toString()}');
                                          },
                                          splashColor: AppColors.primary,
                                        ),
                                      ):Container()
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
                child: Text('Event Category',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              SizedBox(height:15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${widget.post.data['eventCategory']}',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              ),
             !widget.post.data['isOnline']? SizedBox(height:30):Container(),
             !widget.post.data['isOnline']? Align(
                child: Text('Address',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ):Container(),
             !widget.post.data['isOnline']? Divider(color:AppColors.secondary,height: 10,thickness: 2,):Container(),
             !widget.post.data['isOnline']? SizedBox(height:15):Container(),
             !widget.post.data['isOnline']? Text('${widget.post.data['eventAddress']}',style: TextStyle(fontSize: 18),):Container(),
             !widget.post.data['isOnline']? SizedBox(height:20):Container(),
             SizedBox(height:30),
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
             SizedBox(height:30),
              Align(
                child: Text('Host info',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 24)),),
                alignment: Alignment.centerLeft,
              ),
              Divider(color:AppColors.secondary,height: 10,thickness: 2,),
              SizedBox(height:15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name: ${widget.post.data['hostName']}',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height:6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email: ${widget.post.data['hostEmail']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Phone:${widget.post.data['hostPhoneNumber']}',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed:(){
                       FlutterClipboard.copy('${widget.post.data['hostPhoneNumber']}').then(( value ) => Fluttertoast.showToast(msg: 'copied to clipboard'));
                    }
                  )
                ],
              ),
            ],
          ),
        )
      ):Announcements(widget.post.data['eventCode'],widget.post.data['isOnline'])
    );
  }
}
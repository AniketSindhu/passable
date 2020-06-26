import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/firebaseAdd.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:random_string/random_string.dart';
import 'clipper.dart';
import 'config/config.dart';
import 'config/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_share/flutter_share.dart';

class PublicEvent extends StatefulWidget {
  final String uid;
  PublicEvent(this.uid);
  @override
  _PublicEventState createState() => _PublicEventState();
}

class _PublicEventState extends State<PublicEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String eventName,eventDescription,eventAddress,eventCode;
  int maxAttendees;
  bool imageDone=false;
  File _image;
  DateTime dateTime;
  final picker = ImagePicker();
  final nameController=TextEditingController();
  final descriptionController=TextEditingController();
  final eventAddController=TextEditingController();
  final maxAttendeeController=TextEditingController();
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      eventCode=randomAlphaNumeric(6);
      FirebaseAdd().addEvent(eventName, eventCode, eventDescription, eventAddress, maxAttendees,_image,dateTime, widget.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CongoScreen(eventName,eventCode,eventAddress,_image,dateTime)));
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
     } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      body:ListView(
        
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left:width/15,top:height/25,right:width/15 ),
            width: width,
            child:RichText(
              text: TextSpan(
               children:<TextSpan>[
                  TextSpan(text:"Create ",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                  TextSpan(text:"An ",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:35,fontWeight: FontWeight.bold))),
                  TextSpan(text:"Event",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold)))
                ] 
              )
            ),
          ),
          SizedBox(height:20),
          Container(
            margin: EdgeInsets.symmetric(horizontal:width/15),
            child: Text("*All fields are necessary",style: TextStyle(color:Colors.redAccent[400],fontStyle:FontStyle.italic,fontSize: 18),)),
          SizedBox(height:20),
          Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child:Column(
              children: <Widget>[
                CustomTextField(
                  maxLines:1,
                  number:false,
                  width:0.5,
                  radius: 5,
                  controller: nameController,
                  validator: (value) => value.length<2?'*must be 2 character long':null,
                  hint: "Event Name",
                  icon: Icon(Icons.sort_by_alpha,color:AppColors.secondary,),
                  onSaved: (input){
                    eventName=input;
                  },  
                ),
                SizedBox(height:20),
                CustomTextField(
                  maxLines:5,
                  number:false,
                  width:0.5,
                  radius: 5,
                  controller: descriptionController,
                  validator: (value) => value.length<2?'*must be 2 character long':null,
                  hint: "Event Description",
                  icon: Icon(Icons.border_color,color:AppColors.secondary,),
                  onSaved: (input){
                    eventDescription=input;
                  },  
                ),
                SizedBox(height:20),
                CustomTextField(
                  maxLines:3,
                  number:false,
                  width:0.5,
                  radius: 5,
                  controller: eventAddController,
                  validator: (value) => value.length<2?'*must be 2 character long':null,
                  hint: "Event Address",
                  icon: Icon(Icons.near_me,color:AppColors.secondary,),
                  onSaved: (input){
                    eventAddress=input;
                  },  
                ),
                SizedBox(height:20),
                CustomTextField(
                  maxLines:1,
                  number:true,
                  width:0.5,
                  radius: 5,
                  controller: maxAttendeeController,
                  validator: (value) => value.contains(new RegExp(r'^[0-9]*[1-9]+$|^[1-9]+[0-9]*$'))?null:'*more than 1 guest required',
                  hint: "Max number of guests",
                  icon: Icon(Icons.confirmation_number,color:AppColors.secondary,),
                  onSaved: (input){
                    maxAttendees=int.parse(input);
                  },  
                ),
                SizedBox(height:20),
                FormField(
                  validator: (value)=>dateTime==null?"*Date & time are neccessary":null,
                  builder:(datecontext){
                    return dateTime==null?FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(6)
                      ),
                      color: AppColors.secondary,
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(new Duration(days: 365)) ,onChanged: (date) {
                           setState(() {
                             dateTime=date;
                           }); 
                          }, onConfirm: (date) {
                              setState(() {
                                dateTime=date;
                              }); 
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    child: Text(
                      'Event Time & Date',
                      style: TextStyle(color: AppColors.primary,fontSize:20,fontWeight: FontWeight.w700,),
                    )):
                    Container(
                      child: OutlineButton(
                        borderSide: BorderSide(color:AppColors.secondary,width:3),
                        onPressed: (){
                        DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(new Duration(days: 365)) ,onChanged: (date) {
                           setState(() {
                             dateTime=date;
                           }); 
                          }, onConfirm: (date) {
                           setState(() {
                             dateTime=date;
                           }); 
                          }, currentTime: DateTime.now(), locale: LocaleType.en);                          
                        },
                        child: Text('${DateFormat('dd-MM-yyyy  hh:mm a').format(dateTime)}',style: TextStyle(color:AppColors.primary,fontWeight:FontWeight.w500,fontSize:20),)));
                  },
                ),
                SizedBox(height:20),
                FormField(
                  validator:(value)=>_image==null?'*Must upload a photo':null,
                  onSaved:(input){imageDone=true;},
                  builder: (context){
                  return _image==null?Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 80,
                        child: IconButton(
                          icon: Icon(Icons.image,size:60,color: AppColors.secondary,),
                          onPressed:()async{
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                          }
                        ),
                      ),
                      Text('Upload event poster (vertical)',style: TextStyle(color:AppColors.primary,fontSize:20,fontWeight: FontWeight.w700),)
                    ],
                  ):
                  Column(
                    children: <Widget>[
                      Center(child: Image.file(_image,fit: BoxFit.contain,width:width*0.8,)),
                      SizedBox(height:10),
                      OutlineButton(
                        borderSide: BorderSide(color:AppColors.secondary,width:3),
                        onPressed:() async{
                          final pickedFile = await picker.getImage(source: ImageSource.gallery);
                          setState(() {
                            _image = File(pickedFile.path);
                          });                          
                        },
                        child: Text("Change banner?",style: TextStyle(color:AppColors.primary,fontWeight:FontWeight.w500,fontSize:20,fontStyle: FontStyle.italic),),
                      ),
                    ],
                  );
                }),
              ],
            )
          ),
          SizedBox(height:20),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(bottom:15.0),
              child: RaisedButton(
                onPressed:(){
                  _validateInputs();
                },
                child: Text('Create event',style: TextStyle(fontSize:20),),
                color: AppColors.tertiary,
                 ),
            ),
          )
        ],
      )     
    );
  }
}
class CongoScreen extends StatefulWidget {
  final String eventCode;
  final String eventName;
  final String eventAddress;
  final DateTime dateTime;
  final File image;
  CongoScreen(this.eventName,this.eventCode,this.eventAddress,this.image,this.dateTime,);
  @override
  _CongoScreenState createState() => _CongoScreenState();
}

class _CongoScreenState extends State<CongoScreen> {
  ConfettiController _controllerCenter;
  @override
  void initState(){
    super.initState();
   _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 3));
  }
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
     _controllerCenter.play();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:15.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton.extended(
            label: Text('Finish'),
            onPressed:(){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.play_arrow),
            tooltip: 'continue',
            backgroundColor: Colors.redAccent,
          ),
        ),
      ),
      body: Container(
        child: Center(
         child: 
          Stack(
            children: <Widget>[
              Align(
                child: ClipPath(
                  child: Container(
                    color: AppColors.tertiary,
                    height: 100,
                  ),
                  clipper: BottomWaveClipper(),
                ),
              alignment: Alignment.bottomCenter,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top:height/20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                        child: Text("Your Event is created",style:GoogleFonts.lora(textStyle:TextStyle(color:AppColors.primary,fontSize:30,fontWeight:FontWeight.w800),)),
                      ),
                    ),
                    SizedBox(height:10),
                    Text("Event Code:${widget.eventCode}",style:GoogleFonts.poppins(textStyle:TextStyle(fontSize:22,fontWeight: FontWeight.bold,color: Colors.red),)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
                      child: Text("Share the event code with your guests and they will get an entry pass for the event",style:GoogleFonts.poppins(textStyle:TextStyle(fontSize:14,fontWeight:FontWeight.w500,fontStyle: FontStyle.italic,),),textAlign: TextAlign.center,),
                    ),
                    Image.file(widget.image,width: width*0.8,height: height*0.45),
                    Text("${widget.eventName}",textAlign: TextAlign.center,style:GoogleFonts.poppins(textStyle:TextStyle(fontSize:22,fontWeight: FontWeight.bold,color: AppColors.primary),)),
                    Text("At ${widget.eventAddress}",style:GoogleFonts.poppins(textStyle:TextStyle(fontSize:16,fontWeight: FontWeight.bold),),textAlign: TextAlign.center,),
                    Text('On ${DateFormat('dd-MM-yyyy  hh:mm a').format(widget.dateTime)}',style:GoogleFonts.poppins(textStyle:TextStyle(fontSize:18,fontWeight: FontWeight.bold),)),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape:BoxShape.circle,
                        border: Border.all(color:Colors.black)
                      ),
                      child: IconButton(
                        color: AppColors.primary,
                        splashColor: AppColors.primary,
                        highlightColor: AppColors.primary,
                        icon: Icon(Icons.share,color: Colors.black,),
                        onPressed:()async{
                          await FlutterShare.share(
                            title: 'Get entry pass for ${widget.eventName}',
                            text: 'Enter the code ''${widget.eventCode}'' to get an entry pass for the ${widget.eventName} happening on ${DateFormat('dd-MM-yyyy  hh:mm a').format(widget.dateTime)}',
                            linkUrl: 'https://flutter.dev/',
                            chooserTitle: 'Get entry pass for ${widget.eventName}'
                          );
                        }),
                    ),
                    Text("Invite guests",style: TextStyle(fontWeight:FontWeight.w500),),
                    SizedBox(height:10)
                  ],
                ),
              ),              
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                 confettiController: _controllerCenter,
                 blastDirectionality: BlastDirectionality.explosive,
                 numberOfParticles: 30,
                 gravity: 0.1,
                ),
              ),          
            ],
          )
        ),
      ),
    );
  }
}

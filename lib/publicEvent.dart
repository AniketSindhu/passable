import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/firebaseAdd.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:random_string/random_string.dart';
import 'config/config.dart';
import 'config/size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart';
import 'globals.dart' as globals;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PublicEvent extends StatefulWidget {
  String uid;
  PublicEvent(this.uid);
  @override
  _PublicEventState createState() => _PublicEventState();
}

class _PublicEventState extends State<PublicEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String eventName,eventDescription,hostAddress,eventAddress,eventCode;
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CongoScreen()));
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
                  validator: (value) => value.contains(new RegExp(r'^[0-9]*[1-9]+$|^[1-9]+[0-9]*$'))?null:'*more than 1 attendee required',
                  hint: "Max number of attendees",
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
                      Text('Upload event banner',style: TextStyle(color:AppColors.primary,fontSize:20,fontWeight: FontWeight.w700),)
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
  turnfalse(){
    setState(() {
      globals.eventAddLoading=false;
    });
  }
  Widget build(BuildContext context) {
    turnfalse();
    return Scaffold(
      body: Container(
        child: Center(
         child: globals.eventAddLoading==true?
          SpinKitRotatingCircle(
            color:AppColors.secondary,
            size:50
          ):
          Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Congratulations your event is created",style: TextStyle(color:AppColors.primary,fontSize:20,fontWeight:FontWeight.w600),),
                    SizedBox(height:20),
                    Text("Invite guests using the share button below")
                  ],
                ),
              ),
              ConfettiWidget(confettiController: _controllerCenter)
            ],
          )
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/loginui.dart';

import 'config/config.dart';
import 'config/size.dart';

class PublicEvent extends StatefulWidget {
  @override
  _PublicEventState createState() => _PublicEventState();
}

class _PublicEventState extends State<PublicEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String eventName,eventDescription,hostAddress;
  final nameController=TextEditingController();
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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
            margin: EdgeInsets.symmetric(horizontal:width/15,vertical:height/15),
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
          Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child:Column(
              children: <Widget>[
                CustomTextField(
                  maxLines:1,
                  number:false,
                  radius: 5,
                  color: AppColors.secondary,
                  controller: nameController,
                  validator: (value) => value.length<2?'*must be 2 character long':null,
                  hint: "Event Name",
                  icon: Icon(Icons.sort_by_alpha,color:AppColors.secondary,),
                  onSaved: (input){
                    eventName=input;
                  },  
                )
              ],
            )
          )
        ],
      )     
    );
  }
}
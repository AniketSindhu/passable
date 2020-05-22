import 'package:flutter/material.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/signIn.dart';
import 'clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

class AskLogin extends StatefulWidget {
  @override
  _AskLoginState createState() => _AskLoginState();
}

class _AskLoginState extends State<AskLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controllEmail = TextEditingController();
  final controllPass=TextEditingController();
  final controllName=TextEditingController();
  bool _autoValidate = false;
  String _email,_pass;
  
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return "Enter valid email";
    else
      return null;
  }
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
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
    register(){
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50)),
            child: Container(
              color: AppColors.tertiary,
              child: ListView(
                children:<Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Register",style: GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize: 40,fontWeight: FontWeight.w700))),
                    )
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height/20),
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                        onSaved: (input) {
                          _email = input;
                        },
                        icon: Icon(Icons.assignment_ind),
                        hint: "Name",
                        validator:(input)=>validateEmail(input),
                        controller: controllName,
                        ),
                        SizedBox(height:20),
                        CustomTextField(
                        onSaved: (input) {
                          _email = input;
                        },
                        icon: Icon(Icons.email),
                        hint: "Email",
                        validator:(input)=>validateEmail(input),
                        controller: controllEmail,
                        ),
                        SizedBox(height:20),
                        CustomTextField(
                        onSaved: (input) {
                          _pass = input;
                        },
                        icon: Icon(Icons.perm_identity),
                        hint: "Password",
                        validator:(input)=>input.isEmpty ? "*Required" : null,
                        obsecure: true,
                        maxLines: 1,
                        controller: controllPass,
                          ),
                        SizedBox(height:20),
                        ],
                      ),
                    ),
                  Center(
                    child: RaisedButton(
                      child: Text("Login",
                        style:TextStyle(fontSize:25,color:Colors.white,fontWeight: FontWeight.w500)),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: ()=>_validateInputs(),
                      color: AppColors.secondary,
                      splashColor: AppColors.primary,
                      highlightColor: AppColors.primary,
                    ),
                  )
                ]
              ),
        )),
      );
    });
  }  
  login(){
    _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50)),
            child: Container(
              color: AppColors.tertiary,
              child: ListView(
                children:<Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Login",style: GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize: 40,fontWeight: FontWeight.w700))),
                    )
                  ),
                  SizedBox(height:MediaQuery.of(context).size.height/20),
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                        onSaved: (input) {
                          _email = input;
                        },
                        icon: Icon(Icons.email),
                        hint: "Email",
                        validator:(input)=>validateEmail(input),
                        controller: controllEmail,
                        ),
                        SizedBox(height:20),
                        CustomTextField(
                        onSaved: (input) {
                          _pass = input;
                        },
                        icon: Icon(Icons.perm_identity),
                        hint: "Password",
                        validator:(input)=>input.isEmpty ? "*Required" : null,
                        obsecure: true,
                        maxLines: 1,
                        controller: controllPass,
                          ),
                        SizedBox(height:20),
                        ],
                      ),
                    ),
                  Center(
                    child: RaisedButton(
                      child: Text("Login",
                        style:TextStyle(fontSize:25,color:Colors.white,fontWeight: FontWeight.w500)),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                      onPressed: ()=>_validateInputs(),
                      color: AppColors.secondary,
                      splashColor: AppColors.primary,
                      highlightColor: AppColors.primary,
                    ),
                  )
                ]
              ),
        )),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    double height=SizeConfig.getHeight(context);
    double width=SizeConfig.getWidth(context);
    return Scaffold(
      key:_scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children:<Widget>[
          SizedBox(height:height/20,),
          Expanded(
            child: Center(
              child:RichText(
                text: TextSpan(
                  children:<TextSpan>[
                    TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold))),
                    TextSpan(text:"it",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:45,fontWeight: FontWeight.bold))),
                    TextSpan(text:"'on",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold)))
                  ] 
                )
              ),
            ),
          ),
          SizedBox(height:height/20,),
          SvgPicture.asset(
            'assets/login.svg',
            width: width,
            height: height/3,
            ),
          SizedBox(height:height/10),
          Column(
            children: <Widget>[
              RaisedButton(
                highlightElevation: 0.0,
                splashColor: AppColors.tertiary,
                highlightColor: AppColors.tertiary,
                elevation: 0.0,
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.heebo(textStyle:TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 28))
                ),
                  onPressed: () {
                    login();
                  },
              ),
              SizedBox(height:height/40),
              OutlineButton(
                highlightedBorderColor: AppColors.tertiary,
                borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                highlightElevation: 0.0,
                splashColor: AppColors.tertiary,
                color: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                child: Text("REGISTER",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 28),),
                  onPressed: () { 
                    register();
                  },
              ),
            ],
          ),
          Expanded(
            child: Align(
              child: ClipPath(
                child: Container(
                  color: AppColors.secondary,
                  height: 300,
                ),
                clipper: BottomWaveClipper(),
              ),
            alignment: Alignment.bottomCenter,
            ),
          )
        ]
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {

  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.controller,
      this.maxLines,
      this.minLines,
      this.onSaved});
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obsecure,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        style: TextStyle(
          fontSize: 20,
          color: AppColors.primary
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: AppColors.primary),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 3,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: AppColors.primary),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 25, right: 10),
            )),
      ),
    );
  }
}
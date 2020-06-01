import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/googleSignIn.dart';
import 'package:plan_it_on/googleSignIn.dart';
import 'clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AskLogin extends StatefulWidget {
  @override
  _AskLoginState createState() => _AskLoginState();
}

class _AskLoginState extends State<AskLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controllPhone=TextEditingController(text:'+91');
  final controllName=TextEditingController();
  bool _autoValidate = false;
  String _phone,_name;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String actualCode,status;
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
void phoneSignin(String phone) async{
 
  final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    this.actualCode = verificationId;
    setState(() {
      print('Code sent to $phone');
      status = "\nEnter the code sent to " + phone;
    });
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    this.actualCode = verificationId;
    setState(() {
      status = "\nAuto retrieval time out";
    });
  };

  final PhoneVerificationFailed verificationFailed =
     (AuthException authException) {
    setState(() {
      status = '${authException.message}';
      print("Error message: " + status);
      if (authException.message.contains('not authorized'))
        status = 'Something has gone wrong, please try later';
      else if (authException.message.contains('Network'))
        status = 'Please check your internet connection and try again';
      else
        status = 'Something has gone wrong, please try later';
    });
  };

  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential auth) {
   setState(() {
     status = 'Auto retrieving verification code';
    });
    _auth
      .signInWithCredential(auth)
      .then((AuthResult value) {
        if (value.user != null) {
          setState(() {
            status = 'Authentication successful';
          });
          onAuthenticationSuccessful();
        } else {
         setState(() {
           status = 'Invalid code/invalid authentication';
         });
       }
      }).catchError((error) {
        setState(() {
         status = 'Something has gone wrong, please try later';
      });
      });
     };

      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);
    }
      MobileLogin(){
        _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.45,
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
                          child: Text("Login",style: GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize: 30,fontWeight: FontWeight.w700))),
                        )
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/35),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            CustomTextField(
                            onSaved: (input) {
                              _phone = input;
                            },
                            icon: Icon(Icons.phone),
                            hint: "Phone",
                            validator:(input)=>input.length<13?"*enter valid phone number":null,
                            controller: controllPhone,
                            ),
                            SizedBox(height:10),
                            CustomTextField(
                            onSaved: (input) {
                              _name= input;
                            },
                            icon: Icon(Icons.perm_identity),
                            hint: "Name",
                            validator:(input)=>input.isEmpty ? "*Required" : null,
                            maxLines: 1,
                            controller: controllName,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:10),
                      Center(
                        child: RaisedButton(
                          child: Text("Get OTP",
                            style:TextStyle(fontSize:22,color:Colors.white,fontWeight: FontWeight.w500)),
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
                  SignInButton(Buttons.GoogleDark, onPressed:()=>signInWithGoogle(context)),
                  SignInButton(Buttons.Facebook, onPressed:()=>MobileLogin()),
                  SizedBox(height:height/50),
                  OutlineButton(
                    highlightedBorderColor: AppColors.tertiary,
                    borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                    highlightElevation: 0.0,
                    splashColor: AppColors.tertiary,
                    color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.phone),
                          Text("Login using Phone No.",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 22),
                          ),
                        ],
                    )),
                      onPressed: () { 
                        MobileLogin();
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
    
    void onAuthenticationSuccessful() {
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
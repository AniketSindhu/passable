import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/Methods/googleSignIn.dart';
import 'package:plan_it_on/policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Widgets/clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'otpScreen.dart';


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
  String _phone;
  String _internationalPhoneNumber;
  String _phoneIsoCode;
    bool checked=false;
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      if (_internationalPhoneNumber == null) {
        Fluttertoast.showToast(
          msg:'Phone number is not valid :( ',
          backgroundColor: Colors.red,
          fontSize: 18 
        );
      }
      else{
        _formKey.currentState.save();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OTP(_internationalPhoneNumber,)));
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }} 
      else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
  void _inputChange(
    String number, String internationlizedPhoneNumber, String isoCode) {
    setState(() {
      _phoneIsoCode = isoCode;
      _phone = number;
      if (internationlizedPhoneNumber.isNotEmpty) {
        _internationalPhoneNumber = internationlizedPhoneNumber;
      }
    });
  }

      MobileLogin(){
        _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.4,
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
                          child: Text("Mobile Login",style: GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize: 30,fontWeight: FontWeight.w700))),
                        )
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/35),
                      Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Theme(
                                data: ThemeData(primaryColor: AppColors.primary,focusColor: AppColors.primary,),
                                child: InternationalPhoneInput(
                                //border: OutlineInputBorder(borderSide: BorderSide(color:AppColors.primary,width:2,style:BorderStyle.solid)),
                                  initialPhoneNumber: _phone,
                                  initialSelection: '+91',
                                  onPhoneNumberChange: _inputChange,
                                  decoration: InputDecoration(
                                    hintText: 'phone number',
                                    fillColor:AppColors.primary,
                                    focusColor: AppColors.primary,
                                    enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: BorderSide(color:AppColors.primary,width:2)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25),borderSide: BorderSide(color:AppColors.primary,width: 2.5)),
                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 18,color: AppColors.primary),
                                  ),
                                ),
                              ),
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
              Expanded(child: Image.asset('assets/logo.png',height: 70,)),
              Expanded(
                child: Center(
                  child:RichText(
                    text: TextSpan(
                      children:<TextSpan>[
                        TextSpan(text:"Pass",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold))),
                        TextSpan(text:"able",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:45,fontWeight: FontWeight.bold))),
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
                  SignInButton(Buttons.GoogleDark,
                    onPressed:(){
                      if(checked)
                        signInWithGoogle(context);
                      else
                       Fluttertoast.showToast(
                         gravity: ToastGravity.TOP,
                         msg: "Please review privacy policy first",
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white
                      );
                    }),
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
                            fontSize: 20),
                          ),
                        ],
                    )),
                      onPressed: () {
                        if(checked)
                          MobileLogin();
                        else
                         Fluttertoast.showToast(
                           gravity: ToastGravity.TOP,
                           msg: "Please review privacy policy first",
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white
                        );
                      },
                  ),
                  SizedBox(height:10),
                  CheckboxListTile(
                    title: Text.rich(TextSpan(
                      children:[
                        TextSpan(text:"You accept the"),
                        TextSpan(text:" Privacy policy",recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Policy(index:0)));
                        },style: TextStyle(color:Colors.blue,fontStyle: FontStyle.italic)),
                        TextSpan(text:', '),
                        TextSpan(text:"Terms and conditions",recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Policy(index:1)));
                        },style: TextStyle(color:Colors.blue,fontStyle: FontStyle.italic)),
                        TextSpan(text:' & '),
                        TextSpan(text:"Cancellation policy ",recognizer: TapGestureRecognizer()..onTap=(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Policy(index:2)));
                        },style: TextStyle(color:Colors.blue,fontStyle: FontStyle.italic)),
                        TextSpan(text:"of passable.")
                      ] )),
                    value: checked,
                    onChanged: (newValue) { 
                      setState(() {
                           checked = newValue; 
                         }); 
                       },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  )
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
      this.onSaved,
      this.radius,
      this.number,
      this.color,
      this.width,
      this.onChanged});

  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final bool number;
  final double radius;
  final Color color;
  final double width;

  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obsecure,
        keyboardType: number?TextInputType.number:TextInputType.text,
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
              borderRadius: BorderRadius.circular(radius==null?40:radius),
              borderSide: BorderSide(
                color: color==null?AppColors.primary:color,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius==null?40:radius),
              borderSide: BorderSide(
                color: color==null?AppColors.primary:color,
                width: width==null?3:width,
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
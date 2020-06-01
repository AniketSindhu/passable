import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/googleSignIn.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference userRef;
  String name,email;
  String uid;
  shared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid=prefs.getString('userid');
  }
  @override
  void initState() {
    super.initState();
    shared();
  }
  void getData() {
    if(uid!=null){
    userRef = Firestore.instance.collection('users').document(uid);
     userRef.get().then((snapshot){
        name=snapshot.data['name'];
        email=snapshot.data['email'];        
      });
    }
  }
      Widget build(BuildContext context) {
        double height=SizeConfig.getHeight(context);
        double width=SizeConfig.getWidth(context);
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal:width/15,vertical:height/15),
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children:<TextSpan>[
                          TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                          TextSpan(text:"it",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:35,fontWeight: FontWeight.bold))),
                          TextSpan(text:"'on",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold)))
                        ] 
                      )
                    ),
                    Icon(Icons.more_horiz,color: AppColors.primary,size:30)
                  ],
                ),
              ),
              Container(
                width: width,
                height: height/2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      'assets/event.svg',
                      semanticsLabel: 'Event Illustration'
                    ),
                  ),
                ),
              ),
              SizedBox(height: height/10,),
              Text("Add an event",style: TextStyle(color: Colors.grey[800],fontSize: 15,fontWeight: FontWeight.w500),),
              SizedBox(height: height/30,),
              IconButton(
                icon:Icon(Icons.add_circle,color:AppColors.secondary),
                iconSize: 70,
                highlightColor: AppColors.tertiary,
                splashColor: AppColors.tertiary,
                hoverColor: AppColors.tertiary,
                onPressed:() async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                signOutGoogle();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AskLogin()));
                },
              ),
              Text("$name $email")
            ],
          ),
        );
      }
    }
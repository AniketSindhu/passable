import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/Methods/firebaseAdd.dart';
import 'package:plan_it_on/Methods/getUserId.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  String phone, name , email;
  bool isGmail;
  UserInfoPage(this.phone,this.email,this.name,this.isGmail);
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _name,_country;
  bool isIndia=false;
  bool isOutside=false;
  TextEditingController _nameController=TextEditingController();
  onCountrySelect(int x){
    if(x==0)
    setState(() {
      isIndia=true;
      isOutside=false;
    });
    else
    setState(() {
      isOutside=true;
      isIndia=false;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("User details",),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal:20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('assets/userInfo.svg',height: MediaQuery.of(context).size.height/3.5,),
              ),
              SizedBox(height:30),
              Text('Where do you live?',style: TextStyle(fontSize:25,fontWeight:FontWeight.w700),),
              SizedBox(height:20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: (){
                    onCountrySelect(0);
                  },
                  child: Card(
                    elevation: 2,
                    color: isIndia?AppColors.tertiary.withOpacity(1):Colors.white,
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(child: Text('India',style: TextStyle(fontSize:18,fontWeight:FontWeight.w600),)),
                    ),
                  ),
                ),
              ),
              SizedBox(height:20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  onTap: (){
                    onCountrySelect(1);
                  },
                  child: Card(
                    elevation: 2,
                    color: isOutside?AppColors.tertiary.withOpacity(1):Colors.white,
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(child: Text('Outside India',style: TextStyle(fontSize:18,fontWeight:FontWeight.w600),)),
                    ),
                  ),
                ),
              ),
              SizedBox(height:30),
              !widget.isGmail?CustomTextField(
                icon: Icon(Icons.person),
                hint: 'Enter your full name',
                controller: _nameController,
                number: true,
                maxLines: 1,
              ):Container(),
              SizedBox(height:30),
              RaisedButton(
                child: Text("Next",
                  style:TextStyle(fontSize:22,color:Colors.white,fontWeight: FontWeight.w500)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () async{
                    if(!isOutside&&!isIndia){
                      Fluttertoast.showToast(
                        msg:'Select a location!',
                        backgroundColor: Colors.redAccent
                      );
                    }
                    else if(!widget.isGmail&&_nameController.text.trim()=='')
                      {
                        Fluttertoast.showToast(
                          msg:'Enter a valid name',
                          backgroundColor: Colors.redAccent
                        );      
                      }
                    else{
                      String uid = await getCurrentUid();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('login', true);
                      prefs.setString('userid', uid);
                      String name=widget.isGmail?widget.name:_nameController.text;
                      FirebaseAdd().addUser(name, widget.email, widget.phone, uid, isIndia);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), ModalRoute.withName('login'));
                    }
                  },
                  color: AppColors.secondary,
                  splashColor: AppColors.primary,
                  highlightColor: AppColors.primary,
              ),
            ]
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/loginui.dart';

class UserInfoPage extends StatefulWidget {
  String phone, name , email;
  UserInfoPage(this.phone,this.email,this.name);
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _name,_country;
  bool isIndia=false;
  bool isOutside=false;
  TextEditingController _nameController=TextEditingController();
  onCountrySelect(){
    setState(() {
      isIndia=!isOutside;
      isOutside=!isIndia;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Login",),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            CustomTextField(
              icon: Icon(Icons.assignment_ind),
              hint: 'Name',
              controller: _nameController,
              number: true,
              maxLines: 1,
            ),
            SizedBox(height:20),
            Text('Where do you live?',style: GoogleFonts.novaFlat(fontSize:18,fontWeight:FontWeight.w700),),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: (){
                  onCountrySelect();
                },
                child: Card(
                  elevation: 5,
                  color: Colors.grey[100],
                  child:Stack(
                    children:<Widget>[
                      Container(
                        color:!isIndia?Colors.green.withOpacity(0.6):Colors.green.withOpacity(0)
                      ),
                      Text('India',style: TextStyle(fontSize:16,fontWeight:FontWeight.w600),)
                    ]
                  ),
                ),
              ),
            ),
            SizedBox(height:10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: (){
                  onCountrySelect();
                },
                child: Card(
                  elevation: 5,
                  color: Colors.grey[100],
                  child:Stack(
                    children:<Widget>[
                      Container(
                        color:!isOutside?Colors.green.withOpacity(0.6):Colors.green.withOpacity(0)
                      ),
                      Text('Outside India',style: TextStyle(fontSize:16,fontWeight:FontWeight.w600),)
                    ]
                  ),
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
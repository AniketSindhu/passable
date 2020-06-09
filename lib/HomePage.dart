import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_it_on/JoinedEvents.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/googleSignIn.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:plan_it_on/publicEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HostedEvents.dart';
import 'config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference userRef;
  String name,email;
  String uid;
  int _selectedIndex=0;
  shared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid=prefs.getString('userid');
  }
  @override
  void initState() {
    super.initState();
    shared();
  }
  void getData() async{
    if(uid!=null){
    userRef = Firestore.instance.collection('users').document(uid);
    await userRef.get().then((snapshot){
      if(mounted)
      setState(() {
        name=snapshot.data['name'];
        email=snapshot.data['email'];           
      });       
      });
    }
  }
  Future getAllEvents() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn= await firestore.collection('events').orderBy('dateTime').getDocuments();
    return qn.documents;
  }
      Widget build(BuildContext context) {
        double height=SizeConfig.getHeight(context);
        double width=SizeConfig.getWidth(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.tertiary,
            onPressed: (){
             showDialog(
               context: context,
              builder: (context){
                return AlertDialog(
                  backgroundColor: AppColors.secondary,
                   title: Center(child: Text("What type of event?",style: GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize: 25,fontWeight: FontWeight.w700)))),
                   content: Container(
                     height: height/4,
                     child:Center(
                       child: Column(
                         children: <Widget>[
                           OutlineButton(
                             onPressed: (){Navigator.push(context, MaterialPageRoute(builder:(context)=>PublicEvent(uid)));},
                             child: Text("Public event",style:TextStyle(color:Colors.white,fontSize:25,fontWeight: FontWeight.w500)),
                             color: AppColors.tertiary,
                             borderSide: BorderSide(color:AppColors.tertiary,width:4),
                             splashColor: AppColors.primary,                      
                           ),
                           SizedBox(height: height/60),
                           Text("OR",style:TextStyle(color:Colors.white,fontSize:25,fontWeight: FontWeight.w800)),
                           SizedBox(height: height/60),
                           OutlineButton(
                             onPressed: (){},
                             child: Text("Private event",style:TextStyle(color:Colors.white,fontSize:25,fontWeight: FontWeight.w500)),
                             color: AppColors.tertiary,
                             borderSide: BorderSide(color:AppColors.tertiary,width:4),  
                             splashColor: AppColors.primary,                               
                           )                                
                         ],
                       ),
                     )
                   ),
                 );
               }
             );
            },
            label: Text("Host an event",style: TextStyle(fontWeight:FontWeight.w500),),
            icon: Icon(Icons.add),),
          bottomNavigationBar: BottomNavyBar(
           selectedIndex: _selectedIndex,
           showElevation: true,
           curve: Curves.ease, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.apps),
                title: Text('Upcoming'),
                activeColor: Colors.red,
              ),
               BottomNavyBarItem(
                   icon: Icon(Icons.people),
                   title: Text('Hosted'),
                   activeColor: Colors.purpleAccent
               ),
               BottomNavyBarItem(
                   icon: Icon(Icons.message),
                   title: Text('Joined'),
                   activeColor: Colors.pink
              ),
            ],
          ),
          resizeToAvoidBottomPadding: false,
          body: 
          _selectedIndex==1?
          ListView(
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
                    PopupMenuButton(
                      icon:Icon(Icons.more_horiz,color: AppColors.primary,size:30),
                      color: AppColors.primary,
                      itemBuilder: (context){
                        var list=List<PopupMenuEntry<Object>>();
                        list.add(PopupMenuItem(child: Text("Profile",style: TextStyle(color:AppColors.tertiary),)));
                        list.add(PopupMenuDivider(height: 4,));
                        list.add(PopupMenuItem(
                          child: Text("Logout",style: TextStyle(color:AppColors.tertiary),),
                          value: 2,
                        ));
                        return list;
                      },
                      onSelected:(value)async{
                        if(value==2)
                        {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          signOutGoogle();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AskLogin()),ModalRoute.withName('homepage'));
                        }
                      },
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: getAllEvents(),
                builder: (BuildContext context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60));
                  }

                  else
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.all(10),
                    itemBuilder: (context,index){
                      return Stack(
                        children: [
                          Image.network(snapshot.data[index].data['eventBanner'],height:300,width: width,),
                          Positioned(
                            left:0,
                            top:20,
                            child: Card(
                              child: Column(
                                children:<Widget>[
                                  Center(child: Text("${snapshot.data[index].data['eventName']}")),
                                  Text("Address:${snapshot.data[index].data['eventAddress']}")
                                ]
                              ),
                              color: Colors.white,
                            ),)
                        ], 
                      );
                  });
              })
            ],
          ):
          _selectedIndex==2?
          HostedEvents():JoinedEvents()
        );
      }
    }
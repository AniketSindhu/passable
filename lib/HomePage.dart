import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_it_on/JoinedEvents.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/googleSignIn.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:plan_it_on/publicEvent.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HostedEvents.dart';
import 'Pass.dart';
import 'config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference userRef;
  String name,email;
  String uid;
  int _selectedIndex=0;
  TextEditingController eventCodeController=TextEditingController();
  String writtenCode,passCode;
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
    QuerySnapshot qn= await firestore.collection('events').orderBy('eventDateTime').getDocuments();
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
          _selectedIndex==0?
          Column(
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
                builder: (BuildContext context1,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Expanded(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)));
                  }
                  if(snapshot.data.length==0){
                  return Column(
                    children: [
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
                      SizedBox(height:height/20),
                      Text("Nothing to show up here :(")
                    ],
                  );}
                  else
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                        const SizedBox(height: 20.0),  
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.symmetric(horizontal:10),
                      itemBuilder: (context,index){
                        return Stack(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context:context,
                                    builder: (context){
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        scrollable: true,
                                        backgroundColor:AppColors.secondary,
                                        title: Center(child: Text("Get Entry Pass",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w700,fontSize:30),)),
                                        content: Container(
                                          height: height/5,
                                         child: Column(
                                           children: [
                                             TextField(
                                               controller: eventCodeController,
                                               textAlign: TextAlign.center,
                                                style: TextStyle(color: AppColors.primary,fontSize: 25,fontWeight: FontWeight.w500),
                                                cursorColor: AppColors.primary,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  hintText:"Enter event code"
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: RaisedButton(
                                                    onPressed:() async{
                                                     final x= await Firestore.instance.collection('users').document(uid).collection('eventJoined').document(snapshot.data[index].data['eventCode']).get();
                                                      if(snapshot.data[index].data['eventCode']!=eventCodeController.text)
                                                        print("wrong code entered");
                                                      else if(snapshot.data[index].data['joined']>=snapshot.data[index].data['maxAttendee'])
                                                        print('Event Full');
                                                      else if(x.exists)
                                                        {
                                                          print('Already Joined');
                                                        }
                                                      else
                                                      { passCode= randomAlphaNumeric(6);
                                                        Firestore.instance.collection("events").document(snapshot.data[index].data['eventCode']).collection('guests').document(passCode).setData({'user':uid,'passCode':passCode,'Scanned':false});
                                                        Firestore.instance.collection('users').document(uid).collection('eventJoined').document(snapshot.data[index].data['eventCode']).setData({'eventCode':snapshot.data[index].data['eventCode'],'passCode':passCode});
                                                        Firestore.instance.collection('events').document(snapshot.data[index].data['eventCode']).updateData({'joined': snapshot.data[index].data['joined']+1});
                                                        Navigator.pop(context);
                                                        Navigator.push(context, MaterialPageRoute(builder: (context){return Pass(passCode,snapshot.data[index]);}));
                                                      }
                                                    },
                                                    textColor: AppColors.primary,
                                                    child: Text("Get Pass",style: TextStyle(fontWeight:FontWeight.w600,fontSize:20),),
                                                    elevation: 10,
                                                    color: AppColors.tertiary,
                                                  ),
                                                ),
                                              )
                                           ],
                                         )
                                        ),
                                      );
                                    }
                                  ).then((value) {
                                    eventCodeController.clear();
                                  });
                                },
                                child: Card(   
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(12)),),                          
                                  elevation: 20,
                                  child:ClipRRect(
                                    borderRadius:BorderRadius.all(Radius.circular(12)),
                                    child: Image.network(snapshot.data[index].data['eventBanner'],width:width*0.9,fit: BoxFit.fill,))
                                ),
                              ),
                            ),
                            Positioned(
                              left:10,
                              top:100,
                              child: Container(
                                width: width*0.6,
                                child: Column(
                                  children:<Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 2),
                                      child: Center(child: Text("${snapshot.data[index].data['eventName']}",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w800,color:AppColors.primary,fontSize: 20),),textAlign: TextAlign.center,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(child:Text('${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data[index].data['eventDateTime'].toDate())}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)),
                                    ),   
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${snapshot.data[index].data['eventAddress']}",textAlign: TextAlign.center,style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize: 12))),
                                    )
                                  ]
                                ),
                                color: AppColors.secondary,
                              ),
                            )
                          ], 
                        );
                    }),
                  );
              })
            ],
          ):
          _selectedIndex==1?
          HostedEvents():JoinedEvents(uid)
        );
      }
    }
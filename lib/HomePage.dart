import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:place_picker/place_picker.dart' as latlng;
import 'package:plan_it_on/EventDetails.dart';
import 'package:plan_it_on/JoinedEvents.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/Methods/googleSignIn.dart';
import 'package:plan_it_on/loginui.dart';
import 'package:plan_it_on/publicEvent.dart';
import 'package:plan_it_on/search.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HostedEvents.dart';
import 'config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flushbar/flushbar.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference userRef;
  String name,email;
  String uid;
  int _selectedIndex=0;
  Position location;
  GeoFirePoint firePoint;
  List<Placemark> placemark;
  Flushbar flush;
  String city;
  Geoflutterfire geo = Geoflutterfire();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  shared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid=prefs.getString('userid');
  }
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  getLocation()async{
    var geolocator = Geolocator();
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          setState(() {
            location= position;
            Geoflutterfire geo = Geoflutterfire();
            firePoint = geo.point(
              latitude: location.latitude,
              longitude: location.longitude);
          });
      }).catchError((e){
        setState(() {
          firePoint=geo.point(latitude: 28.7041, longitude: 77.1025);
        });
        flush=Flushbar<bool>(
          title: 'Location Not Allowed!',
          message: "Allow location or select the location of your choice to get events",  
          icon: Icon(Icons.info,color: Colors.amber),
          backgroundColor: Colors.redAccent[100],
          mainButton: FlatButton(
            onPressed:(){
              flush.dismiss(true);
              getLocation();  
            },
            child:Text("Allow Location",style: TextStyle(color:Colors.amber),)
          ),
        )..show(context);
      });
    placemark=await Geolocator().placemarkFromPosition(location);
    Placemark place = placemark[0];
    setState(() {
      city="${place.administrativeArea}";
    });
  }
  Stream getEvents() {
    Geoflutterfire geo = Geoflutterfire();
    var collectionReference = Firestore.instance.collection('events').where('eventLive',isEqualTo:true);
    String field = 'position';
    Stream<List<DocumentSnapshot>> stream1;
    if (geo != null&&firePoint!=null) {
      stream1 = geo.collection(collectionRef: collectionReference).within(
          center: firePoint,
          radius: 50,
          field: field,
          strictMode: false);
    }
    return stream1;
  }
  @override
  void initState() {
    super.initState();
    shared();
    getLocation();
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
      Widget build(BuildContext context) {
        double height=SizeConfig.getHeight(context);
        double width=SizeConfig.getWidth(context);
        return Scaffold(
          floatingActionButton: _selectedIndex==0?FloatingActionButton.extended(
            backgroundColor: AppColors.tertiary,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>PublicEvent(uid)));
            },
            label: Text("Host an event",style: TextStyle(fontWeight:FontWeight.w500),),
            icon: Icon(Icons.add),)
            :null,
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
                   icon: Icon(Icons.search),
                   title: Text('Search'),
                   activeColor: Colors.orange[800]
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
          CustomScrollView(
            slivers:<Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              title: Container(
                margin: EdgeInsets.only(left:width/50,top:height/15,right:width/50,bottom:height/30),
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children:<TextSpan>[
                          TextSpan(text:"Pass'",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.primary,fontSize:35,fontWeight: FontWeight.bold))),
                          TextSpan(text:"able",style:GoogleFonts.lora(textStyle:TextStyle(color: AppColors.secondary,fontSize:35,fontWeight: FontWeight.bold))),
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
              collapsedHeight: 65,
              expandedHeight: 110,
              pinned: true,
              floating: true,
              flexibleSpace:Container(
                padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top+70),
                height: MediaQuery.of(context).padding.top+110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.only(left:width/18,bottom:10),
                      child:Align(
                        child: GestureDetector(
                          onTap:()async{
                            Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => PlacePicker(
                                 apiKey: FlutterConfig.get('MAP_API_kEY'),   // Put YOUR OWN KEY here.
                                 onPlacePicked: (result) { 
                                  setState(() {
                                    city="${result.addressComponents.elementAt(2).longName}";
                                    firePoint=geo.point(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng);
                                  }); 
                                    Navigator.of(context).pop();
                                  },
                                  initialPosition:latlng.LatLng(28.7041, 77.1025),
                                  useCurrentLocation: true,
                                ),
                              ),
                            );  
                          },
                          child: Text("${city==null?'Awaiting Location':city}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color:Colors.redAccent,fontStyle: FontStyle.italic,decoration: TextDecoration.underline),)),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:16.0,bottom: 10.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Upcoming Nearby Events",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color:Colors.redAccent),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: getEvents(),
              builder: (BuildContext context1,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting&&snapshot.data==null)
                {
                  return SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)));
                }
                else if(snapshot.hasData){
                if(snapshot.data.length==0){
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
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
                    ),
                  ),
                );}
                else
                return SliverList(
                  delegate:SliverChildBuilderDelegate((context,index){
                    return Padding(
                      padding: EdgeInsets.only(bottom:20),
                      child: Stack(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){return DetailPage(0, snapshot.data[index], uid);}));
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
                      ),
                    );
                },
                childCount: snapshot.data.length,
                )
              );
            }
            else
             return SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)));
            })],
          ):
          _selectedIndex==1?
          SearchPage():_selectedIndex==2?HostedEvents(uid):JoinedEvents(uid)
        );
      }
    }
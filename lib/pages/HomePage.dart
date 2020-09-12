import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:place_picker/place_picker.dart' as latlng;
import 'package:plan_it_on/pages/EventDetails.dart';
import 'package:plan_it_on/pages/JoinedEvents.dart';
import 'package:plan_it_on/Methods/getUserId.dart';
import 'package:plan_it_on/config/size.dart';
import 'package:plan_it_on/Methods/googleSignIn.dart';
import 'package:plan_it_on/pages/loginui.dart';
import 'package:plan_it_on/pages/search.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flushbar/flushbar.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  DocumentReference userRef;
  String name,email;
  String uid;
  int _selectedIndex=0;
  Position location;
  GeoFirePoint firePoint;
  List<Placemark> placemark;
  Flushbar flush;
  String city;
  FancyDrawerController _controller;
  Geoflutterfire geo = Geoflutterfire();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String selectedCat;
  List<DropdownMenuItem> categoryList=[
    DropdownMenuItem(
      child: Text('All Events',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'All Events',
    ),
    DropdownMenuItem(
      child: Text('Appearance/Singing',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Appearance/Singing',
    ),
    DropdownMenuItem(
      child: Text('Attaraction',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Attaraction',
    ),
    DropdownMenuItem(
      child: Text('Camp, Trip or Retreat',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Camp, Trip or Retreat',
    ),
    DropdownMenuItem(
      child: Text('Class, Training, or Workshop',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Class, Training, or Workshop',
    ),
    DropdownMenuItem(
      child: Text('Concert/Performance',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Concert/Performance',
    ),
    DropdownMenuItem(
      child: Text('Conference',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Conference',
    ),
    DropdownMenuItem(
      child: Text('Convention',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Convention',
    ),
    DropdownMenuItem(
      child: Text('Dinner or Gala',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Dinner or Gala',
    ),
    DropdownMenuItem(
      child: Text('Festival or Fair',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Festival or Fair',
    ),
    DropdownMenuItem(
      child: Text('Game or Competition',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Game or Competition',
    ),
    DropdownMenuItem(
      child: Text('Meeting/Networking event',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Meeting/Networking event',
    ),
    DropdownMenuItem(
      child: Text('Party/Social Gathering',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Party/Social Gathering',
    ),
    DropdownMenuItem(
      child: Text('Other',style: GoogleFonts.cabin(fontWeight: FontWeight.w800, fontSize: 20,color: AppColors.primary),),
      value: 'Other',
    ),
  ];

  void getUser() async{
    uid= await getCurrentUid();
    setState(() {  
    });
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
  Stream getEvents(String val) {
    Geoflutterfire geo = Geoflutterfire();
    if(val==null||val=='All Events'){
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
    else{
      var collectionReference = Firestore.instance.collection('events').where('eventLive',isEqualTo:true).where('eventCategory',isEqualTo:val);
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
  }
  @override
  void initState() {
    super.initState();
    _controller = FancyDrawerController(
      vsync: this, duration: Duration(milliseconds: 250))
    ..addListener(() {
      setState(() {}); // Must call setState
    });
    getUser();
    getLocation();
  }

  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
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
        return FancyDrawerWrapper(
          controller: _controller,
          backgroundColor: AppColors.tertiary,
          drawerItems: <Widget>[
            Card(
              color: Colors.cyan,
              child: Container(
                width: width*0.5,
                child: ListTile(
                 title:Text(
                   "Host an event",
                   style: TextStyle(
                     fontSize: 18,
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 leading: Icon(Icons.event,color: Colors.black),
                ),
              ),
            ),
            Card(
              color: AppColors.secondary,
              child: Container(
                width: width*0.5,
                child: ListTile(
                  onTap: (){
                    launch('https://docs.google.com/forms/d/e/1FAIpQLSdH83WOnp3bSOuw9BoNXJ0cjT-ikkCjwBUyWttqmDyQvJC2Vw/viewform?usp=sf_link');
                  },
                 title:Text(
                   "Work with us",
                   style: TextStyle(
                     fontSize: 18,
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 leading: Icon(Icons.laptop,color: Colors.black),
                ),
              ),
            ),
            Card(
              color: Colors.red,
              child: Container(
                width: width*0.5,
                child: ListTile(
                onTap:() async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AskLogin()),ModalRoute.withName('homepage'));
                } ,
                 title:Text(
                   "Log out",
                   style: TextStyle(
                     fontSize: 18,
                     color: Colors.white,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 leading: Icon(Icons.album),
                ),
              ),
            ),
          ],
          child: Scaffold(
            bottomNavigationBar: BottomNavyBar(
             selectedIndex: _selectedIndex,
             showElevation: true,
             curve: Curves.ease, // use this to remove appBar's elevation
              onItemSelected: (index) => setState(() {
                _selectedIndex = index;
              }),
              items: [
                BottomNavyBarItem(
                  icon: Icon(Icons.event),
                  title: Text('Offline Events'),
                  activeColor: Colors.red,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.laptop),
                  title: Text('Online Events'),
                  activeColor: Colors.indigo,
                ),
                BottomNavyBarItem(
                     icon: Icon(Icons.search),
                     title: Text('Search'),
                     activeColor: Colors.orange[800]
                 ),
                 BottomNavyBarItem(
                     icon: Icon(FlutterIcons.ticket_alt_faw5s),
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
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _controller.toggle();
                  },
                ),
                title: Container(
                  margin: EdgeInsets.only(left:width/50,top:height/15,right:width/50,bottom:height/30),
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child: Image.asset('assets/logo.png',height: 50,)),
                          IconButton(
                            icon:Icon(Icons.tune,color: AppColors.primary,size:25),
                            color: AppColors.primary,
                            onPressed: (){
                              showDialog(
                              context:context,
                               builder: (context){
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  scrollable: true,
                                  backgroundColor:AppColors.secondary,
                                  title: Center(child: Text("Filter",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w700,fontSize:30),)),
                                  content: Container(
                                   height: height/5,
                                   child: Column(
                                     children: [
                                        DropdownButtonFormField(   
                                          items: categoryList,
                                          value: selectedCat,
                                          decoration: InputDecoration(
                                              labelStyle: GoogleFonts.cabin(fontWeight: FontWeight.w600, fontSize: 20,color: AppColors.primary),
                                              labelText: 'Category of the event',
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              selectedCat=value;
                                            });
                                          },
                                        ),
                                         Expanded(
                                           child: Center(
                                             child: RaisedButton(
                                               onPressed:() {
                                                 Navigator.pop(context);
                                               },
                                             textColor: AppColors.primary,
                                              child: Text(" Apply Filter",style: TextStyle(fontWeight:FontWeight.w600,fontSize:20),),
                                              elevation: 10,
                                              color: AppColors.tertiary,
                                            ),
                                         ),
                                        )
                                     ],
                                   )
                                  ),
                                );
                              });
                            },
                            splashColor: Colors.purple,
                          )
                        ],
                      ),
                      SizedBox(height:20)
                    ],
                  ),
                ),
                expandedHeight: 110,
                pinned: true,
                floating: true,
                flexibleSpace:FlexibleSpaceBar(
                    background: Container(
                    color: Colors.white,
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
                                     apiKey:'AIzaSyAJBaI8jdFjekZnRgtJ10DsNVF3RuSfXfc',
                                     //apiKey: FlutterConfig.get('MAP_API_kEY'),   // Put YOUR OWN KEY here.
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
              ),
              uid!=null?StreamBuilder(
                stream: getEvents(selectedCat),
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
                          Text("No events nearby you :(")
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
                                      padding: const EdgeInsets.all(4),
                                      child: Center(child:Text('Type: ${snapshot.data[index].data['eventCategory']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)),
                                    ),  
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text("${snapshot.data[index].data['eventAddress']}",textAlign: TextAlign.center,style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize: 14))),
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
              }):SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)))
              ],
            ):
            _selectedIndex==1?
            CustomScrollView(
              slivers:<Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _controller.toggle();
                  },
                ),
                backgroundColor: Colors.white,
                title: Container(
                  margin: EdgeInsets.only(left:width/50,top:height/15,right:width/50,bottom:height/30),
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child: Image.asset('assets/logo.png',height: 50,)),
                          IconButton(
                            icon:Icon(Icons.tune,color: AppColors.primary,size:25),
                            color: AppColors.primary,
                            onPressed: (){
                              showDialog(
                              context:context,
                               builder: (context){
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  scrollable: true,
                                  backgroundColor:AppColors.secondary,
                                  title: Center(child: Text("Filter",style: TextStyle(color:Colors.white,fontWeight:FontWeight.w700,fontSize:30),)),
                                  content: Container(
                                   height: height/5,
                                   child: Column(
                                     children: [
                                        DropdownButtonFormField(   
                                          items: categoryList,
                                          value: selectedCat,
                                          decoration: InputDecoration(
                                              labelStyle: GoogleFonts.cabin(fontWeight: FontWeight.w600, fontSize: 20,color: AppColors.primary),
                                              labelText: 'Category of the event',
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              selectedCat=value;
                                            });
                                          },
                                        ),
                                         Expanded(
                                           child: Center(
                                             child: RaisedButton(
                                               onPressed:() {
                                                 Navigator.pop(context);
                                               },
                                             textColor: AppColors.primary,
                                              child: Text(" Apply Filter",style: TextStyle(fontWeight:FontWeight.w600,fontSize:20),),
                                              elevation: 10,
                                              color: AppColors.tertiary,
                                            ),
                                         ),
                                        )
                                     ],
                                   )
                                  ),
                                );
                              });
                            },
                            splashColor: Colors.purple,
                          )
                        ],
                      ),
                      SizedBox(height:20)
                    ],
                  ),
                ),
                expandedHeight: 110,
                pinned: true,
                floating: true,
                flexibleSpace:FlexibleSpaceBar(
                    background: Container(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top+70),
                    height: MediaQuery.of(context).padding.top+110,
                    child:Padding(
                          padding: const EdgeInsets.only(right:16.0,bottom: 10.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Online Events",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color:Colors.redAccent),),
                          ),
                        ),
                  ),
                ),
              ),
              uid!=null?StreamBuilder(
                stream: selectedCat==null||selectedCat=='All Events'?Firestore.instance.collection('OnlineEvents').where('eventLive',isEqualTo:true).snapshots():Firestore.instance.collection('OnlineEvents').where('eventLive',isEqualTo:true).where('eventCategory',isEqualTo: selectedCat).snapshots(),
                builder: (BuildContext context1,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting&&snapshot.data==null)
                  {
                    return SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)));
                  }
                  else if(snapshot.hasData){
                  if(snapshot.data.documents.length==0){
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
                          Text("No events Found :(")
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context){return DetailPage(0, snapshot.data.documents[index], uid);}));
                                },
                                child: Card(   
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(12)),),                          
                                  elevation: 20,
                                  child:ClipRRect(
                                    borderRadius:BorderRadius.all(Radius.circular(12)),
                                    child: Image.network(snapshot.data.documents[index].data['eventBanner'],width:width*0.9,fit: BoxFit.fill,))
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
                                      child: Center(child: Text("${snapshot.data.documents[index].data['eventName']}",style:GoogleFonts.poppins(textStyle:TextStyle(fontWeight:FontWeight.w800,color:AppColors.primary,fontSize: 20),),textAlign: TextAlign.center,)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(child:Text('${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data.documents[index].data['eventDateTime'].toDate())}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(child:Text('Type: ${snapshot.data.documents[index].data['eventCategory']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)),
                                    ),
                                  ]
                                ),
                                color: AppColors.secondary,
                              ),
                            )
                          ], 
                        ),
                      );
                  },
                  childCount: snapshot.data.documents.length,
                  )
                );
              }
              else
               return SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)));
              }):SliverFillRemaining(child: Center(child: SpinKitChasingDots(color:AppColors.secondary,size:60)))
              ],
            ):_selectedIndex==2?
            SearchPage():JoinedEvents(uid)
          ),
        );
      }
    }
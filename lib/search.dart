import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_it_on/Widgets/eventCard.dart';
import 'package:plan_it_on/config/config.dart';
import 'package:plan_it_on/config/size.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
  double height=SizeConfig.getHeight(context);
  double width=SizeConfig.getWidth(context);
  TextEditingController searchController= TextEditingController();
  String query='';
  Stream q;
  onSearch(String val) async{
    setState(() {
      q= Firestore.instance.collection('events').where('eventName',isGreaterThanOrEqualTo:val).snapshots();
    });
  }
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Column(  
          children:<Widget>[
            Container(
              margin: EdgeInsets.only(left:width/15,top:height/15,right:width/15,bottom:height/30),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search',style: GoogleFonts.lora(fontSize:35,fontWeight:FontWeight.w800,color: AppColors.primary),),
                  Text('any event by name',style: GoogleFonts.lora(fontSize:25,fontWeight:FontWeight.w500,color: AppColors.secondary,fontStyle: FontStyle.italic)),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:25.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText:'Search',
                  hintStyle: GoogleFonts.lora(fontWeight:FontWeight.w500,color: Colors.black,),
                  helperText: 'type the name of the event you want to search',
                  prefixIcon:Icon(Icons.search,color: Colors.black,),
                  border: OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide(color:Colors.black)),
                  enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide:BorderSide(color:Colors.black)),
                ),
                onChanged: (val){
                  onSearch(val);
                  setState(() {
                    query=val;
                  });
                  print(query);
                },
              ),
            ),
            StreamBuilder(
              stream: q,
              builder: (context, snapshot) {
                if(query==null||query==''){
                  print('yo');
                  return Container();
                }
                else if(snapshot.connectionState==ConnectionState.waiting||!snapshot.hasData)
                  return SpinKitChasingDots(color:AppColors.secondary);
                else{
                  if(snapshot.data.documents.length==0)
                    {
                      print(2);
                      return Container(
                        child:Text('no results',style: TextStyle(color: Colors.black,)
                      ));
                    }
                  else
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context,index){
                        print(1);
                        return eventCard(snapshot.data.documents[index], height, width, 0, context);
                      }
                    );
                }
              }
            )
          ]
        ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/config.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lottie/lottie.dart';

class ScanPass extends StatefulWidget {
  final String eventCode;
  ScanPass(this.eventCode);
  @override
  _ScanPassState createState() => _ScanPassState();
}

class _ScanPassState extends State<ScanPass> {
  void scanPass(BuildContext contextMain)async{
    String res=await FlutterBarcodeScanner.scanBarcode("#ff6666", 'Stop Scan', true, ScanMode.QR);
    final x=await Firestore.instance.collection('events').document(widget.eventCode).collection('guests').document(res).get();
    if(x.exists)
     {
       if(x.data['Scanned']==false)
        {
          Firestore.instance.collection('events').document(widget.eventCode).collection('guests').document(res).updateData({'Scanned':true});
          showDialog(
            context:contextMain,
            builder: (context){
              return AlertDialog(
                backgroundColor: Colors.grey[900],
                scrollable: true,
                actions: [
                  RaisedButton(
                    onPressed:(){
                      Navigator.pop(context);
                      scanPass(contextMain);
                      },
                    child:Text('Scan More'),color:AppColors.tertiary
                  ),
                  RaisedButton(
                    onPressed:(){
                      Navigator.pop(context);
                      },
                    child:Text('Stop Scanning'),color:AppColors.tertiary
                  ),
                ],
                title: Center(child: Text("Pass scanned",style:TextStyle(color: Colors.greenAccent,fontSize: 24,fontWeight: FontWeight.bold))),
                content: Container(
                  child: Column(
                    children: [
                      Lottie.asset('assets/done.json',repeat: false),
                      SizedBox(height:10),
                      Text("Entry is allowed",style:TextStyle(color: Colors.greenAccent,fontSize: 18,fontWeight: FontWeight.bold)),
                    ],
                  )
                ),
              );
            }
          );
        }
        else
        showDialog(
          context: contextMain,
          builder: (context){
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              scrollable: true,
              title: Center(child: Text("Pass Already Scanned",style: TextStyle(color:Colors.red,fontWeight:FontWeight.w700,fontSize:24),)),
              actions: [
                 RaisedButton(
                  onPressed:(){
                    Navigator.pop(context);
                    scanPass(contextMain);
                  },
                  child:Text('Scan More'),color:AppColors.tertiary
                ),
                RaisedButton(
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  child:Text('Stop Scanning'),color:AppColors.tertiary
                ),
              ],
              content: Container(
                child:Column(
                  children: [
                    Lottie.asset('assets/failed.json'),
                    SizedBox(height:10),
                    Text("Entry is not allowed",style:TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                )
              ),
            );
          }
        );
     }
     if(x.exists==false)
      showDialog(
        context: contextMain,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            scrollable: true,
            title: Center(child: Text("Pass Not Found in Records",style: TextStyle(color:Colors.red,fontWeight:FontWeight.w700,fontSize:22),textAlign: TextAlign.center,)),
            actions: [
              RaisedButton(
                onPressed:(){
                  Navigator.pop(context);
                  scanPass(contextMain);
                },
                child:Text('Scan More'),color:AppColors.tertiary
              ),
              RaisedButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                child:Text('Stop Scanning'),color:AppColors.tertiary
              ),
            ],
            content: Container(
              child:Column(
                children: [
                  Lottie.asset('assets/failed.json'),
                  SizedBox(height:10),
                  Text("Entry is not allowed",style:TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold)),
                ],
              )
             ),
          );
        }
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Scan passes',),),
      body:SingleChildScrollView(
        child: Container(
          child:Center(
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:12,right:12,top:20),
                  child: Text('Instructions for QR scan ',style: GoogleFonts.varelaRound(textStyle:TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold,fontSize: 26)),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10,right:10),
                  child: Divider(color:AppColors.secondary,height: 15,thickness: 2,),
                ),
                Lottie.asset('assets/qrAnim.json'),
                SizedBox(height:10),
                Text('1.Hold the phone in verticle position.',style: TextStyle(fontSize:16),),
                SizedBox(height:5),
                Text('2.Center the QR code on the camera frame',style: TextStyle(fontSize:16),),
                SizedBox(height:5),
                Text('3.Wait until the pass is scanned',style: TextStyle(fontSize:16),),
                SizedBox(height:10),
                RaisedButton(
                  onPressed: (){
                    scanPass(context);
                  },
                  child: Text('Start Scaning',style: TextStyle(fontSize:18,fontWeight:FontWeight.w700),),
                  color: AppColors.tertiary,
                  splashColor: AppColors.primary,
                ),
              ],
            )
          )
        ),
      )
    );
  }
}
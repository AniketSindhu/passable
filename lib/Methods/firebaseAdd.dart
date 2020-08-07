import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globals.dart' as globals;
import '../publicEvent.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:random_string/random_string.dart';
class FirebaseAdd{

  addUser(String name,String email, String phoneNumber,String uid){
    Firestore.instance.collection('users').document(uid)
    .setData({ 'name': name, 'email': email,'phoneNumber': phoneNumber,'uid':uid,},merge: true);
}
  addEvent (String eventName,String eventCode,String eventDescription,String eventAddress,int maxAttendee,File _image,DateTime dateTime,String uid,GeoFirePoint eventLocation) async {
    
    String _uploadedFileURL;
    String fileName = "Banners/$eventCode";
    globals.eventAddLoading=true;

    StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(taskSnapshot);
    await firebaseStorageRef.getDownloadURL().then((fileURL) async {
        _uploadedFileURL = fileURL;
      });

  List splitName= eventCode.split(' ');
  List eventNameArr=[];

  for(int i=0;i<splitName.length;i++){
    String name=splitName[i];
    for(int j=1;j<=name.length;j++)
     eventNameArr.add(name.substring(0,j).toLowerCase());
  }

  Firestore.instance.collection('users').document(uid).collection('eventsHosted').document(eventCode)
    .setData({'eventCode':eventCode});
  
  await Firestore.instance.collection('events').document(eventCode).setData({
      'eventCode':eventCode,
      'eventName':eventName,
      'eventDescription':eventDescription,
      'eventAddress':eventAddress,
      'maxAttendee':maxAttendee,
      'eventDateTime':dateTime,
      'eventBanner':_uploadedFileURL,
      'eventNameArr':eventNameArr,
      'joined':0,
      'scanDone':0,
      'position':eventLocation.data,
      'eventLive':true
    });
  }

  Future<bool> announce(String eventCode,String description,File image) async{
    String _uploadedFileURL;
    if(image!=null){
    StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("$eventCode/${randomAlphaNumeric(8)}");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(taskSnapshot);
    await firebaseStorageRef.getDownloadURL().then((fileURL) async {
        _uploadedFileURL = fileURL;
      });
    }
    String id=randomAlphaNumeric(8);
    Firestore.instance.collection("events").document(eventCode).collection('Announcements').document(id).setData({
      'description':description,
      'media':_uploadedFileURL,
      'timestamp':DateTime.now(),
      'id':id
    });
    return true;
  }
}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;
import 'publicEvent.dart';
class FirebaseAdd{

  addUser(String name,String email, String phoneNumber,String uid){
    Firestore.instance.collection('users').document(uid)
    .setData({ 'name': name, 'email': email,'phoneNumber': phoneNumber});
}
  addEvent (String eventName,String eventCode,String eventDescription,String eventAddress,int maxAttendee,File _image,DateTime dateTime,String uid) async {
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
    Firestore.instance.collection('users').document(uid).collection('eventsHosted').document(eventCode)
    .setData({'eventCode':eventCode});
   await Firestore.instance.collection('events').document(eventCode).setData({
      'eventCode':eventCode,
      'eventName':eventName,
      'eventDescription':eventDescription,
      'eventAddress':eventAddress,
      'maxAttendee':maxAttendee,
      'eventDateTime':dateTime,
      'eventBanner':_uploadedFileURL
    });
  }
}
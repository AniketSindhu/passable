import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdd{

  String name,uid,phoneNumber,email;
  FirebaseAdd(this.email,this.name,this.phoneNumber,this.uid);
  addUser(){
    Firestore.instance.collection('users').document(uid)
    .setData({ 'name': name, 'email': email,'phoneNumber': phoneNumber});
}
}
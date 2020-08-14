import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdd{
  addUser(String name,String email, String phoneNumber,String uid,bool isIndia){
    Firestore.instance.collection('users').document(uid)
    .setData({ 'name': name, 'email': email,'phoneNumber': phoneNumber,'uid':uid,'isIndia':isIndia},merge: true);
  }
}
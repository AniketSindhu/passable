import 'package:cloud_firestore/cloud_firestore.dart';
class User{
  String uid;
  String name;
  String email;
  String phone;
  User({this.email,this.name,this.phone,this.uid});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      email: doc['email'],
      uid: doc['uid'],
      phone: doc['phoneNumber'],
      name: doc['name']
    );
  }
  
}
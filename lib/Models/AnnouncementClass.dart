import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Announce{
  Timestamp timestamp;
  String media;
  String description;

  Announce({this.description,this.media,this.timestamp});

  factory Announce.fromDocument(DocumentSnapshot doc){
    return Announce(
      description: doc['description'],
      timestamp: doc['timestamp'],
      media: doc['media']
    );
  }
}
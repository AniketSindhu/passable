import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Club{
  Timestamp name;
  String poster;
  String description;
  String timings;
  List <String> photos;//not moe than 3
  String type;  //club or restaurant
  String contact;//email or phone
  int stars; //out of 5
  Geoflutterfire location; //geolocation

Club({this.description,this.name,this.photos,this.poster,this.contact,this.timings,this.type,this.location,this.stars});

  factory Club.fromDocument(DocumentSnapshot doc){
    return Club(
      description: doc['description'],
      name: doc['name'],
      poster: doc['poster'],
      timings: doc['timings'],
      photos: doc['photos'],
      type: doc['type'],
      contact: doc['contact'],
      stars: doc['stars'],
      location: doc['location']
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Club{
  String name;
  String poster;
  String description;
  String timings;
  List <String> photos;//not more than 3
  String type;  //club or restaurant
  String contact;//email or phone
  String address;
  int avgPrice;
  double stars; //out of 5
  Geoflutterfire position; //geolocation

Club({this.description,this.name,this.photos,this.poster,this.contact,this.timings,this.type,this.position,this.stars,this.avgPrice,this.address});

  factory Club.fromDocument(DocumentSnapshot doc){
    return Club(
      description: doc['description'],
      name: doc['name'],
      poster: doc['poster'],
      timings: doc['timings'],
      photos: doc['photos'],
      type: doc['type'],
      contact: doc['contact'],
      avgPrice: doc['avgPrice'],
      stars: doc['stars'],
      position: doc['position']
    );
  }
}
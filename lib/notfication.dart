import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseMessaging fcm = FirebaseMessaging();

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
      // ...
      fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      content: ListTile(
                      title: Text(message['notification']['title']),
                      subtitle: Text(message['notification']['body']),
                      ),
                      actions: <Widget>[
                      FlatButton(
                          child: Text('Ok'),
                          onPressed: () => Navigator.of(context).pop(),
                      ),
                  ],
              ),
          );
      },
      onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  

}
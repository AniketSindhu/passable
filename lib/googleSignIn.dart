import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plan_it_on/HomePage.dart';
import 'package:plan_it_on/firebaseAdd.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;
String phoneNumber;

Future<String> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  assert(user.email != null);
  assert(user.displayName != null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('login', true);
  prefs.setString('userid', user.uid);
  name = user.displayName;
  email = user.email;
  phoneNumber=user.phoneNumber;
  FirebaseAdd(email, name, phoneNumber, user.uid).addUser();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();
  print("User Sign Out");
}
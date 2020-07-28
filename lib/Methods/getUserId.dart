import 'package:firebase_auth/firebase_auth.dart'; 

Future<String> getCurrentUid() async{
  FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseUser _user = await _auth.currentUser();

  return _user.uid;
}
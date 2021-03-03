// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String name,email,photoURL;

class GoogleAuth extends StatefulWidget{
  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth>{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //final CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<String> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  // Once signed in, return the UserCredential
  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  final User user = userCredential.user;

  assert(user.displayName != null);
  assert(user.email != null);
  assert(user.photoURL != null);

  setState((){
    name = user.displayName;
    email = user.email;
    photoURL = user.photoURL;
  });

  final User currentUser = _firebaseAuth.currentUser;
  fireStore.collection("users").where("authID", isEqualTo: currentUser.uid).get().then((value){
    if(value.size == 0){
          fireStore.collection("users").add({
      "authID": currentUser.uid,
      "displayName": name,
      "email": email,
      "npo":"",
      "profilePic": photoURL
    });
    }
  });

  // }
  // if(!dBuser.exists){
  //   users.add({
  //     "authID": currentUser.uid,
  //     "displayName": name,
  //     "email": email,
  //     "npo":"",
  //     "profilePic": photoURL
  //   });
  // }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Doughnate"),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Log in please',
            ),
            MaterialButton(
              color:Colors.blue,
              onPressed: () => signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}


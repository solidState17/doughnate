import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import './home.dart';
import './database/users.dart';

String npo = 'Prefer to be reimbursed (No NPO)';
bool display_doughnated = true;
String name, email, photoURL, userid;

class GoogleAuth extends StatefulWidget {
  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String value;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //final CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User user = userCredential.user;
    assert(user.displayName != null);
    assert(user.email != null);
    assert(user.photoURL != null);
    assert(user.uid != null);

    setState(
      () {
        name = user.displayName;
        email = user.email;
        photoURL = user.photoURL;
        userid = user.uid;
      },
    );

    photoURL = user.photoURL.toString();

    // this is the first signup, creating user for firebase
    final User currentUser = _firebaseAuth.currentUser;
    await createUser(currentUser);
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Doughnut.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Container(
                    child: Text(
                      "Doughnate",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Center(
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () {
                      signInWithGoogle().then(
                        (value) {
                          if (value == "success") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 160,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

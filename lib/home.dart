import 'package:flutter/material.dart';
// import './login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appsettings.dart';
import 'friends.dart';
import 'login.dart';

var friends = [];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final _email = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // this is to add friends based on the search query triggers by add button.
  Future<void> handleAddingFriend() async {
    db
        .collection("users")
        .where("email", isEqualTo: _email.text)
        .get()
        .then((value) {
      final userData = value.docs[0].data();
      db.collection("Friendship").add({
        "userA": userData['email'],
        "userB": email,
        "debt": 0,
      });
    });
  }

  // this will refresh the friendship list
  Future<void> getAllFriends() async {
    var friendsArray = [];
    friends = [];

    /*

    userA
    userB
    debt

    */

    final userA = await db
        .collection("Friendship")
        .where("userA", isEqualTo: email)
        .get();

    final userB = await db
        .collection("Friendship")
        .where("userB", isEqualTo: email)
        .get();

    userA.docs.forEach((document) {
      friendsArray.add(document.data());
    });

    userB.docs.forEach((document) {
      friendsArray.add(document.data());
    });

    friendsArray.forEach((friend) async {
      var user = friend['userA'] == email ? friend['userB'] : friend['userA'];

      final pulledUser =
          await db.collection("users").where("email", isEqualTo: user).get();

      final listUser = pulledUser.docs[0].data();
      listUser['friendship'] = friend;

      friends.add(listUser);
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xfff5f5f5),
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Doughnate',
                style: TextStyle(
                  fontFamily: 'Futura',
                  fontSize: 30,
                  color: const Color(0xff707070),
                  fontWeight: FontWeight.w700,
                )),
            automaticallyImplyLeading: false,
          ),
          // this is the home page
          body: Container(
            child:
                Center(child: _currentIndex == 2 ? AppSettings() : Friends()),
          ),

          bottomNavigationBar: BottomNavigationBar(
            // showUnselectedLabels: true,
            backgroundColor: const Color(0xfff5f5f5),
            elevation: 0,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_outlined),
                label: "Add",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (_currentIndex == 1) {
                TextEditingController email = TextEditingController();
                showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                            title: new Text("Enter an email address:"),
                            content: new TextFormField(
                              controller: _email,
                              decoration: const InputDecoration(
                                labelText: "email",
                                hintText: 'Enter an email',
                              ),
                            ),
                            actions: <Widget>[
                              new TextButton(
                                  onPressed: () {
                                    // handleAddingFriend();
                                    getAllFriends();
                                  },
                                  child: new Text("Add"))
                            ]));
              }
            },
            selectedItemColor: const Color(0xff4d4d4d),
          ),
        ));
  }
}

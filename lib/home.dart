import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appsettings.dart';
import 'friends.dart';
import 'login.dart';
import 'search.dart';
import 'NpoList.dart';
import 'UserProfile.dart';
import 'UI/colorsUI.dart';
import 'UserProfile.dart';

final friendsList = StreamController<List>.broadcast();

Stream stream = friendsList.stream;

Future<void> getAllFriends() async {
  var friends = [];
  final thisUser =
      await FirebaseFirestore.instance.collection('users').doc(userid).get();

  var friendsArray = thisUser.data()['friends'];

  friendsArray.forEach(
    (userFriend) async {
      final obj = await FirebaseFirestore.instance
          .collection('Friendship')
          .doc(userFriend)
          .get();

      var user = obj.data()['userA'] == email
          ? obj.data()['userB']
          : obj.data()['userA'];

      FirebaseFirestore.instance
          .collection('users')
          .where("email", isEqualTo: user)
          .get()
          .then(
        (document) {
          final allData = document.docs[0].data();
          allData['friendship'] = obj.data();
          friends.add(allData);
        },
      );
    },
  );

  new Timer(const Duration(seconds: 2), () => friendsList.sink.add(friends));
}

class Home extends StatefulWidget {
  final String value;
  Home({this.value});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final _email = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // this is to add friends based on the search query triggers by add button.
  Future<void> handleAddingFriend() async {
    db.collection("users").where("email", isEqualTo: _email.text).get().then(
      (value) {
        if (value.docs.length > 0) {
          print("You have this friend already!");
          return;
        }
        final userData = value.docs[0].data();
        db.collection("Friendship").add(
          {
            "userA": userData['email'],
            "userB": email,
            "debt": 0,
          },
        );
      },
    );

    getAllFriends();
  }

  Widget build(BuildContext context) {
    final navPages = [UserProfile(), Friends(), NpoList(), AppSettings()];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor1,
              bgColor2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   centerTitle: true,
          //   title: const Text('Doughnate',
          //       style: TextStyle(
          //         fontFamily: 'Futura',
          //         fontSize: 30,
          //         color: Colors.white,
          //         fontWeight: FontWeight.w700,
          //       )),
          //   automaticallyImplyLeading: false,
          // ),
          // this is the home page
          body: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                child: navPages[_currentIndex],
              ),
            ),
          ),

          bottomNavigationBar: BottomNavigationBar(
            // showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            unselectedItemColor: Colors.white,
            elevation: 0,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_rounded),
                label: "Friends",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list_outlined),
                label: "NPOs",
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
                getAllFriends();
              }
            },
            selectedItemColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

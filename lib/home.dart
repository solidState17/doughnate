import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appsettings.dart';
import 'friends.dart';
import 'login.dart';
import 'search.dart';

final friendsList = StreamController<List>.broadcast();

Stream stream = friendsList.stream;

Future<void> getAllFriends() async {
  var friends = [];
  final thisUser =
      await FirebaseFirestore.instance.collection('users').doc(userid).get();

  var friendsArray = thisUser.data()['friends'];

  friendsArray.forEach((userFriend) async {
    final obj = await FirebaseFirestore.instance
        .collection('Friendship')
        .doc(userFriend)
        .get();
    var user = obj.data()['userA'] == email
        ? obj.data()['userB']
        : obj.data()['userA'];

    final friendData = await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: user)
        .get();

    final allData = friendData.docs[0].data();
    allData['friendship'] = obj.data();
    friends.add(allData);
  });

  new Timer(const Duration(seconds: 4), () => friendsList.sink.add(friends));

  // friendsList.sink.add(friends);
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
    db
        .collection("users")
        .where("email", isEqualTo: _email.text)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        print("You have this friend already!");
        return;
      }
      final userData = value.docs[0].data();
      db.collection("Friendship").add({
        "userA": userData['email'],
        "userB": email,
        "debt": 0,
      });
    });

    await getAllFriends();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                      fullscreenDialog: true,
                    ));
              }
              if (_currentIndex == 0) {
                getAllFriends();
              }
            },
            selectedItemColor: const Color(0xff4d4d4d),
          ),
        ));
  }
}

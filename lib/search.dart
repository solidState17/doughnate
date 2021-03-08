import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import './login.dart';

var friendUserPic = "";
var friendUserName = "";

class Search extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<Search> {
  final _controller = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String name = "";
  var index = 0;

  final pages = [DefaultPage(), FriendsInfo(), ErrorMassage(), MyEmailAdress()];

  searchFriends(userEmail) async {
    await fireStore
        .collection("users")
        .where("email", isEqualTo: name)
        .get()
        .then((value) {
      setState(() {
        index = 1;
        friendUserPic = value.docs[0].data()["profilePic"];
        friendUserName = value.docs[0].data()["displayName"];
        FriendsInfo();
        print(friendUserPic);
      });
    }).catchError((err) {
      setState(() {
        index = 2;
      });
      print("Invalid Email Address");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text("Search Friends",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        body: Column(children: <Widget>[
        Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 10),
                child: TextField(
                    controller: _controller,
                    onChanged: (x) => name = x,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: "Email",
                      filled: true,
                    )),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(
                    padding: EdgeInsets.only(top: 35),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        name == email
                            ? setState(() {
                          index = 3;
                        })
                            : searchFriends(name);
                      },
                    )))
          ],
        )),
    Container(
    margin: EdgeInsets.only(bottom: 280),
    child: Center(child: pages[index]),)
    ]),
    );
  }
}

class ErrorMassage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 200),
      child: Center(
        child: Text(
          "Input email address is not registered",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

class FriendsInfo extends StatelessWidget {
  //final add = _SearchTextFieldState();

  // CollectionReference friendship =
  //     FirebaseFirestore.instance.collection('Friendship');

  // Future<void> addFriends() {
  //   return friendship
  //       .add({
  //         "userA": email,
  //         "userB": name,
  //         "debt": 0,
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(friendUserPic),
        ),
      ),
      Container(
          child: Text(
            friendUserName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      Container(
          margin: EdgeInsets.only(top: 20),
          width: 120,
          color: Colors.green,
          child: TextButton(
              onPressed: () {
                print("pressed!");
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                ),
              )))
    ]);
  }
}

class MyEmailAdress extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 200),
      child: Center(
        child: Text(
          "Input email address is yours",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

class DefaultPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}

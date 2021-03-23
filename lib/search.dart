import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import './login.dart';
import 'UI/colorsUI.dart';
import 'home.dart';

var friendUserPic = "";
var friendUserName = "";
var friendUserEmail = "";

class Search extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<Search> {
  final _controller = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String friendName = "";
  var index = 0;
  final pages = [
    DefaultPage(),
    FriendsInfo(),
    ErrorMassage(),
    MyEmailAdress(),
  ];

  searchFriends(userEmail) async {
    await fireStore
        .collection("users")
        .where("email", isEqualTo: friendName)
        .get()
        .then(
      (value) {
        setState(
          () {
            index = 1;
            friendUserPic = value.docs[0].data()["profilePic"];
            friendUserName = value.docs[0].data()["displayName"];
            friendUserEmail = value.docs[0].data()["email"];
            FriendsInfo();
          },
        );
      },
    ).catchError(
      (err) {
        setState(
          () {
            index = 2;
          },
        );
        print(
          "Invalid Email Address",
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: bgColor1,
          title: Text("Search Friends",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      body: Column(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 10),
                child: TextField(
                    controller: _controller,
                    onChanged: (x) => friendName = x,
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
        ),
        Container(
          child: Center(child: pages[index]),
        )
      ]),
    );
  }
}

class ErrorMassage extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Text(
            "Input email address is not registered",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class FriendsInfo extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference friendship =
      FirebaseFirestore.instance.collection('Friendship');

  Future<bool> checkForFriend(friendEmail) async {
    print(friendEmail);
    final userRef = firestore.collection('users').doc(userid);
    final userData = await userRef.get();
    for (var item in userData.data()['friends']) {
      if (item['friendemail'] == friendEmail) {
        return true;
      }
    }
    return false;
  }

  Future<void> sendFriendInvite(context) async {
    final userBData = await firestore
        .collection('users')
        .where("email", isEqualTo: friendUserEmail)
        .get();
    final userB = firestore.collection("users").doc(
          userBData.docs[0].data()['authID'],
        );

    final haveFriend = await checkForFriend(friendUserEmail);

    if (haveFriend) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${userBData.docs[0].data()['displayName']} is already a friend")));
    }

    userB.update({
      "friend_requests": FieldValue.arrayUnion([
        {
          "email": email,
          "profilePic": photoURL,
          "displayName": name,
        }
      ]),
    }).then((doc) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sent friend request")));
    });
  }

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
        ),
      ),
      Container(
          margin: EdgeInsets.only(top: 20),
          width: 120,
          color: Colors.green,
          child: TextButton(
              onPressed: () {
                sendFriendInvite(context);
                Navigator.of(context, rootNavigator: true).pop();
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
    return SizedBox(
      height: 300,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Text(
            "Input email address is yours",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class DefaultPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference friendship =
      FirebaseFirestore.instance.collection('Friendship');

  Future<void> approveFriends() async {
    final userA = firestore.collection("users").doc(userid);
    final userBData = await firestore
        .collection('users')
        .where("email", isEqualTo: friendUserEmail)
        .get();
    final userB = firestore.collection("users").doc(
          userBData.docs[0].data()['authID'],
        );

    friendship.add({
      "userA": friendUserEmail,
      "userB": email,
      "debt": 0,
      "owner": "",
      "friendshipid": "",
    }).then((newFriend) {
      friendship.doc(newFriend.id).update({
        "friendshipid": newFriend.id,
      });
      userA.update({
        "friends": FieldValue.arrayUnion([
          {
            'friendshipid': newFriend.id,
            'friendid': userBData.docs[0].data()['authID'],
            'friendemail': userBData.docs[0].data()['email']
          }
        ])
      }).then((doc) {
        getAllFriends();
      });
      userB.update({
        "friends": FieldValue.arrayUnion([
          {
            'friendshipid': newFriend.id,
            'friendid': userid,
            'friendemail': email
          }
        ])
      });
    });
    removeFriendFromInvitations(friendUserEmail);
    // getAllFriends();
  }

  Future<void> removeFriendFromInvitations(invite) async {
    final userRef = firestore.collection('users').doc(userid);
    final userData = await userRef.get();
    var newArray = [];

    userData['friend_requests'].forEach(
      (item) {
        if (item['email'] != invite) {
          newArray.add(item);
        }
      },
    );

    userRef.update(
      {
        "friend_requests": newArray,
      },
    );
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: StreamBuilder(
      stream: firestore.collection('users').doc(userid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return Text('No new friend requests');
        var data = snapshot.data;
        var invitation = data['friend_requests'];
        return ListView.builder(
            itemCount: invitation.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(invitation[index]['profilePic'])),
                    title: Text(
                        "${invitation[index]['displayName']} wants to add you as a friend!"),
                    trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Center(child: Text('What to do?')),
                                    content: Container(
                                        height: 200,
                                        width: 600,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 70.0,
                                                width: 100.0,
                                                child: IconButton(
                                                  padding: EdgeInsets.all(0.0),
                                                  icon: Icon(
                                                      Icons.group_add_rounded,
                                                      size: 60),
                                                  tooltip: 'Add friend',
                                                  onPressed: () {
                                                    friendUserEmail =
                                                        invitation[index]
                                                            ['email'];
                                                    approveFriends();
                                                    getAllFriends();
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                  },
                                                )),
                                            Text('Add friend'),
                                            Spacer(),
                                            SizedBox(
                                                height: 70.0,
                                                width: 100.0,
                                                child: IconButton(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    icon: Icon(
                                                        Icons
                                                            .remove_circle_rounded,
                                                        size: 60),
                                                    tooltip: 'No thanks!',
                                                    onPressed: () {
                                                      removeFriendFromInvitations(
                                                          invitation[index]);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    })),
                                            Text('Decline'),
                                          ],
                                        )));
                              });
                        })),
              );
            });
      },
    )));
  }
}

class Invitation {
  final String display_name;
  final String email;
  final String profilePic;

  Invitation({this.display_name, this.email, this.profilePic});
}

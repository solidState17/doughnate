import 'dart:async';
import 'package:doughnate/debtHistory/Debtlist.dart';
import 'home.dart';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './UI/shapes.dart';
import './UI/colorsUI.dart';
import './UI/iconButtons.dart';

class Friends extends StatefulWidget {
  Friends({Key key}) : super(key: key);

  @override
  _Friends createState() => _Friends();
}

class _Friends extends State<Friends> {
  void showAddFriend() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Search(),
        fullscreenDialog: true,
      ),
    );
  }

  final DocumentReference users =
      FirebaseFirestore.instance.collection("users").doc(userid);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Friends",
                      style: TextStyle(
                        fontFamily: 'Futura',
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    StreamBuilder(
                        stream: users.snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return ClickableIcon(
                                iconData: Icons.person_add,
                                text: 'Add Friend',
                                notificationNumber: 0,
                                color: Colors.white,
                                onTap: showAddFriend);
                          return ClickableIcon(
                            iconData: Icons.person_add,
                            text: 'Add Friend',
                            notificationNumber:
                                snapshot.data["friend_requests"].length,
                            color: Colors.white,
                            onTap: showAddFriend,
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: stream, // this is the friend data !
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return buildCard(snapshot.data[index]);
                          // snapshot.data.map<Widget>((friend) => buildCard(friend)).toList()
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card buildCard(friend) {
    final double perc =
        (friend['total_doughnated'] / friend['total_reimbursed']) * 100;
    final double displayedPerc = perc.isNaN ? 0.0 : perc;

    changedColor() {
      if (friend['friendship']['debt'] == 0) {
        return bgColor1;
      } else if (friend['friendship'][friend['friendship']['owner']] == email) {
        return primaryGreen2;
      } else {
        return primaryRed2;
      }
    }

    changeText() {
      if (friend['friendship']['debt'] == 0) {
        return Text(
          "You're Even",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      } else if (friend['friendship'][friend['friendship']['owner']] == email) {
        return Text(
          "You're Owed",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      } else {
        return Text(
          "You Owe",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }
    }

    return Card(
      shadowColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => UpdateDebt(friend: friend),
          );
        },
        child: Container(
          // padding: EdgeInsets.all(10.0),
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 5.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          friend['displayName'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        friend['display_doughnated']
                            ? Text(
                                "${displayedPerc.toStringAsFixed(2)}% D🍩ughnated to preferred NPO",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            : Text("Prefers D🍩ughnations to ${friend['npo']}"),
                        //If owner is user, show green card, otherwise show red card.
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 60.0,
                            width: 220.0,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: changedColor(),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                changeText(),
                                friend['friendship']['debt'] == 0
                                    ? Container()
                                    : Text(
                                        "¥${friend['friendship']['debt'].toString()}",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    padding: EdgeInsets.all(0.0),
                    child: ClipPath(
                      clipper: ShapeClipper(),
                      child: FittedBox(
                          child: Image.network(friend['profilePic']),
                          fit: BoxFit.cover),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
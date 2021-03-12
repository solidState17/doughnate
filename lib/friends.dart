import 'dart:async';
import 'package:doughnate/debtHistory/Debtlist.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Friends extends StatefulWidget {
  Friends({Key key}) : super(key: key);

  @override
  _Friends createState() => _Friends();
}

class _Friends extends State<Friends> {

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
                      "Friends List",
                      style: TextStyle(
                        fontFamily: 'Futura',
                        fontSize: 24,
                        color: const Color(0xff707070),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Text('Add Friend'),
                    ),
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

    // FirebaseFirestore.instance.collection('users').where("email", isEqualTo: friend['userA']).get()

    return Card(
      shadowColor: Colors.black,
      elevation: 15,
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
          padding: EdgeInsets.all(10.0),
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 7,
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
                      Text(
                        "90% reimbursed via D🍩ughnations",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      //If owner is user, show green card, otherwise show red card.
                      Container(
                        height: 70.0,
                        width: 220.0,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: friend['friendship']
                                          [friend['friendship']['owner']] ==
                                      email
                                  ? [Color(0xFF07dfaf), const Color(0xFF47e544)]
                                  : [
                                      Colors.redAccent,
                                      Colors.red
                                    ], //[const Color(0xFF02b5e0), const Color(0xFF02cabd)]
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          // color: const Color(0xffa9e19c),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            friend['friendship']
                                        [friend['friendship']['owner']] ==
                                    email
                                ? Text(
                                    "You're Owed",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "You Owe",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                            Text(
                              "¥${friend['friendship']['debt'].toString()}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(friend['profilePic']),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                      "Friends",
                      style: TextStyle(
                        fontFamily: 'Futura',
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: primarySalmon,
                      ),
                      child: Text(
                        'Add Friend',
                        style: TextStyle(
                          fontFamily: 'Futura',
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

    final double perc =
        (friend['total_doughnated'] / friend['total_reimbursed']) * 100;
    final double displayedPerc = perc.isNaN ? 0.0 : perc;

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
                  padding: const EdgeInsets.fromLTRB(8.0, 6.0, 0.0, 5.0),
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
                                "$displayedPerc% D🍩ughnated to preferred NPO",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            : Text("Prefers D🍩ughnations to ${friend['npo']}"),
                        //If owner is user, show green card, otherwise show red card.
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                          child: Container(
                            height: 60.0,
                            width: 220.0,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              // gradient: LinearGradient(
                              //     colors: friend['friendship']
                              //                 [friend['friendship']['owner']] ==
                              //             email
                              //         ? [
                              //             Color(0xFF07dfaf),
                              //             const Color(0xFF47e544)
                              //           ]
                              //         : [
                              //             Colors.redAccent,
                              //             Colors.red
                              //           ], //[const Color(0xFF02b5e0), const Color(0xFF02cabd)]
                              //     begin: Alignment.topRight,
                              //     end: Alignment.bottomLeft),
                              // color: const Color(0xffa9e19c),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: friend['friendship']
                                          [friend['friendship']['owner']] ==
                                      email
                                  ? primaryGreen2
                                  : primaryRed2,
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

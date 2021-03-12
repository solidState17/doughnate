import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doughnate/pie_chart.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';
import 'pie_chart_view.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  DocumentReference users =
      FirebaseFirestore.instance.collection("users").doc(userid);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: users.snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || !snapshot.data.exists)
                    return Center(child: Text("No Transactions"));
                  print('-----------------!!!!!!!!!!!!!!!!!!!!!!!');
                  print(snapshot.data['userid']);
                  print('-----------------!!!!!!!!!!!!!!!!!!!!!!!');
                  return Container(
                    height: height * 0.3,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Owe",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '¥${snapshot.data["total_borrowed"]}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        PieChartView(
                          categories: [
                            Category("Owe",
                                amount: snapshot.data["total_borrowed"]),
                            Category("Owed",
                                amount: snapshot.data["total_lent"])
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Owed",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            Text("¥${snapshot.data['total_lent']}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Column(children: [
                Expanded(
                    child: StreamBuilder(
                  stream: users.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    return ListView.builder(
                        itemCount: snapshot.data['transactions'].length,
                        itemBuilder: (context, int index) {
                          return Dismissible(
                              key: Key(
                                  "${snapshot.data['transactions'][index]}"),
                              background: Container(
                                  color: Colors.red,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                              onDismissed: (_direction) {
                                if (_direction == DismissDirection.startToEnd) {
                                  snapshot.data['transactions'].removeAt(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Transaction deleted")));
                                }
                              },
                              child: historyCard(
                                  snapshot.data['transactions'][index]));
                        });
                  },
                )
                    //friends.map((friend) => buildCard(friend)).toList(),
                    ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Card historyCard(transaction) {
  DateTime myDateTime = (transaction['timestamp']).toDate();

  return Card(
    shadowColor: Colors.black,
    elevation: 15,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15.0),
      bottomLeft: Radius.circular(15.0),
    )),
    child: InkWell(
      child: Container(
        height: 100,
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Expanded(
                    //   flex: 4,
                    //   child: Container(
                    //     child: CircleAvatar(
                    //       radius: 30,
                    //       backgroundImage: NetworkImage(friend['profilePic']),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.yMMMd().format(myDateTime),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${transaction['name']}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF07dfaf), const Color(0xFF47e544)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¥${transaction['amount'].toString()}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//
// transaction: [
// {
//   timestamp
//   amount
//   name: username
//   ID(for transactions)
// }
// ]

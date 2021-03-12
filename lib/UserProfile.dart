import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doughnate/pie_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'pie_chart_view.dart';
import 'package:intl/intl.dart';

var total_borrowed = 0;
var total_lent = 0;
var totalAmount = 0;

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {

  final DocumentReference users =
      FirebaseFirestore.instance.collection("users").doc(userid);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final timestamp = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: users.snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || !snapshot.data.exists) {
                    return Center(child: Text("No Transactions"));
                  }
                  total_borrowed = snapshot.data["total_borrowed"];
                  total_lent = snapshot.data["total_lent"];
                  totalAmount = -total_borrowed + total_lent;

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
                              '¥${total_borrowed}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        PieChartView(
                          categories: [
                            Category("Owed",
                                amount: snapshot.data["total_lent"]),
                            Category("Owe",
                                amount: snapshot.data["total_borrowed"]),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Owed",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            Text("¥${total_lent}",
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
            // For test container you can delete this whenever.
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     margin: EdgeInsets.only(top: 20, bottom: 10),
            //     color: Colors.red,
            //     child: TextButton(
            //       child: Text("Click!"),
            //       onPressed: (){
            //         print("clicked!");
            //          users.update({
            //            "transactions": FieldValue.arrayUnion([
            //             {
            //               "timestamp": timestamp,
            //                 "amount": 500,
            //                 "name": "shota",
            //                   "type": "borrowed",
            //              }
            //             ])
            //            });
            //         }
            //     ),
            // ),
            Expanded(
              child: Column(children: [
                Expanded(
                    child: StreamBuilder(
                  stream: users.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData || !snapshot.data.exists){
                      return Center(child: CircularProgressIndicator());
                    }
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
                              onDismissed: (_direction){
                                if (_direction == DismissDirection.startToEnd) {
                                  var specificTimestamp = snapshot.data['transactions'][index]["timestamp"];
                                  var newTransaction = [];
                                  snapshot.data['transactions'].forEach((val) {
                                    if(val["timestamp"] != specificTimestamp) {
                                      newTransaction.add(val);
                                    }
                                  });
                                  users.update({
                                    "transactions": newTransaction
                                  });
                                  }
                                ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("TransAction was Deleted")));

                              },
                              child: historyCard(
                                  snapshot.data["transactions"][index]));
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
                      colors: transaction["type"] == "borrowed"
                          ? [Color(0xFF07dfaf), const Color(0xFF47e544)]
                          : [Colors.redAccent, Colors.red],
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

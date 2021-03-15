import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doughnate/pie_chart.dart';
import 'package:doughnate/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'pie_chart_view.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'pie_chart/categories.dart';
import 'pie_chart/debt_chart.dart';
import 'neumorphic_pie/neumorphic_pie.dart';

var total_borrowed = 0;
var total_lent = 0;
var totalAmount = 0;

hexColor(String colorhexcode) {
  String colornew = "0xff" + colorhexcode;
  colornew = colornew.replaceAll("#", "");
  int colorint = int.parse(colornew);
  return colorint;
}

class UserProfile extends StatelessWidget {
  UserProfile({Key key}) : super(key: key);
  static List<charts.Series<Expense, String>> _series = [
    charts.Series<Expense, String>(
        id: 'Expense',
        domainFn: (Expense expense, _) => expense.category,
        measureFn: (Expense expense, _) => expense.value,
        labelAccessorFn: (Expense expense, _) => '\¥${expense.value}',
        colorFn: (Expense expense, _) =>
            charts.ColorUtil.fromDartColor(expense.color),
        data: [
          Expense('Owe', total_borrowed, Colors.pink),
          Expense('Owed', total_lent, Color(0xFF47e544)),
        ])
  ];
  final DocumentReference users =
      FirebaseFirestore.instance.collection("users").doc(userid);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final timestamp = DateTime.now();

    return Column(
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

              return Stack(children: [
                Container(
                  height: height * 0.45,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 360,
                         decoration: BoxDecoration(
                           color: Colors.white,
                        //   gradient: LinearGradient(
                        //     colors: [
                        //       Color(hexColor("#DFF4F6")),
                        //       Color(hexColor("#C7EBF0")),
                        //     ],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //   ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              offset: Offset(0, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: Color(hexColor("#00B4DB")),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(photoURL),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff707070),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "¥${snapshot.data["total_doughnated"]}",
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: const Color(0xff707070),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Donation",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: const Color(0xff707070),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 150,
                  right: 30,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: width * 0.85,
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Stack(children: [
                            Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff707070),
                                      ),
                                    ),
                                    Text(
                                      "¥${totalAmount}",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff707070),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DebtChart(_series, animate: true,)
                            //NeumorphicPie(),
                          ]),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color : const Color(0xFF47e544),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                          SizedBox(
                                            width:5,
                                          ),
                                          Text("You're Owed",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: const Color(0xff707070),
                                                fontWeight: FontWeight.w800,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('¥${total_lent}',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: const Color(0xff707070),
                                            fontWeight: FontWeight.w800,
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 100, height: 1, color: Colors.grey),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                          SizedBox(
                                            width:5,
                                          ),
                                          Text("You Owe",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xff707070),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text('¥${total_borrowed}',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: const Color(0xff707070),
                                            fontWeight: FontWeight.w800,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    //child: DebtChart(_series, animate: true),
                  ),
                )
              ]);
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20, bottom: 10, left: 20),
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
                if (!snapshot.hasData || !snapshot.data.exists) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data['transactions'].length,
                    itemBuilder: (context, int index) {
                      return Dismissible(
                          key: Key("${snapshot.data['transactions'][index]}"),
                          background: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              )),
                          onDismissed: (_direction) {
                            if (_direction == DismissDirection.startToEnd) {
                              var specificTimestamp = snapshot
                                  .data['transactions'][index]["timestamp"];
                              var newTransaction = [];
                              snapshot.data['transactions'].forEach((val) {
                                if (val["timestamp"] != specificTimestamp) {
                                  newTransaction.add(val);
                                }
                              });
                              users.update({"transactions": newTransaction});
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("TransAction was Deleted")));
                          },
                          child: historyCard(snapshot.data["transactions"][index]));
                    });
              },
            )
                //friends.map((friend) => buildCard(friend)).toList(),
                ),
          ]),
        ),
      ],
    );
  }
}

Card historyCard(transaction) {
  DateTime myDateTime = (transaction['timestamp']).toDate();

  return Card(
    shadowColor: Colors.black,
    elevation: 8,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    )),

    child: InkWell(
      child: Container(
        height: 85,
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
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
                                DateFormat('yyyy/MM/dd(E) HH:mm')
                                    .format(myDateTime),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${transaction['name']}",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
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
                          : [Colors.pink, Colors.redAccent],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
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

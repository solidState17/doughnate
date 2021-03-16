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

              return Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3,
                          offset: Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          height: 180,
                          child: Stack(
                            children: [
                              Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff707070),
                                        ),
                                      ),
                                      Text("¥${totalAmount}",
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
                              //DebtChart(_series, animate: true,)
                              NeumorphicPie(),
                            ],
                          ), //child: DebtChart(_series, animate: true),
                        ),
                        Container(
                            child: Container(
                          padding: EdgeInsets.only( right: 25, left: 25, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF47e544),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text("Owed",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: const Color(0xff707070),
                                              fontWeight: FontWeight.w800,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '¥${total_lent}',
                                      style: TextStyle(
                                        fontSize: 23,
                                        color: const Color(0xff707070),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height:40,
                                child: VerticalDivider(
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text("Doughnation",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: const Color(0xff707070),
                                          fontWeight: FontWeight.w800,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '¥${snapshot.data["total_doughnated"]}',
                                      style: TextStyle(
                                        fontSize: 23,
                                        color: const Color(0xff707070),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height:40,
                                child: VerticalDivider(
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text("Owe",
                                            style: TextStyle(
                                              fontSize:  18,
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
                                          fontSize: 23,
                                          color: const Color(0xff707070),
                                          fontWeight: FontWeight.w800,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              );
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20, bottom: 10, left: 20),
          child: Text(
            "Recent Transactions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
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
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if(snapshot.data['transactions'].length == 0){
                  return Center(
                    child: Text("No Transactions", style: TextStyle(
                      fontSize: 20, color: Colors.black.withOpacity(0.5),
                    ),),
                  );
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

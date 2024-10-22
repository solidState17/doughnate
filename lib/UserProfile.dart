import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'UI/colorsUI.dart';
import 'UI/shapes.dart';
import 'login.dart';
import 'pie_chart_view.dart';
import 'package:intl/intl.dart';

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
              total_borrowed = (snapshot.data["total_borrowed"] -
                      snapshot.data['total_returned'])
                  .abs();
              total_lent = (snapshot.data["total_lent"] -
                      snapshot.data['total_reimbursed'])
                  .abs();
              final totalCalc = -total_borrowed + total_lent;
              totalAmount = totalCalc.abs();

              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Stack(children: [
                  Opacity(
                    opacity: 1,
                    child: Container(
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
                    ),
                  ),
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            height: 180,
                            //child: Stack(
                            //children: [
                            child: PieChartView(categories: [
                              Category('owe',
                                  color: primaryRed2, amount: total_borrowed),
                              Category('owed',
                                  color: primaryGreen2, amount: total_lent),
                            ]),
                          ),
                          Container(
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 25, left: 25, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  color: primaryGreen2,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text("Owed",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      const Color(0xff707070),
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
                                    height: 40,
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
                                    height: 40,
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
                                                  color: primaryRed2,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text("Owe",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      const Color(0xff707070),
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
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ]),
              );
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20, bottom: 10, left: 20),
          child: Text(
            "Recent Transactions",
            style: DefaultTextUI(
              size: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
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
                } else if (snapshot.data['transactions'].length == 0) {
                  return Center(
                    child: Text(
                      "No Transactions",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
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
                              var specificTimestamp = snapshot
                                  .data['transactions'][index]["timestamp"];
                              var newTransaction = [];
                              snapshot.data['transactions'].forEach((val) {
                                if (val["timestamp"] != specificTimestamp) {
                                  newTransaction.add(val);
                                }
                              });
                              users.update({"transactions": newTransaction});
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Transaction was deleted")));
                          },
                          child: historyCard(
                              snapshot.data["transactions"][index]));
                    });
              },
            )
                ),
          ]),
        ),
      ],
    );
  }
}

Card historyCard(transaction) {
  DateTime myDateTime = (transaction['timestamp']).toDate();
  final Color colorChoice =
      transaction['amount'] < 0 ? primaryRed2 : primaryGreen2;

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
                                style: DefaultTextUI(
                                  color: Colors.black,
                                  size: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${transaction['name']}",
                                style: DefaultTextUI(
                                    color: Colors.black,
                                    size: 20,
                                    fontWeight: FontWeight.bold),
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
                  height: 85,
                  padding: EdgeInsets.all(0.0),
                  child: CustomPaint(
                    painter: CardShape(colorChoice),
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                                              child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                          child: Text(
                            "¥${transaction['amount'].abs().toString()}",
                            style: DefaultTextUI(
                              size: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            // ),
          ],
        ),
      ),
    ),
  );
}

class Category {
  Category(this.name, {@required this.amount, this.color});

  final String name;
  final Color color;
  final int amount;
}

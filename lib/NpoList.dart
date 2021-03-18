import 'dart:async';
import 'package:doughnate/UI/colorsUI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UI/iconButtons.dart';
import 'UI/shapes.dart';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';
import 'appsettings.dart';
import "npo_apply.dart";
import './database/npos.dart';

class NpoList extends StatefulWidget {
  NpoList({Key key}) : super(key: key);

  @override
  _NpoList createState() => _NpoList();
}

final npoStream = FirebaseFirestore.instance.collection('npos').snapshots();

class _NpoList extends State<NpoList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                "Find an NPO",
                style: DefaultTextUI(
                  size: textHeading,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              Spacer(),
              ClickableIcon(
                iconData: Icons.add,
                text: 'Add NPO',
                color: Colors.white,
                notificationNumber: 0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Apply(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: npoStream,
            builder:
                (BuildContext content, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 4.0),
                    child: npoCard(
                      snapshot.data.docs[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Card npoCard(currentNPO) {
    return Card(
      elevation: 8,
      shadowColor: currentNPO['name'] == npo ? primaryRed : Colors.black,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(currentNPO['name']),
            subtitle: Text('Category of NPO'),
            trailing: ClickableIcon(
              iconData: Icons.favorite,
              color: currentNPO['name'] == npo ? primaryRed : Colors.black54,
              notificationNumber: 0,
              text: '',
              onTap: () {
                updatePreferredNPO(currentNPO); // update pref NPO
              },
            ),
          ),
          Container(
            height: 150,
            width: 120,
            child: FittedBox(
              child: Image.network(currentNPO['logo']),
              fit: BoxFit.fitHeight,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return NPOProfile(currentNPO);
                    },
                  );
                },
                child: Text('Learn more'),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Card npoCard(currentNPO) {
  //   return Card(
  //     // margin: EdgeInsets.all(10),
  //     shadowColor: currentNPO['name'] == npo ? Colors.pink : Colors.black,
  //     elevation: 8,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15.0),
  //         bottomLeft: Radius.circular(15.0),
  //       ),
  //     ),
  //     child: InkWell(
  //       onTap: () {
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return NPOProfile(currentNPO);
  //           },
  //         );
  //       },
  //       child: Container(
  //         height: 150,
  //         padding: EdgeInsets.all(10.0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               flex: 7,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     currentNPO['name'],
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   // Text(
  //                   //   currentNPO['summary'],
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               flex: 3,
  //               child: Container(
  //                   height: 150,
  //                   constraints: BoxConstraints.expand(),
  //                   // child: CircleAvatar(
  //                   //     backgroundColor: Colors.transparent,
  //                   //     radius: 60,
  //                   child: FittedBox(
  //                       child: Image.network(currentNPO['logo']),
  //                       fit: BoxFit.contain)
  //                   // Text(
  //                   //   'LOGO RENDER',
  //                   //   style: TextStyle(
  //                   //     fontSize: 12,
  //                   //   ),
  //                   // ),
  //                   // backgroundImage: NetworkImage(npo['logo'])
  //                   // backgroundImage: NetworkImage(currentNPO['logo']),
  //                   // ),
  //                   ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  AlertDialog NPOProfile(currentNPO) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(12.0),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                child: CircleAvatar(
                  radius: 60,
                  child: Text(
                    'LOGO RENDER',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Text("${currentNPO['supporters']} active d🍩ughnaters!",
                  style: DefaultTextUI(
                      size: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
                child: Text(
                  currentNPO['name'],
                  style: DefaultTextUI(
                    size: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  currentNPO['summary'],
                  style: TextStyle(
                    height: 2,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      updatePreferredNPO(currentNPO); // update pref NPO
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Set To Prefered'),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      visitNPO(npo: currentNPO['name']);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('Visit Site'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePreferredNPO(currentNPO) {
    final String direction = currentNPO['name'] == npo ? 'down' : 'up';
    changeNPOActiveCount(currentNPO['npoid'], direction);

    npo = currentNPO['name'];
    UpdateUser();
    setState(() {}); // re-render after change
  }
}

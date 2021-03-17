import 'dart:async';
import 'package:doughnate/UI/colorsUI.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class NpoList extends StatefulWidget {
  NpoList({Key key}) : super(key: key);

  @override
  _NpoList createState() => _NpoList();
}

final npoStream = FirebaseFirestore.instance.collection('npos').snapshots();

class _NpoList extends State<NpoList> {
  // this code refreshes after updating preferred NPO, hopefully
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

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
                // chance this to call npo application
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Apply(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: primarySalmon,
                ),
                child: Text(
                  'Become NPO Partner',
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
                  return npoCard(
                    snapshot.data.docs[index],
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
      margin: EdgeInsets.all(10),
      shadowColor: currentNPO['name'] == npo ? Colors.pink : Colors.black,
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
            builder: (context) {
              return NPOProfile(currentNPO);
            },
          );
        },
        child: Container(
          height: 150,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentNPO['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentNPO['summary'],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: FittedBox(
                      child: Image.network(currentNPO['logo']),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog NPOProfile(currentNPO) {
    return AlertDialog(
      content: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [
            Container(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  currentNPO['logo'],
                ),
              ),
            ),
            Text(
              currentNPO['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currentNPO['summary'],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    print(currentNPO);
                    npo = currentNPO['name'];
                    UpdateUser();
                    setState(() {});
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Set To Prefered'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    visitNPO(
                      npo: currentNPO['name'],
                    );
                    rebuildAllChildren(context);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Visit Site'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // add npo application here

}

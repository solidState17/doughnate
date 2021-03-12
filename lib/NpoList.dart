import 'dart:async';
import 'home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';

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
                      // change this to call application form, not friend search.
                      builder: (context) => Search(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Text('Become NPO Partner'),
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

  Card npoCard(npo) {
    return Card(
      margin: EdgeInsets.all(10),
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
          /* showDialog(
            context: context,
            builder: (context) => UpdateDebt(friend: friend),
          ); */
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
                      npo['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      npo['summary'],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: CircleAvatar(
                    radius: 60,
                    child: Text(
                      'logo renders here',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    // backgroundImage: NetworkImage(npo['logo']),
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

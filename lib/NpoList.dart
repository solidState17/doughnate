import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'updateDebt.dart';
import 'home.dart';
import 'login.dart';
import 'search.dart';
import 'appsettings.dart';

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

  Card npoCard(currentNPO) {
    return Card(
      margin: EdgeInsets.all(10),
      shadowColor: currentNPO['name'] == npo ? Colors.pink : Colors.black,
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
            builder: (context) => NPOProfile(currentNPO: currentNPO),
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
                    radius: 60,
                    child: Text(
                      'LOGO RENDER',
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

class NPOProfile extends StatefulWidget {
  final currentNPO;
  const NPOProfile({Key key, @required this.currentNPO}) : super(key: key);

  @override
  _NPOProfile createState() => _NPOProfile();
}

class _NPOProfile extends State<NPOProfile> {
  // THIS IS A REDRAW FUNC FOR UPDATING THE HIGHLIGHTED CARD
  // final redraw = () {
  //   setState(() {});
  // };
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [
            Container(
              child: CircleAvatar(
                radius: 60,
                child: Text(
                  'LOGO RENDER',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                // backgroundImage: NetworkImage(npo['logo']),
              ),
            ),
            Text(
              widget.currentNPO['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.currentNPO['summary']),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    print(widget.currentNPO);
                    npo = widget.currentNPO['name'];
                    print('🔥');
                    UpdateUser();
                    setState(() {});
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text('Set To Prefered'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    visitNPO(npo: widget.currentNPO['name']);
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
}

/*
ALT LOGO RENDER:
decoration: BoxDecoration(
  shape: BoxShape.circle,
  image: DecorationImage(
    fit: BoxFit.fill,
    image: NetworkImage(
      widget.friend['profilePic'],
    ),
  ),
),


Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      onPressed: () {
        _launchURL(
          npo: widget.friend['npo'],
        );
        adjustDebt(widget.friend['friendship']['friendshipid'],
            int.parse(_enteredAmount.text), "Doughnation");
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text('Doughnate'),
    ),
    Spacer(),
    new TextButton(
      onPressed: () {
        adjustDebt(widget.friend['friendship']['friendshipid'],
            int.parse(_enteredAmount.text), "Adjust");
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: Text('Adjust Debt'),
    ),
  ],
),

 */

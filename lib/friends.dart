import 'dart:math';
import 'home.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  Friends({Key key}) : super(key: key);
  @override
  _Friends createState() => _Friends();
}

class _Friends extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    print(friends);
    return Container(
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Friends List",
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontSize: 24,
                    color: const Color(0xff707070),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            height: 80.0,
          ),
          Column(
            children: friends.map((friend) => buildCard(friend)).toList(),
          )
        ],
      ),
    );
  }

  Card buildCard(friend) {

    return Card(
      child: InkWell(
          onTap: () {},
          child: Row(
            children: [
              Column(children: [
                Text(friend['displayName']),
                Text("Friends name has doughnated 87%..."),
                Container(
                  height: 40.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: const Color(0xffa9e19c),
                    shape: BoxShape.rectangle,
                  ),
                    child: Text(friend['friendship']['debt'].toString()),
                )
              ]),
              Container(
                  height: 80,
                  width: 80,
                  child: Image(image: NetworkImage(friend['profilePic']))
                  ),
            ],
        ),
      ),
    );
  }
}

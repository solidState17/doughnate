// import 'dart:math';
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
        onTap: () {
          // WHAT IS THE ON TAP FOR? I THINK THE WIDGET CALL GOES HERE 🤔
          showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                    /*
        Add an on-press to friend widget
        display same content plus prefered NPO > as a link
        donate and adjust debt > number input fields
        */
                    title: Row(
                      children: [
                        new Text("${friend['displayName']}"),
                        Container(
                            width: 120,
                            height: 120,
                            child: Image(
                                image: NetworkImage(friend['profilePic']))),
                      ],
                    ),
                    content: Container(
                      height: 300,
                      width: 300,
                      child: Column(
                        children: [
                          new Text(
                              "${friend['displayName']} supports Blah NPO"),
                          Text(friend['friendship']['debt'].toString()),
                          Row(
                            children: [
                              new TextButton(
                                  onPressed: () {}, child: Text('Doughnate')),
                              new TextButton(
                                  onPressed: () {}, child: Text('Adjust Debt'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
        },
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
                child: Image(image: NetworkImage(friend['profilePic']))),
          ],
        ),
      ),
    );
  }
}

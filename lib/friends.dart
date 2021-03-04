import 'dart:math';

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
                child: Text("Friends List",
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
          Card(
            child: Row(
              children: [
                Column(
                  children: [
                    Text("Friends Name"),
                    Text("Friends name has doughnated 87%...")
                  ]
                ),
                Container(height: 80, width: 80, child: Text("Image would go here")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

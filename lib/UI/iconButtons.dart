import 'dart:ui';

import 'package:flutter/material.dart';

import 'colorsUI.dart';

class ClickableIcon extends StatelessWidget {
  final String text;
  final IconData iconData;
  //final VoidCallback onTap;
  final int notificationNumber;
  final Color color;

  const ClickableIcon(
      {Key key,
     // this.onTap,
      @required this.text,
      @required this.color,
      @required this.iconData,
      this.notificationNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        //onTap: onTap,
        child: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Icon(iconData, color: color,),
                Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: DefaultTextUI(
                      color: color,
                      fontWeight: FontWeight.w600,
                      size: 12,
                    )),
              ],
            ),
            Positioned(
              top: 0,
              right: 9,
              child: notificationNumber > 0 ? Container(
                height: 7.5,
                width: 7.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                  alignment: Alignment.center,
              ) : Text(''),
            )
          ],
        ),
      )
    );
  }
}

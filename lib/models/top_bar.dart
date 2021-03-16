import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      color: Colors.pink,
      height: 60,
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(2),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.pink)),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}

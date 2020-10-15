import 'package:flutter/material.dart';
import 'package:shop_app/theme/colors.dart';

class LeftPanel extends StatelessWidget {
  final String name;
  final String price;
  final String caption;
  final String offer;
  const LeftPanel({
    Key key,
    @required this.size,
    this.name,
    this.price,
    this.caption,
    this.offer,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
                color: white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            price,
            style: TextStyle(color: white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            caption,
            style: TextStyle(color: white),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.music_note,
                color: white,
                size: 15,
              ),
              Flexible(
                child: Text(
                  offer,
                  style: TextStyle(color: white, height: 1.5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

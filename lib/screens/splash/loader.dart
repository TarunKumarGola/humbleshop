import 'dart:math';

import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;
  double initialradius = 30;
  double radius = 0.0;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    animation_rotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animation_radius_in = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));
    animation_radius_out = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));
    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animation_radius_in.value * initialradius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animation_radius_out.value * initialradius;
        }
      });
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/applogo.png"),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            RotationTransition(
              turns: animation_rotation,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(
                        radius * cos(1 * pi / 4), radius * sin(1 * pi / 4)),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.redAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(3 * (pi / 4)), radius * sin(3 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(4 * (pi / 4)), radius * sin(4 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(5 * (pi / 4)), radius * sin(5 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(6 * (pi / 4)), radius * sin(6 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(7 * (pi / 4)), radius * sin(7 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                        radius * cos(8 * (pi / 4)), radius * sin(8 * (pi / 4))),
                    child: Dot(
                      radius: 6.0,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({Key key, this.radius, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/homepage_widget/common_widgets.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:toast/toast.dart';

class AllReviewPage extends StatefulWidget {
  final String productuid;

  const AllReviewPage({Key key, this.productuid}) : super(key: key);
  @override
  _AllReviewPageState createState() => _AllReviewPageState(productuid);
}

class _AllReviewPageState extends State<AllReviewPage> {
  final String productuid;
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = Colors.red;
  File _imagepathone;
  File _imagepathtwo;
  File _imagepaththree;
  String imageurl1;
  String imageurl2;
  String imageurl3;
  final picker = ImagePicker();
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String comment = null;
  CollectionReference ref;
  _AllReviewPageState(this.productuid);

  @override
  void initState() {
    ref = FirebaseFirestore.instance
        .collection("PRODUCT")
        .doc(productuid)
        .collection("REVIEWS");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //
            }),
        title: Text("Reviews"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.solidStar),
              onPressed: () {
                //
              }),
        ],
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((document) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                                colors: [Color(0xFFF50057), Color(0xFFF50057)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFF50057),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child:  Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        document.data()['username'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Avenir',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                      RatingBar(
                                          rating: double.parse(document
                                              .data()['ratings']
                                              .toString())),
                                      SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.account_box,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Text(
                                              document.data()['comments'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      Image(
                                            image: NetworkImage(
                                                document.data()['imageurl1']),
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          Image(
                                            image: NetworkImage(
                                                document.data()['imageurl2']),
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                       
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}

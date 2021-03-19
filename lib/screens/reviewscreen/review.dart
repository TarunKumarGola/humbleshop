import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/commentspage/commentscreen2.dart';
import 'package:toast/toast.dart';

class ReviewPage extends StatefulWidget {
  final String productuid;

  const ReviewPage({Key key, this.productuid}) : super(key: key);
  @override
  _ReviewPageState createState() => _ReviewPageState(productuid);
}

class _ReviewPageState extends State<ReviewPage> {
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

  _ReviewPageState(this.productuid);
  Future pickImageone() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imagepathone = File(pickedFile.path);
    });
  }

  Future pickImagetwo() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imagepathtwo = File(pickedFile.path);
    });
  }

  Future pickImagethree() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imagepaththree = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //
            }),
        title: Text("Feedback"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.solidStar),
              onPressed: () {
                //
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                      child: Text(
                    "1. On a scale of 1 to 5, how do you rate our Product?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                child: Align(
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            child: Text(
                          myFeedbackText,
                          style: TextStyle(color: Colors.black, fontSize: 22.0),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Icon(
                          myFeedback,
                          color: myFeedbackColor,
                          size: 100.0,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Slider(
                            min: 0.0,
                            max: 5.0,
                            divisions: 10,
                            value: sliderValue,
                            activeColor: Color(0xffff520d),
                            inactiveColor: Colors.blueGrey,
                            onChanged: (newValue) {
                              setState(() {
                                sliderValue = newValue;
                                if (sliderValue >= 0.0 && sliderValue <= 1.0) {
                                  myFeedback = FontAwesomeIcons.sadTear;
                                  myFeedbackColor = Colors.red;
                                  myFeedbackText = "COULD BE BETTER";
                                }
                                if (sliderValue >= 1.1 && sliderValue <= 2.0) {
                                  myFeedback = FontAwesomeIcons.frown;
                                  myFeedbackColor = Colors.yellow;
                                  myFeedbackText = "BELOW AVERAGE";
                                }
                                if (sliderValue >= 2.1 && sliderValue <= 3.0) {
                                  myFeedback = FontAwesomeIcons.meh;
                                  myFeedbackColor = Colors.amber;
                                  myFeedbackText = "NORMAL";
                                }
                                if (sliderValue >= 3.1 && sliderValue <= 4.0) {
                                  myFeedback = FontAwesomeIcons.smile;
                                  myFeedbackColor = Colors.green;
                                  myFeedbackText = "GOOD";
                                }
                                if (sliderValue >= 4.1 && sliderValue <= 5.0) {
                                  myFeedback = FontAwesomeIcons.laugh;
                                  myFeedbackColor = Color(0xffff520d);
                                  myFeedbackText = "EXCELLENT";
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            child: Text(
                          "Your Rating: $sliderValue",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: TextField(
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.blueGrey)),
                              hintText: 'Add Comment',
                            ),
                            style: TextStyle(height: 2.0),
                            maxLines: 5,
                            controller: controller,
                            onChanged: (value) {
                              comment = value.toString();
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imagepathone != null
                              ? InkWell(
                                  child: Image.file(_imagepathone),
                                  onTap: () {
                                    setState(() {
                                      _imagepathone = null;
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImageone,
                                ),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imagepathtwo != null
                              ? InkWell(
                                  child: Image.file(_imagepathtwo),
                                  onTap: () {
                                    setState(() {
                                      _imagepathtwo = null;
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImagetwo,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: Color(0xffff520d),
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
                            onPressed: () async {
                              if (_imagepathone == null ||
                                  _imagepathtwo == null)
                                showInSnackBar("Please choose the images");
                              else if (comment == null)
                                showInSnackBar("Please write a comment");
                              else {
                                showInSnackBar(
                                    "We are Posting your Review Please wait");
                                await uploadImageToFirebase(sliderValue,
                                        comment, authobj.currentUser.name)
                                    .whenComplete(() => {
                                          setState(() {
                                            sliderValue = 0.0;
                                            _imagepathone = null;
                                            _imagepathtwo = null;
                                            _imagepaththree = null;
                                            comment = null;
                                            controller.text = "";
                                          }),
                                          Toast.show("Review Uploaded", context)
                                        });
                              }
                            },
                          ),
                        )),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  Future uploadImageToFirebase(slidervalue, comment, name) async {
    String time = DateTime.now().toString();

    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${authobj.currentUser.email}/$time' + "imageone");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imagepathone);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          imageurl1 = value;
        });
      },
    );
    StorageReference firebaseStorageRef2 = FirebaseStorage.instance
        .ref()
        .child('uploads/${authobj.currentUser.email}/$time' + "imagetwo");
    StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(_imagepathtwo);
    StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
    taskSnapshot2.ref.getDownloadURL().then(
      (value) {
        setState(() {
          imageurl2 = value;
        });
      },
    ).whenComplete(() => {
          FirebaseFirestore.instance
        .collection("PRODUCT")
        .doc(productuid)
        .collection("REVIEWS")
        .doc()
        .set({
      "ratings": sliderValue,
      "comments": comment,
      "imageurl1": imageurl1,
      "imageurl2": imageurl2,
      "username": authobj.currentUser.name,
    })
    });
   
  }
}

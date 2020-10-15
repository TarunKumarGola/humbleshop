import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Subscription _subscription;
  File _video;
  String name;
  String description;
  String price;
  String dropdownvalue = 'Category';
  final _flutterVideoCompress = FlutterVideoCompress();
  MediaInfo _compressedVideoInfo = MediaInfo(path: '');
  final _loadingStreamCtrl = StreamController<bool>.broadcast();
  String _taskName;
  double _progressState = 0;
  VideoPlayerController _videoPlayerController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String videopath;
  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        _progressState = progress;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
    _loadingStreamCtrl.close();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

// This funcion will helps you to pick a Video File
  _pickVideoFromGallery() async {
    PickedFile video = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 15),
    );
    _video = File(video.path);
    videopath = video.path;
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  _pickVideoFromCamera() async {
    PickedFile video = await ImagePicker().getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 15));
    _video = File(video.path);
    videopath = video.path;
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController.play();
        });
      });
  }

  String validateName(String value) {
    if (value == null) {
      return "This field can't be empty";
    }
    return null;
  }

  _addProduct() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      // Start validating on every change.
      showInSnackBar("please fix the errors in red before submitting");
    } else if (dropdownvalue == 'Category') {
      showInSnackBar("please select a valid category");
    } else if (_video == null) {
      showInSnackBar("please select a video from camera or gallery");
    } else {
      form.save();
      //now we are uploading our file to firebase storage
      var id = new DateTime.now().millisecondsSinceEpoch;
      //String fileName = "${authobj.currentUser.uid}_product_$id";
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('${authobj.currentUser.uid}/$id');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_video);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        print("Done: $value");
        await FirebaseFirestore.instance
            .collection("PRODUCT")
            .doc("${authobj.currentUser.uid}_$id")
            .set({
              "Brand": "Spark",
              "likes": "0",
              "comments": "0",
              "profileImg": authobj.currentUser.imageurl,
              "shopnow":
                  "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
              "offer": "10% off",
              "shares": "0",
              "country": "india",
              "name": name,
              "price": price,
              "description": description,
              "category": dropdownvalue,
              "videoUrl": value,
              "productsuid": "${authobj.currentUser.uid}_$id",
              "shoplocation": GeoPoint(sellerobj.shoplocation.latitude,
                  sellerobj.shoplocation.longitude)
            })
            .then((value) {})
            .catchError((error) {
              print('unable to upload product');
            });

        await FirebaseFirestore.instance
            .collection("SELLERS")
            .doc(authobj.currentUser.uid)
            .update({
          "productsuid":
              FieldValue.arrayUnion(["${authobj.currentUser.uid}_$id"])
        });
      }).catchError((onError) {
        showInSnackBar("fail in upload error$onError");
      });
    }
    // showInSnackBar("Registration successful");
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);
    return MaterialApp(
      theme: ThemeData(primaryColor: primary),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add New Product"),
        ),
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    sizedBoxSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        cursorColor: cursorColor,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "ProductName*",
                            hintText: "Enter Your Product Name"),
                        maxLines: 1,
                        validator: validateName,
                        onSaved: (value) {
                          name = value;
                        },
                      ),
                    ),
                    sizedBoxSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        cursorColor: cursorColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: "Price*",
                            hintText: "Enter the Price"),
                        maxLength: 10,
                        maxLines: 1,
                        validator: validateName,
                        onSaved: (value) {
                          price = value;
                        },
                      ),
                    ),
                    sizedBoxSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        cursorColor: cursorColor,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Tell Us about the Product",
                          helperText: "Keep it short",
                          labelText: "Description",
                        ),
                        onSaved: (value) {
                          description = value;
                        },
                        validator: validateName,
                        maxLines: 3,
                      ),
                    ),
                    sizedBoxSpace,
                    DropdownButton<String>(
                      value: dropdownvalue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: primary),
                      underline: Container(
                        height: 2,
                        color: primary,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                      items: <String>[
                        'Category',
                        'Toys',
                        'Home & Kitchen',
                        'Medicines',
                        'Men Clothing',
                        'Women Clothing',
                        'Mobile & Accessories'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    sizedBoxSpace,
                    if (_video != null)
                      _videoPlayerController.value.initialized
                          ? Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController),
                                )
                              ],
                            )
                          : Container()
                    else
                      Text(
                        "Click on Pick Video to select video",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    sizedBoxSpace,
                    RaisedButton(
                      onPressed: () {
                        _pickVideoFromGallery();
                      },
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Pick Video From Gallery",
                          style: TextStyle(color: Colors.white)),
                      color: primary,
                    ),
                    sizedBoxSpace,
                    RaisedButton(
                      onPressed: () {
                        _pickVideoFromCamera();
                      },
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Pick Video From Camera",
                          style: TextStyle(color: Colors.white)),
                      color: primary,
                    ),
                    sizedBoxSpace,
                    RaisedButton(
                      onPressed: () async {
                        await _addProduct();
                      },
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Add Product",
                          style: TextStyle(color: Colors.white)),
                      color: primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

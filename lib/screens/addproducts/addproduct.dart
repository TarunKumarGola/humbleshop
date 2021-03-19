import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/screens/myproduct/myproductpage.dart';
import 'package:shop_app/screens/orderrecievedpage/orderreceived.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerdescription = TextEditingController();
  TextEditingController controllerprice = TextEditingController();
  TextEditingController controllerspeciality = TextEditingController();
  TextEditingController controlleroffer = TextEditingController();
  TextEditingController controllerdiscount = TextEditingController();
  int discount = 0;
  int price = 0;
  int finalprice = 0;
  int humblecharges = 0;
  String humblecharge = "0";
  String finalprices = "0";

  Color _tempShadeColor;
  Color _shadeColor = Colors.blue[800];
  List colors = new List();
  String brand = null;
  Subscription _subscription;
  File _video;
  String dropdownvalue = 'Category';
  String countryvalue = 'Select Country';
  final _flutterVideoCompress = FlutterVideoCompress();
  // ignore: unused_field
  MediaInfo _compressedVideoInfo = MediaInfo(path: '');
  final _loadingStreamCtrl = StreamController<bool>.broadcast();
  // ignore: unused_field
  String _taskName;
  // ignore: unused_field
  double _progressState = 0;
  String videourl;
  VideoPlayerController _videoPlayerController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String videopath;
  File _imagepathone;
  File _imagepathtwo;
  File _imagepaththree;
  String imageurl1;
  String imageurl2;
  String imageurl3;
  String useremailid = FirebaseAuth.instance.currentUser.email;
  List brands = [
    'Apple',
    'OnePlus',
    'Realme',
    'Samsung',
    'Asus',
    'Lenevo',
    'Oppo',
    'Xiaomi',
    'Apple MacBook',
    'HP Laptops',
    'Dell Laptops',
    'Asus Laptops',
    'Lenovo Laptops',
    'Avita Laptops',
    'Acer Laptops',
    'Huawei Laptops',
    'Samsung Laptops',
    'Ethnic Wear',
    'T-Shirts',
    'Body Shape',
    'Jackets',
    'Jeans',
    'Indian',
    'Shirts',
    'Tuxedo',
    'Kargo Pants',
    'Track Pants',
    'Zara',
    'Levis',
    'Global Desi',
    'Allen Solly',
    'FabIndia',
    'Biba',
    'Globus',
    'Bombay Selection',
    'W for Woman',
    'Arrow sports',
    'Reebok',
    'Adidas',
    'Alan jones',
    'Allen solly',
    'American indigo',
    'Antony morato',
    'Arrow',
    'Dcathleon',
    'Gs',
    'Gas',
    'Being human',
    'Bhumika fashion',
    'Black coffee',
    'Blue ice',
    'Black berry',
    'C. O. D',
    'Calvin Klein',
    'Caption America',
    'Cargo tax',
    'Celio',
    'Cherry',
    'U. S polo',
  ];
  var _suggestioncontroller = new TextEditingController();
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
    _subscription.unsubscribe();
    _loadingStreamCtrl.close();
    _videoPlayerController.dispose();
    controllerdescription.dispose();
    controllername.dispose();
    controlleroffer.dispose();
    controllerprice.dispose();
    controllerspeciality.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  Future uploadImageToFirebaseone(BuildContext context, var id) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${authobj.currentUser.uid}/$id' + "imageone");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imagepathone);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          imageurl1 = value;
        });
        FirebaseFirestore.instance
            .collection("PRODUCT")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl1': value,
        });
        FirebaseFirestore.instance
            .collection("SELLERS")
            .doc(authobj.currentUser.uid)
            .collection("MyProduct")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl1': value,
        });
      },
    );
  }

  Future uploadImageToFirebasetwo(BuildContext context, var id) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${authobj.currentUser.uid}/$id' + "imagetwo");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imagepathtwo);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          imageurl2 = value;
        });
        FirebaseFirestore.instance
            .collection("PRODUCT")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl2': value,
        });
        FirebaseFirestore.instance
            .collection("SELLERS")
            .doc(authobj.currentUser.uid)
            .collection("MyProduct")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl2': value,
        });
      },
    );
  }

  Future uploadImageToFirebasethree(BuildContext context, var id) async {
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${authobj.currentUser.uid}/$id' + "imagethree");
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imagepaththree);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          imageurl3 = value;
        });
        FirebaseFirestore.instance
            .collection("PRODUCT")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl3': value,
        });
        FirebaseFirestore.instance
            .collection("SELLERS")
            .doc(authobj.currentUser.uid)
            .collection("MyProduct")
            .doc("${authobj.currentUser.uid}_$id")
            .update(<String, String>{
          'imageurl3': value,
        });
      },
    );
  }

// This funcion will helps you to pick a Video File
  _pickVideoFromGallery() async {
    PickedFile video = await ImagePicker().getVideo(
      source: ImageSource.gallery,
    );

    _video = File(video.path);
    int sizeInBytes = _video.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 300) {
      showInSnackBar("Please Reduce the size of the video below 20 Mb");
      return;
    }
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

  final picker = ImagePicker();
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

  _addProduct() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      // Start validating on every change.
      showInSnackBar("please fix the errors in red before submitting");
    } else if (dropdownvalue == 'Category') {
      showInSnackBar("please select a valid category");
    } else if (controllerdescription.text == '' ||
        controllername.text == '' ||
        controlleroffer.text == '' ||
        controllerspeciality.text == '' ||
        controllerprice.text == '') {
      showInSnackBar("Pleas fill empty fields");
    } else if (colors.length == 0) {
      showInSnackBar("Please choose colors");
    } else if (countryvalue == 'Select Country') {
      showInSnackBar("Please Select Country");
    } else if (_imagepathone == null)
      showInSnackBar("Please Choose Image One");
    else if (_imagepathtwo == null)
      showInSnackBar("Please Choose Image Two");
    else if (_imagepaththree == null)
      showInSnackBar("Please Choose Image three");
    else if (brand == null)
      showInSnackBar("Please Choose brand");
    else if (finalprice <= 0)
      showInSnackBar("Please Choose Right price");
    else {
      form.save();
      List<String> clist = new List();
      for (int i = 0; i < colors.length; i++) clist.add(colors[i].toString());
      showAlertDialog(context);
      //now we are uploading our file to firebase storage
      var id = new DateTime.now().millisecondsSinceEpoch;
      //String fileName = "${authobj.currentUser.uid}_product_$id";
      if (_video != null) {
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('${authobj.currentUser.uid}/$id');
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_video);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        taskSnapshot.ref.getDownloadURL().then((value) async {
          print("Done: $value");
          videourl = value;
          await FirebaseFirestore.instance
              .collection("PRODUCT")
              .doc("${authobj.currentUser.uid}_$id")
              .set({
            "likes": "0",
            "comments": "0",
            "profileImg": authobj.currentUser.imageurl,
            "shopnow":
                "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
            "offer": controlleroffer.text,
            "shares": "0",
            "country": countryvalue,
            "name": controllername.text,
            "price": finalprice.toString(),
            "speciality": controllerspeciality.text,
            "description": controllerdescription.text,
            "category": dropdownvalue,
            "videoUrl": value,
            "productsuid": "${authobj.currentUser.uid}_$id",
            "colors": FieldValue.arrayUnion(clist),
            "selleruid": FirebaseAuth.instance.currentUser.email,
            "phonenumber": FirebaseAuth.instance.currentUser.phoneNumber,
            "brand": brand
          }).then((value) {
            FirebaseFirestore.instance
                .collection("SELLERS")
                .doc(authobj.currentUser.email)
                .collection("MyProduct")
                .doc("${authobj.currentUser.uid}_$id")
                .set({
              "likes": "0",
              "comments": "0",
              "profileImg": authobj.currentUser.imageurl,
              "shopnow":
                  "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
              "offer": controlleroffer.text,
              "shares": "0",
              "country": countryvalue,
              "name": controllername.text,
              "price": finalprice.toString(),
              "speciality": controllerspeciality.text,
              "description": controllerdescription.text,
              "category": dropdownvalue,
              "videoUrl": videourl,
              "productsuid": "${authobj.currentUser.uid}_$id",
              "colors": FieldValue.arrayUnion(clist),
              "selleruid": FirebaseAuth.instance.currentUser.email,
              "phonenumber": FirebaseAuth.instance.currentUser.phoneNumber,
              "brand": brand
            });
            uploadImageToFirebaseone(context, id);
            uploadImageToFirebasetwo(context, id);
            uploadImageToFirebasethree(context, id);
            print("debug product upload successful");
            Navigator.pop(context);
            showInSnackBar("Product upload successful");
            setState(() {
              videopath = null;
              controllername.text = "";
              _video = null;
              controllerdescription.text = "";
              dropdownvalue = 'Category';
              controllerprice.text = "";
              colors = new List();
              _video = null;
              controlleroffer.text = '';
              controllerspeciality.text = '';
              _imagepathone = null;
              _imagepathtwo = null;
              _imagepaththree = null;
            });
          }).catchError((error) {
            print('debug unable to upload product');
            print(error);
            Navigator.pop(context);
            showInSnackBar("Something went wrong Please try again");
          });

          await FirebaseFirestore.instance
              .collection("SELLERS")
              .doc(FirebaseAuth.instance.currentUser.email)
              .update({
            "productsuid":
                FieldValue.arrayUnion(["${authobj.currentUser.uid}_$id"])
          }).catchError((e) {
            print(
                "debug something went wrong while updation seller productsuid");
          });
        }).catchError((onError) {
          Navigator.pop(context);
          showInSnackBar("fail in upload error$onError");
        });
      } else {
        videourl =
            "https://firebasestorage.googleapis.com/v0/b/humble-market.appspot.com/o/paint-3d-2021-02-28-09-59-56_6sG9GUTI_SLxe.mp4?alt=media&token=850473fc-9379-4c3a-aa18-530e3d994ed8";
        await FirebaseFirestore.instance
            .collection("PRODUCT")
            .doc("${authobj.currentUser.uid}_$id")
            .set({
          "likes": "0",
          "comments": "0",
          "profileImg": authobj.currentUser.imageurl,
          "shopnow":
              "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
          "offer": controlleroffer.text,
          "shares": "0",
          "country": countryvalue,
          "name": controllername.text,
          "price": controllerprice.text,
          "speciality": controllerspeciality.text,
          "description": controllerdescription.text,
          "category": dropdownvalue,
          "videoUrl": videourl,
          "productsuid": "${authobj.currentUser.uid}_$id",
          "colors": FieldValue.arrayUnion(clist),
          "selleruid": FirebaseAuth.instance.currentUser.email,
          "phonenumber": FirebaseAuth.instance.currentUser.phoneNumber,
          "brand": brand
        }).then((value) {
          FirebaseFirestore.instance
              .collection("SELLERS")
              .doc(FirebaseAuth.instance.currentUser.email)
              .collection("MyProduct")
              .doc("${authobj.currentUser.uid}_$id")
              .set({
            "likes": "0",
            "comments": "0",
            "profileImg": authobj.currentUser.imageurl,
            "shopnow":
                "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80",
            "offer": controlleroffer.text,
            "shares": "0",
            "country": countryvalue,
            "name": controllername.text,
            "price": controllerprice.text,
            "speciality": controllerspeciality.text,
            "description": controllerdescription.text,
            "category": dropdownvalue,
            "videoUrl": videourl,
            "productsuid": "${authobj.currentUser.uid}_$id",
            "colors": FieldValue.arrayUnion(clist),
            "selleruid": FirebaseAuth.instance.currentUser.email,
            "phonenumber": FirebaseAuth.instance.currentUser.phoneNumber,
            "brand": brand
          });
          uploadImageToFirebaseone(context, id);
          uploadImageToFirebasetwo(context, id);
          uploadImageToFirebasethree(context, id);
          print("debug product upload successful");
          Navigator.pop(context);
          showInSnackBar("Product upload successful");
          setState(() {
            videopath = null;
            controllername.text = "";
            _video = null;
            controllerdescription.text = "";
            dropdownvalue = 'Category';
            controllerprice.text = "";
            colors = new List();
            _video = null;
            controlleroffer.text = '';
            controllerspeciality.text = '';
            _imagepathone = null;
            _imagepathtwo = null;
            _imagepaththree = null;
          });
        }).catchError((error) {
          print('debug unable to upload product');
          print(error);
          Navigator.pop(context);
          showInSnackBar("Something went wrong Please try again");
        });

        await FirebaseFirestore.instance
            .collection("SELLERS")
            .doc(FirebaseAuth.instance.currentUser.email)
            .update({
          "productsuid":
              FieldValue.arrayUnion(["${authobj.currentUser.uid}_$id"])
        }).catchError((e) {
          print("debug something went wrong while updation seller productsuid");
        });
      }
    }
    // showInSnackBar("Registration successful");
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 15);
    return MaterialApp(
      theme: ThemeData(primaryColor: primary),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add New Product"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleclick,
              itemBuilder: (BuildContext context) {
                return {'My Product', 'Order Received'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
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
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "ProductName*",
                              hintText: "Enter Your Product Name"),
                          maxLines: 1,
                          validator: validateName,
                          controller: controllername,
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          cursorColor: cursorColor,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "Discount*",
                              hintText: "Discount percentage (1%-100%)"),
                          maxLength: 10,
                          maxLines: 1,
                          validator: validateName,
                          controller: controllerdiscount,
                          onChanged: (value) {
                            discount = int.parse(value.toString());
                            if (price > 0 && discount > 0) {
                              finalprice =
                                  price - ((price * discount) / 100).round();
                              if (finalprice <= 100)
                                humblecharges = 0;
                              else if (finalprice > 100 && finalprice <= 500)
                                humblecharges = 20;
                              else if (finalprice > 500 && finalprice <= 1000)
                                humblecharges = 50;
                              else
                                humblecharges = 100;
                              setState(() {
                                humblecharge = humblecharges.toString();
                                finalprice = finalprice + humblecharges;
                                finalprices = finalprice.toString();
                              });
                            }
                          },
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                          controller: controllerprice,
                          onChanged: (value) {
                            price = int.parse(value.toString());
                            if (price > 0 && discount > 0) {
                              finalprice =
                                  price - ((price * discount) / 100).round();
                              if (finalprice <= 100)
                                humblecharges = 0;
                              else if (finalprice > 100 && finalprice <= 500)
                                humblecharges = 20;
                              else if (finalprice > 500 && finalprice <= 1000)
                                humblecharges = 50;
                              else
                                humblecharges = 100;
                              setState(() {
                                humblecharge = humblecharges.toString();
                                finalprice = finalprice + humblecharges;
                                finalprices = finalprice.toString();
                              });
                            }
                          },
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "Final Price RS.$finalprices",
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "Humble Market Charges RS.$humblecharge",
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          cursorColor: cursorColor,
                          maxLength: 80,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "This will be visible with main video",
                            helperText: "Keep it short",
                            labelText: "Speciality",
                          ),
                          controller: controllerspeciality,
                          validator: validateName,
                          maxLines: 1,
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Tell Us about the Product",
                            helperText: "Keep it short",
                            labelText: "Description",
                          ),
                          controller: controllerdescription,
                          validator: validateName,
                          maxLines: 3,
                        ),
                      ),
                      sizedBoxSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: TextFormField(
                          cursorColor: cursorColor,
                          maxLength: 80,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "This will ve visible with Main video",
                            helperText: "Keep it short",
                            labelText: "Other Offers",
                          ),
                          controller: controlleroffer,
                          validator: validateName,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      colorPickerWidget(),
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
                          'Mobile & Accessories',
                          'Laptops',
                          'SmartPhones',
                          'FootWear',
                          'Beauty Product'
                              'Kids Fashion',
                          'Appliances',
                          'Books',
                          'Doctor'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      sizedBoxSpace,
                      AutoCompleteTextField(
                        controller: _suggestioncontroller,
                        suggestions: brands,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: "Brand Name"),
                        itemFilter: (item, query) {
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.compareTo(b);
                        },
                        itemSubmitted: (item) {
                          _suggestioncontroller.text = item;
                          brand = item;
                        },
                        itemBuilder: (context, item) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  item,
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          );
                        },
                        clearOnSubmit: false,
                        key: null,
                      ),
                      sizedBoxSpace,
                      DropdownButton<String>(
                        value: countryvalue,
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
                            countryvalue = newValue;
                          });
                        },
                        items: <String>[
                          'Select Country',
                          'India',
                          'Other',
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
                            ? VisibilityDetector(
                                key: Key("add product key"),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  debugPrint(
                                      "${info.visibleFraction} of my widget is visible");
                                  if (info.visibleFraction == 0) {
                                    _videoPlayerController.pause();
                                  } else {
                                    _videoPlayerController.play();
                                  }
                                },
                                child: Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: _videoPlayerController
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(_videoPlayerController),
                                    )
                                  ],
                                ),
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
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text("Pick Video From Gallery (Not compulsory)",
                            style: TextStyle(color: Colors.white)),
                        color: primary,
                      ),
                      sizedBoxSpace,
                      /* RaisedButton(
                        onPressed: () {
                          _pickVideoFromCamera();
                        },
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text("Pick Video From Camera",
                            style: TextStyle(color: Colors.white)),
                        color: primary,
                      ),
                      sizedBoxSpace,
                      */
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
                      sizedBoxSpace,
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
                      sizedBoxSpace,
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imagepaththree != null
                              ? InkWell(
                                  child: Image.file(_imagepaththree),
                                  onTap: () {
                                    setState(() {
                                      _imagepaththree = null;
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImagethree,
                                ),
                        ),
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
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() => _shadeColor = _tempShadeColor);
                setState(() => colors.add(_shadeColor));
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onBack: () => print("Back button pressed"),
      ),
    );
  }

  Widget colorPickerWidget() {
    return Column(
      children: [
        const SizedBox(height: 32.0),
        const SizedBox(
          width: 10,
        ),
        OutlineButton(
          onPressed: _openColorPicker,
          child: const Text('Add Color Options '),
        ),
        const SizedBox(height: 16.0),
        colors.length != 0
            ? Container(
                height: 60,
                child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 3,
                                color: colors[index],
                                style: BorderStyle.solid)),
                        padding: EdgeInsets.all(5),
                        elevation: 5,
                        color: colors[index],
                        onPressed: () {
                          setState(() {
                            colors.remove(colors[index]);
                          });
                        },
                      );
                    }),
              )
            : Column(),
      ],
    );
  }

  Future<void> handleclick(String value) async {
    switch (value) {
      case 'My Product':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyProduct()));
        break;
      case 'Order Received':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyOrder()));
        break;
    }
  }
}

Future<int> getFileSize(String filepath) async {
  var file = File(filepath);
  int bytes = await file.length();
  int size = (bytes / 1000000).round();
  return size;
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

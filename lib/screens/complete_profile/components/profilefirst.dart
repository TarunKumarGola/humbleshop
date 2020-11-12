import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/authenticate/authenticate.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
//import 'package:url_launcher/url_launcher.dart' as launcher;

class ProfilePage extends StatefulWidget {
  ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  // ignore: non_constant_identifier_names
  TextEditingController controller_name = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController controller_email = new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController controller_address = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                authobj.currentUser.imageurl,
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: primary,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () async {
                              await showpicker(context);
                            },
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField(
                  "Full Name", authobj.currentUser.name, controller_name),
              buildTextField(
                  "E-mail", authobj.currentUser.email, controller_email),
              // buildTextField("Password", "********", true),
              buildTextField(
                  "Address", authobj.currentUser.address, controller_address),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      controller_name.text = authobj.currentUser.name;
                      controller_email.text = authobj.currentUser.email;
                      controller_address.text = authobj.currentUser.address;
                    },
                    child: Text("Reset",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      bool success = await authobj.updateUser(
                          name: controller_name.text,
                          email: controller_email.text,
                          address: controller_address.text);

                      if (success) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Data updation successful")));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Something went wrong please try again")));
                      }
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    bool enabled = true;
    controller.text = placeholder;
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Container(
        child: TextField(
          readOnly: enabled,

          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3, left: 3.0),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: controller.text,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                Icons.edit,
                color: primary,
              ),
              onTap: () {
                setState(() {
                  enabled = false;
                });
              },
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.edit, color: primary),
          //   onPressed: () {
          //     setState(() {
          //       enabled = false;
          //     });

          //     print('tap');
          //     print(enabled);
          //   },
          // ),
        ),
      ),
      // child: TextField(
      //   //  enabled: enabled,

      //   readOnly: enabled,
      //   controller: controller,
      //   // readOnly: readonly,
      //   //obscureText: isPasswordTextField ? showPassword : false,
      //   decoration: InputDecoration(
      //       suffixIcon: IconButton(
      //         onPressed: () {
      //           setState(() {
      //             //showPassword = !showPassword;
      //             enabled = false;
      //             print("enabled=$enabled");
      //           });
      //         },
      //         icon: Icon(
      //           Icons.edit,
      //           color: primary,
      //         ),
      //       ),
      //       contentPadding: EdgeInsets.only(bottom: 3),
      //       labelText: labelText,
      //       floatingLabelBehavior: FloatingLabelBehavior.always,
      //       hintText: controller.text,
      //       hintStyle: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.black,
      //       )),
      //   onChanged: (value) {
      //     setState(() {
      //       controller.text = value;
      //     });
      //   },
      // ),
    );
  }

  showpicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _imgFromGallery();
                        if (_image != null) {
                          await uploadImageToFirebase(context);

                          _image = null;
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _imgFromCamera();
                      if (_image != null) {
                        await uploadImageToFirebase(context);

                        _image = null;
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = "${authobj.currentUser.uid}_profileimage";
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilepictures/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) async {
        print("Done: $value");

        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(authobj.currentUser.uid)
            .update({'imageurl': '$value'}).then((value) {
          print("User Updated");
        }).catchError((error) {
          print("Failed to update user: $error");
          return;
        });
        setState(() {
          authobj.currentUser.imageurl = value;
        });
      },
    );
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Logout':
        await FirebaseAuth.instance.signOut().whenComplete(() => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Authenticate()),
                  (route) => false)
            });
        break;
    }
  }
}

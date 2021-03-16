import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:toast/toast.dart';

import '../../constants.dart';

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String area;
  String pincode;
  String city;
  String state;
  String landmark;
  String town;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Address',
          style: TextStyle(color: kPrimaryColor),
        ),
        shadowColor: kPrimaryColor,
        actionsIconTheme: IconThemeData(color: kPrimaryColor),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 10.0,
          ),
          child: _buildForm(),
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            debugPrint('All validations passed!!!');
          }
        },
        child: Icon(Icons.done),
      ),*/
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Area/Street/Block',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                area = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Town/Village',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                town = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'District/City',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                city = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'State/UT',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                state = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Pincode',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                pincode = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Address cannot be empty';
                } else if (value.length < 5) {
                  return 'Enter a Valid Address';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'LandMark',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              onChanged: (value) {
                landmark = value;
              },
            ),
          ),
          FlatButton(
            splashColor: Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kPrimaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                FirebaseFirestore.instance
                    .collection("USERS")
                    .doc(authobj.currentUser.uid)
                    .update({
                  "AreaBlock": area,
                  "TownVillage": town,
                  "StateUT": state,
                  "DistrictCity": city,
                  "PinCode": pincode,
                  "landmark": landmark,
                }).whenComplete(() => {Toast.show("Address Updated", context)});
                setState(() {
                  landmark = null;
                  state = null;
                  city = null;
                  pincode = null;
                  town = null;
                  area = null;
                  _formKey.currentState.reset();
                });
              }
            },
            child: Text(
              "Save Address",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

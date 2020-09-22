// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'dart:html';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:shop_app/theme/colors.dart';

//import 'package:gallery/l10n/gallery_localizations.dart';

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({Key key}) : super(key: key);

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class PersonData {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            // semanticLabel: _obscureText
            //     ? GalleryLocalizations.of(context)
            //         .demoTextFieldShowPasswordLabel
            //     : GalleryLocalizations.of(context)
            //         .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
    );
  }
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  // final _UsNumberTextInputFormatter _phoneNumberFormatter =
  //     _UsNumberTextInputFormatter();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Please fix errors in Red")));
    } else {
      form.save();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Successful")));
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "This field can't be empty";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Please Enter Only Alphabets";
    }
    return null;
  }

  String _validatePhoneNumber(String value) {
    if (value.length < 10) {
      return "Enter Correct Phone number";
    }
    return null;
  }

  String _validatePassword(String value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return "This field can't be empty";
    }
    if (passwordField.value != value) {
      return "Password does not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
        key: _scaffoldKey,
        body: Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: Container(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: ListView(
                children: [
                  sizedBoxSpace,
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.person),
                      hintText: "Enter your Name",
                      labelText: "Name*",
                    ),
                    onSaved: (value) {
                      person.name = value;
                    },
                    validator: _validateName,
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.home),
                      hintText: "Enter your Shop Name",
                      labelText: "Shop Name*",
                    ),
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.phone),
                      hintText: "98XXXXXXXX",
                      labelText: "Phone number*",
                      prefixText: '+1 91',
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      person.phoneNumber = value;
                    },
                    maxLength: 10,
                    maxLengthEnforced: true,
                    validator: _validatePhoneNumber,
                    // TextInputFormatters are applied in sequence.
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.email),
                      hintText: "Your email address",
                      labelText: "Email*",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      person.email = value;
                    },
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Tell Us about your Shop",
                      helperText: "Keep it short",
                      labelText: "Description",
                    ),
                    maxLines: 3,
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "PAN number*",
                        hintText: "Enter your 10 digit Pan"),
                    maxLines: 1,
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "AAdhar number*",
                        hintText: "Enter your 12 digit Pan"),
                    maxLines: 1,
                  ),
                  sizedBoxSpace,
                  PasswordField(
                    fieldKey: _passwordFieldKey,
                    helperText: "No more than 8 characters",
                    labelText: "Password*",
                    onFieldSubmitted: (value) {
                      setState(() {
                        person.password = value;
                      });
                    },
                  ),
                  sizedBoxSpace,
                  TextFormField(
                    cursorColor: cursorColor,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Re-type password*",
                    ),
                    maxLength: 8,
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  sizedBoxSpace,
                  Center(
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: _handleSubmitted,
                      color: primary,
                    ),
                  ),
                  sizedBoxSpace,
                  Text(
                    "indicates required field",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  sizedBoxSpace,
                ],
              ),
            )));
  }
}

// /// Format incoming numeric text to fit the format of (###) ###-#### ##
// class _UsNumberTextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final newTextLength = newValue.text.length;
//     final newText = StringBuffer();
//     var selectionIndex = newValue.selection.end;
//     var usedSubstringIndex = 0;
//     if (newTextLength >= 1) {
//       newText.write('(');
//       if (newValue.selection.end >= 1) selectionIndex++;
//     }
//     if (newTextLength >= 4) {
//       newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
//       if (newValue.selection.end >= 3) selectionIndex += 2;
//     }
//     if (newTextLength >= 7) {
//       newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
//       if (newValue.selection.end >= 6) selectionIndex++;
//     }
//     if (newTextLength >= 11) {
//       newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
//       if (newValue.selection.end >= 10) selectionIndex++;
//     }
//     // Dump the rest.
//     if (newTextLength >= usedSubstringIndex) {
//       newText.write(newValue.text.substring(usedSubstringIndex));
//     }
//     return TextEditingValue(
//       text: newText.toString(),
//       selection: TextSelection.collapsed(offset: selectionIndex),
//     );
//   }
// }

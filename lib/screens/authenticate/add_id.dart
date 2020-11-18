import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lks/models/user.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/services/database.dart';
import 'package:lks/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';

class AddId extends StatefulWidget {
  @override
  _AddId createState() => _AddId();
}

class _AddId extends State<AddId> {

  final AuthService _auth = AuthService();
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(236, 235, 238, 1)),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    String strStdID = '';
    final FocusNode _pinPutFocusNode = FocusNode();
    final TextEditingController _pinPutController = TextEditingController();

    Future<void> _showMyDialog(String pin) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm ID'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Make sure your ID is correct, You cannot change it after this. \n', style: TextStyle(fontSize: 20)),
                  Text(pin, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.redAccent)),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () async {
                  setState(() => strStdID = pin);
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: user.uid).updateUserData(
                        strStdID,
                        true
                    );
                    Navigator.of(context).pop();
                  }
                },
                padding: EdgeInsets.all(12),
                color: Colors.lightBlue,
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
              FlatButton(
                child: Text('Edit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final showText = Center(
      child: Text("Insert your student ID.", style: TextStyle(fontSize: 20)),
    );

    final IdField = Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        margin: const EdgeInsets.all(20.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: PinPut(
          eachFieldHeight: 50,
          fieldsCount: 5,
          onSubmit: (pin) => _showMyDialog(pin),
          focusNode: _pinPutFocusNode,
          controller: _pinPutController,
          submittedFieldDecoration: _pinPutDecoration.copyWith(
            borderRadius: BorderRadius.circular(10.0),
          ),
          selectedFieldDecoration: _pinPutDecoration,
          followingFieldDecoration: _pinPutDecoration.copyWith(
            color: const Color.fromRGBO(236, 235, 238, 1),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: const Color.fromRGBO(236, 235, 238, 1),
            ),
          ),
        ),
      ),
    );
      /*child: PinCodeTextField(
        appContext: context,
        length: 5,
        obscureText: false,
        key: _formKey,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.blue.shade50,
        enableActiveFill: true,
        errorAnimationController: errorController,
        onChanged: (value) {
          setState(() => strStdID = value);
        },
      ),*/

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text('ClockInn'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                showText,
                IdField
              ],
            ),
        ),
      ),
    );
  }
}
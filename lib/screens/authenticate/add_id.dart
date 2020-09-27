import 'package:flutter/material.dart';
import 'package:lks/models/user.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/services/database.dart';
import 'package:lks/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class AddId extends StatefulWidget {
  @override
  _AddId createState() => _AddId();
}

class _AddId extends State<AddId> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    String strStdID = '';

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
                        strStdID
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
      child: OTPTextField(
        key: _formKey,
        length: 5,
        width: MediaQuery.of(context).size.width,
        fieldWidth: 80,
        style: TextStyle(
            fontSize: 17
        ),
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.underline,
        onCompleted: (pin) {
          _showMyDialog(pin);
        },
      ),
    );

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
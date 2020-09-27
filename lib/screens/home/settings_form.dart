import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lks/models/user.dart';
import 'package:lks/services/database.dart';
import 'package:lks/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();

  String strStdID = '';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your account',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      initialValue: userData.id,
                      decoration: InputDecoration(
                          hintText: 'Student ID',
                          contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                      ),
                      validator: (val) => val.isEmpty ? 'Enter an Student ID': null,
                      onChanged: (val){
                        setState(() => strStdID = val);
                      },
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        await DatabaseService(uid: user.uid).updateUserData(
                            strStdID ?? userData.id
                        );
                        Navigator.pop(context);
                      }
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.lightBlue,
                    child: Text('Update', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
        }else{
          return Loading();
        }
      }
    );
  }
}

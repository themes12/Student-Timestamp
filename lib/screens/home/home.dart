import 'package:flutter/material.dart';
import 'package:lks/models/brew.dart';
import 'package:lks/models/user.dart';
import 'package:lks/screens/home/settings_form.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/services/database.dart';
import 'package:lks/services/http.dart';
import 'package:lks/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:lks/screens/home/brew_list.dart';
import 'package:rich_alert/rich_alert.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  final Http _http = Http();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Timestamp'),
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('User'),
                  onPressed: () => _showSettingsPanel(),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Logout'),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                )
              ],
            ),
            body: Center(
              child: ListView(
                children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.lightBlue,
                          ),
                          title: Text("This is your ID ${userData.id}")
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)
                        ),
                        onPressed: () async {
                          dynamic result = await _http.sendStudentID(userData.id);
                          if(result == null){
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RichAlertDialog( //uses the custom alert dialog
                                    alertTitle: richTitle("Error connecting API!"),
                                    alertSubtitle: richSubtitle("Invalid Request."),
                                    alertType: RichAlertType.ERROR,
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        color: Colors.lightBlue,
                                      )
                                    ],
                                  );
                                }
                            );
                          }else{
                            if(result['statusCode'] == "SUCCESS"){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RichAlertDialog( //uses the custom alert dialog
                                      alertTitle: richTitle(result['headerText']),
                                      alertSubtitle: richSubtitle(result['outputText'] + " สำหรับนักเรียนรหัส ${userData.id}"),
                                      alertType: RichAlertType.SUCCESS,
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          color: Colors.lightBlue,
                                        )
                                      ],
                                    );
                                  }
                              );
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RichAlertDialog( //uses the custom alert dialog
                                      alertTitle: richTitle(result['headerText']),
                                      alertSubtitle: richSubtitle(result['outputText'] + " สำหรับนักเรียนรหัส ${userData.id}"),
                                      alertType: RichAlertType.ERROR,
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          color: Colors.lightBlue,
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                          }
                        },
                        padding: EdgeInsets.all(12),
                        color: Colors.lightBlue,
                        child: Text('ลงชื่อ', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lks/models/user.dart';
//import 'package:lks/screens/home/settings_form.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/services/database.dart';
import 'package:lks/services/http.dart';
import 'package:lks/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:lks/services/admob_service.dart';
import 'package:lks/screens/authenticate/add_id.dart';

class Home extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();

}

Future<void> _initAdMob() {
  return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
}

class _HomeAppState extends State<Home> {

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  final AuthService _auth = AuthService();
  final Http _http = Http();
  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _initAdMob();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    // TODO: Load a Banner Ad
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    /*void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: SettingsForm(),
        );
      });
    }*/

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Scaffold(resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text('ClockInn'),
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text(userData.id),
                  onPressed: () =>
                      Fluttertoast.showToast(
                          msg: "If you want to change your ID, Please contact us.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      ),
                     // _showSettingsPanel(),
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
                            backgroundImage: NetworkImage('http://ict.lks.ac.th/picpost/student/${userData.id}.jpg') ?? NetworkImage('http://ict.lks.ac.th/picpost/student/nopic.gif'),
                          ),
                          title: Text("เลขประจำตัว : ${userData.id}")
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.5, bottom: 22.5),
                    child: Center(
                      child: RoundedLoadingButton(
                        controller: _btnController,
                        onPressed: () async {
                          dynamic tokenID = await _auth.getIdToken();
                          dynamic result = await _http.sendStudentID(tokenID, userData.id);
                          if(result == null){
                            _btnController.reset();
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
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        color: Colors.lightBlue,
                                      )
                                    ],
                                  );
                                }
                            );
                          }else{
                            _btnController.success();
                            if(result['statusCode'] == "SUCCESS"){
                              _btnController.reset();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RichAlertDialog( //uses the custom alert dialog
                                      alertTitle: richTitle(result['headerText']),
                                      alertSubtitle: richSubtitle(result['outputText'] + " รหัสนักเรียน ${userData.id}"),
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
                              _btnController.reset();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RichAlertDialog( //uses the custom alert dialog
                                      alertTitle: richTitle(result['headerText']),
                                      alertSubtitle: richSubtitle(result['outputText']),
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
          UserData userData = snapshot.data;
          if(userData == null){
            return AddId();
          }else{
            return Loading();
          }
        }
      }
    );
  }
}

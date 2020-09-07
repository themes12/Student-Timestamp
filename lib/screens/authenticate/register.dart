import 'package:flutter/material.dart';
import 'package:lks/screens/authenticate/sign_in.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String strEmail = '';
  String strPassword ='';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Hero(
          tag: 'hero',
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 40.0,
            child: Image.network('https://icons.iconarchive.com/icons/custom-icon-design/flatastic-4/512/User-blue-icon.png'),
          )
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
      validator: (val) => val.isEmpty ? 'Enter an email': null,
      onChanged: (val){
        setState(() => strEmail = val);
      },
    );

    final password = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        autofocus: false,
        initialValue: '',
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
        validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long': null,
        onChanged: (val){
          setState(() => strPassword = val);
        },
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
        ),
        onPressed: () async {
          if(_formKey.currentState.validate()){
            setState(() => loading = true);
            dynamic result = await _auth.registerWithEmailAndPassword(strEmail, strPassword);
            if(result == null){
              setState(() {
                error = 'Please supply a valid email';
                loading = false;
              });
            }
          }
          /*dynamic result = await _auth.signInAnon();
          if(result == null){
            print('error signing in');
          } else {
            print('signed in');
            print(result.uid);
          }*/
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    final showRegisterError = Center(
      child: Text(
          error, style: TextStyle(color: Colors.redAccent)
      ),
    );
    

    final loginPage = FlatButton(
      child: Text("Already have an account? Login.", style: TextStyle(color: Colors.redAccent)),
      onPressed: (){
        widget.toggleView();
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );*/
      },
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
              padding: EdgeInsets.only(left: 24.0,right: 24.0),
              shrinkWrap: true,
              children: <Widget>[
                logo,
                email,
                password,
                registerButton,
                showRegisterError,
                loginPage
              ],
            )
        ),
      ),
    );
  }
}

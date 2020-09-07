import 'package:flutter/material.dart';
import 'package:lks/screens/authenticate/register.dart';
import 'package:lks/services/auth.dart';
import 'package:lks/shared/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //get Text
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
    
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
        ),
        onPressed: () async {
          if(_formKey.currentState.validate()){
            setState(() => loading = true);
            dynamic result = await _auth.signInWithEmailAndPassword(strEmail, strPassword);
            if(result == null){
              setState(() {
                error = 'Could not sign in with those credentials';
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
        child: Text('Login', style: TextStyle(color: Colors.white)),
      ),
    );

    final showSignInError = Center(
      child: Text(
          error, style: TextStyle(color: Colors.redAccent)
      ),
    );

    final createAccount = FlatButton(
      child: Text("Don't have an account? Create Account.", style: TextStyle(color: Colors.redAccent)),
      onPressed: (){
        widget.toggleView();
      },
    );

    final forgotPassword = FlatButton(
        child: Text('Forgot Password?', style: TextStyle(color: Colors.black45)),
        onPressed: (){
          Fluttertoast.showToast(
              msg: "We are not correctly support password reset, Please contact us to change your password.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
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
                loginButton,
                showSignInError,
                createAccount,
                forgotPassword
              ],
            )
        ),
      ),
    );
  }
}

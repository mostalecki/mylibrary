import 'package:flutter/material.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:mylibrary/shared/loading.dart';

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

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text('MyLibrary'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: widget.toggleView,
              icon: Icon(Icons.person),
              label: Text('Register'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val){
                  setState(() => email = val);
                },
                decoration: InputDecoration(
                    hintText: 'Email'
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val){
                  setState(() => password = val);
                },
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                child: Text('Sign in'),
                onPressed: () async {
                  setState(() => loading = true);
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.signIn(email, password);
                    if (result != null) {
                      setState(() {
                        error = result;
                        loading = false;
                      }
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 12.0,),
              Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14)
              )
            ],
          ),
        )
      ),
    );
  }
}

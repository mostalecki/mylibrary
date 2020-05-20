import 'package:flutter/material.dart';
import 'package:mylibrary/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();

  String validateEmail(email) {
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) return null;
    return 'Enter valid email';
  }
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String password2 = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyLibrary'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: widget.toggleView,
              icon: Icon(Icons.person),
              label: Text('Sign in'))
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
                  validator: (val) => widget.validateEmail(val)

                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  onChanged: (val){
                    setState(() => password = val);
                  },
                  decoration: InputDecoration(
                      hintText: 'Password'
                  ),
                  validator: (val) => val.length >= 8 ? null : 'Password must be at least 8 characters long.',
                  obscureText: true,
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  onChanged: (val){
                    setState(() => password2 = val);
                  },
                  decoration: InputDecoration(
                      hintText: 'Confirm password'
                  ),
                  validator: (val) => val == password ? null : 'Passwords don\'t match.',
                  obscureText: true,
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signUp(email, password);
                      if(result != null) {
                        setState(() {
                          error = result;
                        });
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

import 'package:flutter/material.dart';
import 'package:mylibrary/models/user.dart';
import 'package:mylibrary/screens/wrapper.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.orange[600],
          primarySwatch: Colors.red,
        ),
        home: Wrapper(),
      ),
    );
  }
}

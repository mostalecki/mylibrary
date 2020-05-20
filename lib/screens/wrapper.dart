import 'package:flutter/material.dart';
import 'package:mylibrary/models/user.dart';
import 'package:mylibrary/screens/authenticate/authenticate.dart';
import 'package:mylibrary/screens/home/home.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user == null){
      return Authenticate();
    } else {
      return Home(currentUser: user);
    }
  }
}

import 'package:dinendash/models/user.dart';
import 'package:dinendash/paths/authentication/authenticate.dart';
import 'package:dinendash/paths/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // Checking for change in User Status
    final user = Provider.of<User>(context);
    
    // Return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
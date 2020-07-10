import 'package:dinendash/services/auth.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton.icon(
        icon: Icon(Icons.person),
        label: Text('sign out'),
        onPressed: () => _auth.signOut(),
      ),
    );
  }
}
import 'package:dinendash/models/user.dart';
import 'package:dinendash/services/auth.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(primaryColor: primary, scaffoldBackgroundColor: background),
        home: Wrapper(),
      ),
    );
  }
}

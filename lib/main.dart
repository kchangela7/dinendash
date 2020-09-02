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
        theme: ThemeData(
            backgroundColor: background,
            primaryColor: primary,
            fontFamily: "MavenPro",
            appBarTheme: AppBarTheme(elevation: 2, color: background),
            dividerTheme: DividerThemeData(
                thickness: 0.75, space: 40, indent: 40, color: Colors.black26)),
        home: Wrapper(),
      ),
    );
  }
}

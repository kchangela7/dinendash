import 'package:dinendash/paths/home/screens/account/account.dart';
import 'package:dinendash/paths/home/screens/orders.dart';
import 'package:dinendash/paths/home/screens/scan/orderView/orderView.dart';
import 'package:dinendash/paths/home/screens/scan/scan.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [Orders(), Scan() /*OrderView()*/, Account()];

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 8,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.receipt),
          title: Text('Orders'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.qrcode),
          title: Text('Scan'),
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.userCircle),
          title: Text('Account'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: primary,
      onTap: _onItemTapped,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Container(
          color: background,
          child: Scaffold(
              bottomNavigationBar: bottomNavBar, body: pages[_selectedIndex]),
        ));
  }
}

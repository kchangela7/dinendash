import 'package:dinendash/paths/home/screens/account.dart';
import 'package:dinendash/paths/home/screens/orders.dart';
import 'package:dinendash/paths/home/screens/scan/myOrder.dart';
import 'package:dinendash/paths/home/screens/scan/scan.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
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

  List<Widget> pages = [Orders(), /*Scan()*/ MyOrder(), Account()];

  @override
  Widget build(BuildContext context) {

    final bottomNavBar = BottomNavigationBar(
      elevation: 15,
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

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Dine-N-Dash',
      //     style: TextStyle(color: background),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: primary,
      // ),
      bottomNavigationBar: bottomNavBar,
      body: SafeArea(child: pages[_selectedIndex])
    );
  }
}
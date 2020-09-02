import 'package:dinendash/paths/home/screens/account/payMethods/addCard.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PayMethods extends StatefulWidget {
  @override
  _PayMethodsState createState() => _PayMethodsState();
}

class _PayMethodsState extends State<PayMethods> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Payment", style: kAppBarHeading),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          // Select Payment Options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text("Select Payment Method", style: kAppBarHeading),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            leading: Image.asset('images/google-pay.png', width: 38),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Google Pay", style: kOrderTextStyle),
            ),
            trailing: Icon(Icons.check, color: primary, size: 28),
            onTap: () {},
          ),
          Divider(indent: 16, height: 0),

          // Add Payment Options
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Text("Add Payment Method", style: kAppBarHeading),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            leading: Icon(FontAwesomeIcons.creditCard, color: Colors.black),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Credit/Debit Card", style: kOrderTextStyle),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Colors.grey[600], size: 28),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddCard()));
            },
          ),
          Divider(indent: 0, height: 0),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            leading: Icon(Icons.account_balance, color: Colors.black, size: 28),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Bank Account", style: kOrderTextStyle),
            ),
            trailing:
                Icon(Icons.chevron_right, color: Colors.grey[600], size: 28),
            onTap: () {},
          ),
          Divider(indent: 0, height: 0),
        ],
      ),
    );
  }
}

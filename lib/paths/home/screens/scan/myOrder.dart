import 'package:dinendash/paths/home/home.dart';
import 'package:dinendash/paths/home/screens/scan/pay.dart';
import 'package:flutter/material.dart';

class MyOrder extends StatefulWidget {

  final String tableID;
  MyOrder({ this.tableID });

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  double total = 0.0;
  double tip = 0.0;
  double tax = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: Column(
        children: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.attach_money),
            label: Text('Pay'),
            onPressed: () => pay(total),
          ),
          FlatButton(
            child: Text('Return'),
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text('Are you sure you want to back out?'),
                          Text('You will have to scan the QR code again to return'),
                          Row(
                            children: <Widget>[
                              FlatButton(
                              child: Text('Yes, back out'),
                              onPressed: () {
                                Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (BuildContext context) => Home()));
                              },
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')
                              )
                            ]
                          )
                        ],
                      ),
                    ],
                  ),
                );
              });
            }
          )
        ],
      ),
    );
  }
}
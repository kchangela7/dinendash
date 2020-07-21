import 'package:dinendash/paths/home/home.dart';
import 'package:dinendash/paths/home/screens/scan/pay.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/shared/loading_utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyOrder extends StatefulWidget {

  final String tableID;
  MyOrder({ this.tableID });

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  Stream<Map<String, dynamic>> _currentOrder = (() async* {
    Map<String, dynamic> data = {
      "order": [{"item": "Burger", "price": 10.55, "quantity": 1}, {"item": "Burger", "price": 10.55, "quantity": 1}, {"item": "Burger", "price": 10.55, "quantity": 1}, {"item": "Large Fries", "price": 5.32, "quantity": 2}, {"item": "Ice Cream", "price": 10.00, "quantity": 1}, {"item": "Chicken Burger", "price": 9.64, "quantity": 1}], 
      "totals": {"subtotal": 40.83, "tax": 1.94, "total": 42.77}
    };
    await Future<void>.delayed(Duration(seconds: 1));
    yield data;
    await Future<void>.delayed(Duration(seconds: 1));
  })();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _currentOrder,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {

        List<Widget> children;
        var order;
        var totals = {"subtotal": 0.00, "tax": 0.00, "total": 0.00};
        
        if(snapshot.hasData) {
          order = snapshot.data["order"];
          totals = snapshot.data["totals"];
        }

        if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Select a lot'),
                  )
                ],
              );
              break;
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Loading(),
                ],
              );
            case ConnectionState.active:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Loading(),
                ],
              );
              break;
            case ConnectionState.done:
              if(snapshot.hasData) {
                children = <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 0, 32),
                      child: Text(
                        "ITEMS",
                        style: kOrderHeaderStyle,
                      ),
                    )
                  )
                ];
                
                // Create Order Items
                for (var i = 0; i < order.length; i++) {
                  var currentItem = order[i];
                  double itemPrice = currentItem['price'] * currentItem['quantity'];
                  children.add(
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${currentItem['quantity']}',
                                  style: kOrderTextStyle
                                ),
                                SizedBox(width: 29),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 225),
                                  child: Text(
                                    currentItem['item'],
                                    overflow: TextOverflow.clip,
                                    softWrap: true,
                                    style: kOrderTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 22, 0),
                              child: Text(
                                '\$${itemPrice.toStringAsFixed(2)}',
                                style: kCurrencyStyle,
                              ),
                            )
                          ]
                        ),
                        i != order.length - 1 ?
                          Divider() : 
                          Divider(thickness: 2),
                      ],
                    ),
                  );
                }

                // Add Totals
                children.addAll(
                  <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 24, 0, 0),
                        child: Text(
                          "TOTAL",
                          style: kOrderHeaderStyle,
                        ),
                      )
                    ),
                    Divider(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 8, 22, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Subtotal", style: kOrderTextStyle),
                              Text("\$${totals["subtotal"]}", style: kCurrencyStyle)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Tax", style: kOrderTextStyle),
                              Text("\$${totals["tax"]}", style: kCurrencyStyle)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 22, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total", style: kOrderTextBoldStyle),
                          Text("\$${totals["total"]}", style: kOrderTextBoldStyle)
                        ],
                      ),
                    ),
                    SizedBox(height: 100)
                  ],
                );
              } else {
                children = <Widget>[
                  Text("Nothing appears to have been ordered yet")
                ];
              }
              break;
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: background,
            elevation: 3,
            title: Text("The Burger Joint", style: TextStyle(fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReturnDialog();
                  }
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 4,
            highlightElevation: 8,
            onPressed: () => showModalBottomSheet(
              context: context, 
              builder: (BuildContext context) {
                return Pay(total: totals["total"]);
              }
            ),
            label: Container(
              width: 275,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 58),
                  Text('Pay', style: kOrderHeaderStyle),
                  Text('\$${totals["total"]}', style: kOrderHeaderStyle)
                ],
              ),
            ),
            backgroundColor: primary,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
            child: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
          )
        );
      }
    );
  }
}

class ReturnDialog extends StatelessWidget {
  const ReturnDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to back out?"),
      content: Text('You will have to scan the QR code again to return'),
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      actions: [
        FlatButton(
          child: Text('Yes, back out', style: TextStyle(fontSize: 16)),
          onPressed: () {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(fontSize: 16))
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}


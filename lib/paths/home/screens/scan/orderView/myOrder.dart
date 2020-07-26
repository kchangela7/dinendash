import 'package:dinendash/paths/home/home.dart';
import 'package:dinendash/paths/home/screens/scan/orderView/pay.dart';
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
      "order": [{"item": "Burger", "price": 10.55, "quantity": 1}, {"item": "Curry", "price": 12.97, "quantity": 1}, {"item": "Chicken Alfredo", "price": 11.29, "quantity": 1}, {"item": "Large Fries", "price": 5.32, "quantity": 2}, {"item": "Ice Cream", "price": 3.98, "quantity": 3}, {"item": "Chicken Burger", "price": 9.64, "quantity": 1}], 
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
                
                // Items Section
                for (var i = 0; i < order.length; i++) {
                  var currentItem = order[i];
                  double itemTotalPrice = currentItem['price'] * currentItem['quantity'];
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      constraints: BoxConstraints(maxWidth: 225),
                                      child: Text(
                                        currentItem['item'],
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        style: kOrderTextStyle,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text("@ \$${currentItem["price"].toStringAsFixed(2)} each", style: kCurrencyStyleSmall),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 22, 0),
                              child: Text(
                                '\$${itemTotalPrice.toStringAsFixed(2)}',
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

                // Totals Section
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
                    // Subtotal and Tax Display
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 8, 22, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Subtotal", style: kOrderTextStyle),
                              Text("\$${totals["subtotal"].toStringAsFixed(2)}", style: kCurrencyStyle)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Tax", style: kOrderTextStyle),
                              Text("\$${totals["tax"].toStringAsFixed(2)}", style: kCurrencyStyle)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    // Final Total Display
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 22, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total", style: kOrderTextBoldStyle),
                          Text("\$${totals["total"].toStringAsFixed(2)}", style: kOrderTextBoldStyle)
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

        // Scaffold with Items and Total
        return Scaffold(
          appBar: AppBar(
            title: Text("The Burger Joint", style: kOrderHeaderStyle),
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
              onPressed: () {
                // Back Arrow Dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReturnDialog();
                  }
                );
              },
            ),
          ),
          // Pay Floating Button
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
                  Text('\$${totals["total"].toStringAsFixed(2)}', style: kOrderHeaderStyle)
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
      title: Text("Are you sure you want to back out?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Text('You will have to scan the QR code again to return'),
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.green[800]))
        ),
        FlatButton(
          child: Text('Yes, back out', style: TextStyle(fontSize: 16, color: Colors.green[800])),
          onPressed: () {
            Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}


import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';

class MyOrder extends StatefulWidget {

  final Map<String, dynamic> data;
  MyOrder({ this.data });

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

  @override
  Widget build(BuildContext context) {

    List<Widget> children;

    if (widget.data["order"] != []) {
      final order = widget.data["order"];
      final totals = widget.data["totals"];

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

      return SingleChildScrollView(child: Column(children: children));

    } else {
      return Container();
    }
  }
}
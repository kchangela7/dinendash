import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pay extends StatefulWidget {

  final double total;
  
  Pay({ this.total });

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  
  List<bool> _selections = [false, true, false, false];
  String tip = "0.00";
  String payMethod = "Google Pay";

  @override
  void initState() {
    tip = (widget.total * 0.15).toStringAsFixed(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Waiter Tip", style: kOrderTextStyle),
                  Text("\$$tip", style: kOrderTextStyle)
                ],
              ),
            ),
            SizedBox(height: 12),
            ToggleButtons(
              children: <Widget>[
                Container(width: (MediaQuery.of(context).size.width - 55)/4, child: Text("10%", textAlign: TextAlign.center)),
                Container(width: (MediaQuery.of(context).size.width - 55)/4, child: Text("15%", textAlign: TextAlign.center)),
                Container(width: (MediaQuery.of(context).size.width - 55)/4, child: Text("20%", textAlign: TextAlign.center)),
                Container(width: (MediaQuery.of(context).size.width - 55)/4, child: Text("Other", textAlign: TextAlign.center))
              ],
              selectedColor: Colors.green[800],
              selectedBorderColor: Colors.green[700],
              textStyle: kCurrencyStyle,
              isSelected: _selections,
              color: Colors.grey[600],
              borderColor: Colors.grey,
              borderRadius: BorderRadius.circular(5),
              fillColor: Colors.green[50],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      _selections[buttonIndex] = true;
                    } else {
                      _selections[buttonIndex] = false;
                    }
                  }
                  switch (index) {
                    case 0:
                      tip = (widget.total * 0.10).toStringAsFixed(2);
                      break;
                    case 1:
                      tip = (widget.total * 0.15).toStringAsFixed(2);
                      break;
                    case 2:
                      tip = (widget.total * 0.20).toStringAsFixed(2);
                      break;
                    case 3:
                      tip = (widget.total * 0.25).toStringAsFixed(2);
                      break;
                  }
                });
              },
            ),
            SizedBox(height: 5),
            Text("Please select your tip amount above (\$2.00 minimum)", style: kHintTextStyle),
            SizedBox(height: 8),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Payment Method", style: kOrderTextStyle),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(payMethod, style: kOrderTextStyle),
                      SizedBox(width: 12),
                      Icon(FontAwesomeIcons.chevronRight, size: 18)
                    ],
                  )
                ],
              ),
            ),
            Divider(indent: 10, height: 0)
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: primary,
          child: FlatButton(
            padding: EdgeInsets.all(16),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 58),
                Text('Pay Now', style: kPayTextStyle),
                Text('\$${(widget.total + double.parse(tip)).toStringAsFixed(2)}', style: kPayTextStyle)
              ],
            ),
          ),
        ),
      )
    );
  }
}
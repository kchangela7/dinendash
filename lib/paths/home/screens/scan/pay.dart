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
      height: 320,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // Tip Display
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 28, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Waiter Tip", style: kOrderTextStyle),
                  Text("\$$tip", style: kOrderTextStyle)
                ],
              ),
            ),
            // Tip Percent Buttons
            SizedBox(height: 12),
            Container(
              height: 42.5,
              child: ToggleButtons(
                children: <Widget>[
                  Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("10%", textAlign: TextAlign.center)),
                  Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("15%", textAlign: TextAlign.center)),
                  Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("20%", textAlign: TextAlign.center)),
                  Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("Other", textAlign: TextAlign.center, style: kOrderTextStyle))
                ],
                selectedColor: Colors.green[800],
                selectedBorderColor: Colors.green[700],
                textStyle: kCurrencyStyle,
                isSelected: _selections,
                color: Colors.grey[600],
                borderColor: Colors.grey,
                borderRadius: BorderRadius.circular(30),
                borderWidth: 1.3,
                fillColor: Colors.green[50],
                onPressed: (int index) {
                  setState(() {
                    // Allow only one selection at a time
                    for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        _selections[buttonIndex] = true;
                      } else {
                        _selections[buttonIndex] = false;
                      }
                    }

                    // Handle changes to tip percent
                    var total = widget.total;
                    switch (index) {
                      case 0:
                        if (total < 20.0) {
                          tip = "2.00";
                        } else {
                          tip = (total * 0.10).toStringAsFixed(2);
                        }
                        break;
                      case 1:
                        if (total < 13.33) {
                          tip = "2.00";
                        } else {
                          tip = (total * 0.15).toStringAsFixed(2);
                        }
                        break;
                      case 2:
                        if (total < 10.0) {
                          tip = "2.00";
                        } else {
                          tip = (total * 0.20).toStringAsFixed(2);
                        }
                        break;
                      case 3:
                      // Display Other Tip Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure you want to back out?"),
                              content: Text('You will have to scan the QR code again to return'),
                              buttonPadding: EdgeInsets.symmetric(horizontal: 10),
                              actions: [
                                FlatButton(
                                  child: Text('Yes, back out', style: TextStyle(fontSize: 16)),
                                  onPressed: () {
                                    
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
                        );
                        break;
                    }
                  });
                },
              ),
            ),
            // Tip Hint Text
            Container(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
              child: Text("Please select your tip amount above (\$2.00 minimum)", 
                style: kHintTextStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
              )
            ),

            // Pay Method Button
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
            Divider(indent: 20, height: 0)
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: primary,
          child: FlatButton(
            padding: EdgeInsets.all(14),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 60),
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


import 'package:dinendash/paths/home/screens/account/payMethods/payMethods.dart';
import 'package:dinendash/paths/home/screens/scan/orderView/otherTip.dart';
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
  
  // Initial States
  List<bool> _selections = [false, true, false, false];
  String tip = "0.00";
  String payMethod = "Google Pay";
  int prevIndex = 1;
  String finalTotal = "0.00";

  // Initialize tip and total using total from Stream
  @override
  void initState() {
    tip = "\$" + (widget.total * 0.15).toStringAsFixed(2);
    finalTotal = "\$" + (widget.total * 1.15).toStringAsFixed(2);
    super.initState();
  }

  void onTipChange (String newTip) {
    setState(() => {
      if (newTip == "Tip with cash") { // User leaves cash tip
        tip = newTip,
        finalTotal = "\$" + widget.total.toStringAsFixed(2)
      } else {
        if (double.parse(newTip) < 2.0) { // Ensure tip minimum is $2.00
          tip = "\$2.00",
          finalTotal = "\$" + (widget.total + 2.0).toStringAsFixed(2)
        } else {
          tip = "\$" + newTip,
          finalTotal = "\$" + (widget.total + double.parse(newTip)).toStringAsFixed(2)
        }
      }
    });
  }

  // Toggles selected stated of tip percent buttons
  void setSelection ([int index, bool saveOtherIndex = false]) {
    setState(() {
      if (index != null) {
        if (!saveOtherIndex) {
          for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
            if (buttonIndex == index) {
              _selections[buttonIndex] = true;
            } else {
              _selections[buttonIndex] = false;
            }
          }
          if (index != 3) { // Prevents Other selection from being saved as previous
            prevIndex = index;
          }
        } else {
          prevIndex = 3; // Fires when OtherTip is confirmed
        }
      } else {
        setSelection(prevIndex); // Revert back to previous selection
        // Occurs when OtherTip dialog is cancelled
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Tip Display
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 28, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Server Tip", style: kOrderTextStyle),
                    Text(tip, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.1, color: Colors.grey[800]))
                  ],
                ),
              ),

              // Tip Percent Buttons
              SizedBox(height: 12),
              Container(
                height: 40,
                child: ToggleButtons(
                  children: <Widget>[
                    Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("10%", textAlign: TextAlign.center)),
                    Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("15%", textAlign: TextAlign.center)),
                    Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("20%", textAlign: TextAlign.center)),
                    Container(width: (MediaQuery.of(context).size.width - 45)/4, child: Text("Other", textAlign: TextAlign.center, style: kOrderTextStyle))
                  ],
                  selectedColor: Colors.green[600],
                  selectedBorderColor: Colors.green[600],
                  textStyle: kCurrencyStyle,
                  isSelected: _selections,
                  color: Colors.grey[600],
                  borderColor: Colors.grey[350],
                  borderRadius: BorderRadius.circular(30),
                  borderWidth: 1.2,
                  fillColor: Colors.green[50],
                  onPressed: (int index)  async {
                    setSelection(index);

                    // Handle changes to tip percent
                    var total = widget.total;
                    switch (index) {
                      case 0:
                        onTipChange((total * 0.10).toStringAsFixed(2));
                        break;
                      case 1:
                        onTipChange((total * 0.15).toStringAsFixed(2));
                        break;
                      case 2:
                        onTipChange((total * 0.20).toStringAsFixed(2));
                        break;
                      case 3:
                      // Display OtherTip dialog
                        String returnVal = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return OtherTip(onTipChange: onTipChange);
                          }
                        );
                        if (returnVal == "success") { // Sets selection based on pop parameters
                          setSelection(3, true);
                        } else {
                          setSelection();
                        }
                        break;
                    }
                  }
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
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (BuildContext context) => PayMethods())
                  );
                },
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
        ),
        // Bottom Pay Now button
        bottomNavigationBar: BottomAppBar(
          color: primary,
          child: FlatButton(
            padding: EdgeInsets.all(12),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 60),
                Text('Pay Now', style: kPayTextStyle),
                Text(finalTotal, style: kPayTextStyle)
              ],
            ),
          ),
        ),
      )
    );
  }
}
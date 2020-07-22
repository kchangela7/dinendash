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

  void onTipChange (String newTip) {
    setState(() => tip = newTip);
  }

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
                  borderWidth: 1.2,
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
                    });

                    // Handle changes to tip percent
                    var total = widget.total;
                    switch (index) {
                      case 0:
                        if (total < 20.0) {
                          onTipChange("2.00");
                        } else {
                          onTipChange((total * 0.10).toStringAsFixed(2));
                        }
                        break;
                      case 1:
                        if (total < 13.33) {
                          onTipChange("2.00");
                        } else {
                          onTipChange((total * 0.15).toStringAsFixed(2));
                        }
                        break;
                      case 2:
                        setState(() {
                          if (total < 10.0) {
                            onTipChange("2.00");
                          } else {
                            onTipChange((total * 0.20).toStringAsFixed(2));
                          }
                        });
                        break;
                      case 3:
                      // Display Other Tip Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return OtherTip(onTipChange: onTipChange);
                          }
                        );
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

class OtherTip extends StatefulWidget {

  final Function onTipChange;
  OtherTip({ this.onTipChange });

  @override
  _OtherTipState createState() => _OtherTipState();
}

class _OtherTipState extends State<OtherTip> {

  String input = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      title: Text("How much would you like to tip your server?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      content: TextField(
        onChanged: (val) {
          setState(() => input = val);
        },
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none
          ),
          hintText: "6.00",
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[600]),
          fillColor: Colors.grey[350],
          filled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              constraints: BoxConstraints(minWidth: 48, minHeight: 51),
              decoration: ShapeDecoration(
                color: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(8))
                )
              ),
              child: Icon(FontAwesomeIcons.dollarSign, color: Colors.white, size: 18),
            ),
          )
        ),
      ),
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      actions: [
        FlatButton(
          child: Text('Cancel', style: TextStyle(fontSize: 16)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          onPressed: () async {
            widget.onTipChange(double.parse(input).toStringAsFixed(2));
            Navigator.of(context).pop();
          },
          child: Text('Okay', style: TextStyle(fontSize: 16))
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}


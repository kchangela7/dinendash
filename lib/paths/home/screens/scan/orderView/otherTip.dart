// Other Tip Dialog
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtherTip extends StatefulWidget {

  final Function onTipChange;
  OtherTip({ this.onTipChange});

  @override
  _OtherTipState createState() => _OtherTipState();
}

class _OtherTipState extends State<OtherTip> {

  String input = "6.00";
  bool cashTip = false;

  onCashTipChange (bool value) {
    setState(() {
      cashTip = value;
      print(value);
      if (value) {
        input = "Tip with cash";
      } else {
        input = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      title: Text("How much would you like to tip your server?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      titlePadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Tip input field
          TextField(
            onChanged: (val) {
              setState(() => input = val);
            },
            readOnly: cashTip,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none
              ),
              hintText: cashTip ? "Tip with cash" : "6.00",
              hintStyle: TextStyle(
                fontSize: 18, 
                fontWeight: cashTip ? FontWeight.w500 : FontWeight.w700, 
                color: cashTip ? Colors.black : Colors.grey[700]
              ),
              fillColor: Colors.grey[350],
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  constraints: BoxConstraints(minWidth: 48, minHeight: 51),
                  decoration: ShapeDecoration(
                    color: cashTip ? Colors.grey[700] : primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(8))
                    )
                  ),
                  child: Icon(FontAwesomeIcons.dollarSign, color: Colors.white, size: 18),
                ),
              )
            ),
          ),
          // Tip with cash checkbox
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => onCashTipChange(!cashTip),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: cashTip,
                    onChanged: (value) => onCashTipChange(value),
                    activeColor: primary,
                  ),
                  Text("Tip with cash", style: kOrderTextStyle)
                ],
              ),
            ),
          )
        ],
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
          child: Text('Okay', style: TextStyle(fontSize: 16)),
          onPressed: () async {
            if (cashTip) {
              widget.onTipChange("Tip with cash");
            } else {
              widget.onTipChange(double.parse(input).toStringAsFixed(2));
            }
            Navigator.pop(context, "success");
          }
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
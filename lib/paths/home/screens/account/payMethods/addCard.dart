import 'package:awesome_card/awesome_card.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  bool showBack = false;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Card", style: kAppBarHeading),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            SizedBox(
              height: 40,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: "Card Number",
                      hintText: "XXXX XXXX XXXX XXXX",
                      counterText: "",
                      isDense: true
                    ),
                    maxLength: 16,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        cardNumber = value.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ");
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: "Exp. Date",
                      hintText: "MM/YY",
                      counterText: "",
                      isDense: true
                    ),
                    maxLength: 5,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        expiryDate = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: "Card Holder Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      isDense: true
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "CVV",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      counterText: "",
                      isDense: true
                    ),
                    maxLength: 3,
                    maxLengthEnforced: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        cvv = value;
                      });
                    },
                    focusNode: _focusNode,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
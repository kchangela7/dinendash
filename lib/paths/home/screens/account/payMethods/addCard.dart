import 'package:awesome_card/awesome_card.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  // Card states
  String cardNumber = "";
  String cardHolderName = "Your Name";
  String expiryMonth = "MM";
  String expiryYear = "YY";
  String cvv = "";
  bool showBack = false;

  final _formKey = GlobalKey<FormState>();

  // Validity checks
  bool isInvalidYear = false;

  final expiryMMController = TextEditingController();
  final expiryYYController = TextEditingController();

  // Change focus to different fields
  FocusNode _expMMFocusNode = new FocusNode();
  FocusNode _expYYFocusNode = new FocusNode();
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _cvvFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    expiryMMController.addListener(_expiryMonthController);
    expiryYYController.addListener(_expiryYearController);
    _cvvFocusNode.addListener(() {
      setState(() {
        _cvvFocusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _expMMFocusNode.dispose();
    _expYYFocusNode.dispose();
    _nameFocusNode.dispose();
    _cvvFocusNode.dispose();
    expiryMMController.dispose();
    expiryYYController.dispose();
    super.dispose();
  }

  // Automatically move to expiryYY field
  _expiryMonthController() {
    String value = expiryMMController.text;
    if (value != "" && int.parse(value[0]) > 1) {
      expiryMMController.text = '0' + value;
    }
    setState(() {
      expiryMonth = value != "" ? expiryMMController.text : "MM";
    });
    if (value.length == 2) FocusScope.of(context).requestFocus(_expYYFocusNode);
  }

  _expiryYearController() {
    String value = expiryYYController.text;
    int numValue = value != "" ? int.parse(value) : 0;
    int currentYear = new DateTime.now().year % 2000;
    setState(() {
      expiryYear = value != "" ? value : "YY";
      isInvalidYear = numValue >= 10 &&
          (numValue < currentYear || numValue > (currentYear + 15));
    });
    if (value.length == 2 && !isInvalidYear)
      FocusScope.of(context).requestFocus(_nameFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Add Card", style: kAppBarHeading),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 250, 20, 0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),

                    // Card Number
                    TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: "Card Number",
                          isDense: true),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(_expMMFocusNode);
                      },
                      validator: (value) {
                        return value.isEmpty
                            ? 'Please enter a card number'
                            : null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        _CardNumberInputFormatter()
                      ],
                    ),
                    SizedBox(height: 16),

                    // Expiration Fields
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextFormField(
                              // Exp Month
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  hintText: "MM",
                                  isDense: true),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context)
                                    .requestFocus(_expYYFocusNode);
                              },
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Enter expiration month'
                                    : null;
                              },
                              controller: expiryMMController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2)
                              ],
                              focusNode: _expMMFocusNode,
                            ),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: TextFormField(
                              // Exp Year
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  hintText: "YY",
                                  errorText:
                                      isInvalidYear ? "Invalid year" : null,
                                  isDense: true),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context)
                                    .requestFocus(_nameFocusNode);
                              },
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Enter expiration year'
                                    : null;
                              },
                              controller: expiryYYController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2)
                              ],
                              focusNode: _expYYFocusNode,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Card holder name
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          hintText: "Card Holder Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          isDense: true),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(_cvvFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      focusNode: _nameFocusNode,
                    ),
                    SizedBox(height: 16),

                    // CVV field
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "CVV",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          isDense: true),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState.validate()) {
                          print("Attempted to add card!");
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a CVV number';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      focusNode: _cvvFocusNode,
                    ),
                    SizedBox(height: 16),
                    FlatButton(
                      color: primary,
                      child: Center(
                        child: Text("Add Card", style: kPayTextStyle),
                        heightFactor: 2.4,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print("Attempted to add card!");
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),

          // Display Card
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: CreditCard(
                    cardNumber: cardNumber,
                    cardExpiry: expiryMonth + "/" + expiryYear,
                    cardHolderName: cardHolderName,
                    cvv: cvv,
                    showBackSide: showBack,
                    frontBackground: CardBackgrounds.black,
                    backBackground: CardBackgrounds.white,
                    showShadow: true,
                  ),
                ),
              ])
        ],
      ),
    );
  }
}

// Credit Card Input Formatter
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 4) + ' ');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8) + ' ');
      if (newValue.selection.end >= 8) selectionIndex++;
    }
    if (newTextLength >= 13) {
      newText.write(newValue.text.substring(8, usedSubstringIndex = 12) + ' ');
      if (newValue.selection.end >= 12) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

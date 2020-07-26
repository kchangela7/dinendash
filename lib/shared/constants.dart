import 'package:flutter/material.dart';

// Style Sheet Colors
var primary = Colors.greenAccent[700];
// const primary = Color(0xFF012bb23);
var background = Colors.grey[50];

final kHintTextStyle = TextStyle(
  color: Colors.grey[700],
  fontSize: 12,
  fontWeight: FontWeight.w500,
  height: 1.3,
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kOrderTextStyle = TextStyle(
  fontSize: 16, 
  fontWeight: FontWeight.w500,
  letterSpacing: 0.15
);

final kCurrencyStyle = TextStyle(
  fontSize: 16, 
  fontWeight: FontWeight.w700, 
  letterSpacing: 0.1, 
  color: Colors.grey[600]
);

final kCurrencyStyleSmall = TextStyle(
  fontWeight: FontWeight.w500,
  letterSpacing: 0.1,
  color: Colors.grey[600]
);

final kOrderHeaderStyle = TextStyle(
  letterSpacing: 0.15, 
  fontSize: 18, 
  fontWeight: FontWeight.w900
);

final kOrderTextBoldStyle = TextStyle(
  fontSize: 16, 
  fontWeight: FontWeight.w900, 
  letterSpacing: 0.15
);

final kPayTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Colors.grey[50],
  letterSpacing: 0.15
);
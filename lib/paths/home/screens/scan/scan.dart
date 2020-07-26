import 'package:barcode_scan/barcode_scan.dart';
import 'package:dinendash/paths/home/screens/scan/orderView/myOrder.dart';
import 'package:dinendash/services/database.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/shared/loading_utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {

  String scanResult;
  String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DineNDash"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            // Scan Button
            child: RawMaterialButton(
              onPressed: () async {
                // Scan QR Code
                dynamic result = await BarcodeScanner.scan(options: ScanOptions(restrictFormat: [BarcodeFormat.qr]));
                scanResult = result.rawContent; // Data retrieved from scan
                  String tableID = await DatabaseService().qrLookup(scanResult); // Determine Table and Merchant ID
                  if (tableID != null) {
                    Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => MyOrder(tableID: tableID,)));
                  } else {
                    Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(errorSnackBar('An error occured during the scan'));
                  }
              },
              elevation: 2.0,
              fillColor: primary,
              child: Column(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.qrcode,
                    color: background,
                    size: 35.0,
                    semanticLabel: 'Scan',
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Scan',
                    style: TextStyle(color: background, fontWeight: FontWeight.bold, letterSpacing: 1),
                  )
                ],
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}
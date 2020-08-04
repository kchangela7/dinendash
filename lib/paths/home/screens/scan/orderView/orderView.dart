import 'package:dinendash/paths/home/screens/scan/orderView/myOrder.dart';
import 'package:dinendash/paths/home/screens/scan/orderView/pay.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/shared/loading_utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderView extends StatefulWidget {

  
  final String tableID;
  OrderView({ this.tableID });

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {

  Stream<Map<String, dynamic>> _currentOrder = (() async* {
    Map<String, dynamic> data = {
      "order": [{"item": "Burger", "price": 10.55, "quantity": 1}, {"item": "Curry", "price": 12.97, "quantity": 1}, {"item": "Chicken Alfredo", "price": 11.29, "quantity": 1}, {"item": "Large Fries", "price": 5.32, "quantity": 2}, {"item": "Ice Cream", "price": 3.98, "quantity": 3}, {"item": "Chicken Burger", "price": 9.64, "quantity": 1}], 
      "totals": {"subtotal": 40.83, "tax": 1.94, "total": 42.77}
    };
    await Future<void>.delayed(Duration(seconds: 1));
    yield data;
    await Future<void>.delayed(Duration(seconds: 1));
  })();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      initialData: {"order": [], "totals": {"subtotal": 0.0, "tax": 0.0, "total": 0.0}},
      stream: _currentOrder,
      builder: (context, snapshot) {

        var totals = snapshot.data["totals"];
        
        return Scaffold(
          appBar: AppBar(
            title: Text("Marcos Pizza", style: kAppBarHeading),
            leading: IconButton(
              icon: Icon(FontAwesomeIcons.chevronLeft, size: 18),
              onPressed: () async {
                String result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReturnDialog();
                  }
                );
                if (result == "exit") Navigator.pop(context);
              }
            ),
          ),
          // Pay Floating Button
          floatingActionButton: snapshot.connectionState != ConnectionState.done ? null : FloatingActionButton.extended(
            elevation: 4,
            highlightElevation: 8,
            onPressed: () => showModalBottomSheet(
              context: context, 
              builder: (BuildContext context) {
                return Pay(total: totals["total"]);
              }
            ),
            label: Container(
              width: MediaQuery.of(context).size.width - 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 58),
                  Text('Checkout', style: kPayTextStyle),
                  Text('\$${totals["total"].toStringAsFixed(2)}', style: kPayTextStyle)
                ],
              ),
            ),
            backgroundColor: primary,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Stack(
            children: <Widget>[
              MyOrder(data: snapshot.data),
              if (snapshot.connectionState != ConnectionState.done) Loading()
            ],
          )
        );
      }
    );
  }
}


class ReturnDialog extends StatelessWidget {
  const ReturnDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure you want to back out?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      content: Text('You will have to scan the QR code again to return'),
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.green[800]))
        ),
        FlatButton(
          child: Text('Yes, back out', style: TextStyle(fontSize: 16, color: Colors.green[800])),
          onPressed: () {
            Navigator.pop(context, "exit");
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection reference
  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference merchants = Firestore.instance.collection('merchants');

  // Create User Doc
  Future updatePersonalInfo(String firstName, String lastName, String address, String email) async {
    return await users.document(uid).setData({
      'personalInfo': {
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'email': email,
      }
    });
  }

  // QR Code Database lookup
  Future qrLookup(String scanResult) async {
    try {
      int tableNumber = int.parse(scanResult.substring(20,22)) - 1;
      String merchantID = scanResult.substring(0,20);

      DocumentSnapshot doc = await merchants.document(merchantID).collection("qrcodes")
      .document(merchantID).get();

      List<String> tables = List.from(doc.data["tables"]);
      return tables[tableNumber];

    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}
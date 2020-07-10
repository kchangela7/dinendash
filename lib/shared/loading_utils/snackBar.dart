import 'package:flutter/material.dart';

Widget loadingSnackBar(String loading) {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(loading),
        CircularProgressIndicator(),
      ],
    ),
  );
}

Widget errorSnackBar(String error) { 
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(error), Icon(Icons.error)],
    ),
    backgroundColor: Colors.redAccent[700],
  );
}
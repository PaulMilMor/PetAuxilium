import 'package:flutter/material.dart';

class GrayTextField extends StatelessWidget {
  GrayTextField({this.hintText});
  String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(235, 235, 235, 1),
        hintText: this.hintText,
        hintStyle: TextStyle(
          color: Color.fromRGBO(202, 202, 202, 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Color.fromRGBO(235, 235, 235, 1),
          ),
        ),
      ),
    );
  }
}

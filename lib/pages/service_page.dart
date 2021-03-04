import 'package:flutter/material.dart';
class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     String _service = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Text(_service),
    );
  }
}
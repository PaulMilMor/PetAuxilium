import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DoubleStreamBuilder extends StatelessWidget {
  @override
  DoubleStreamBuilder(
      {@required this.stream1, @required this.stream2, @required this.builder});

  final Stream stream1;
  final Stream stream2;
  final Widget Function(BuildContext) builder;

  Widget build(BuildContext context) => StreamBuilder(
      stream: Rx.combineLatest2(
          stream1, stream2, (b1, b2) => b1 != null || b2 != null),
      builder: (context, snapshot) => builder(context));
}
import 'package:flutter/material.dart';

class GrayFlatButton extends StatelessWidget {
  GrayFlatButton({
    this.onPressed,
    this.text,
    this.icon,
  });
  final void Function() onPressed;
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashColor: Color.fromRGBO(49, 232, 93, 1),
      minWidth: 376,
      onPressed: this.onPressed,
      color: Color.fromRGBO(235, 235, 235, 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 8,
              child: Text(
                this.text,
                style: TextStyle(color: Colors.black),
              )),
          Expanded(
            flex: 1,
            child: Icon(
              this.icon,
              color: Color.fromRGBO(202, 202, 202, 1),
            ),
          ),
        ],
      ),
    );
  }
}

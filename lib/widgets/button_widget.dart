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
      height: 40,
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

class GrayDropdownButton extends StatelessWidget {
  GrayDropdownButton({
    this.hint,
    this.value,
    this.onChanged,
    this.items,
  });
  final Widget hint;
  final dynamic value;
  final void Function(dynamic) onChanged;
  final List<DropdownMenuItem<dynamic>> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Color.fromRGBO(235, 235, 235, 1),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: new BoxDecoration(
        color: Color.fromRGBO(235, 235, 235, 1),
        borderRadius: new BorderRadius.all(Radius.circular(10.0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: this.hint,
          value: this.value,
          onChanged: this.onChanged,
          items: this.items,
          underline: null,

          //iconEnabledColor: Colors.green,
        ),
      ),
    );
  }
}

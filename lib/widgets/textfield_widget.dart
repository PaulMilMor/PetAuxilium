import 'package:flutter/material.dart';

class GrayTextFormField extends StatelessWidget {
  GrayTextFormField({
    this.hintText,
    this.obscureText = false,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.enableSuggestions = true,
    this.enableInteractiveSelection = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.focusNode,
  });
  final String hintText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool enableInteractiveSelection;
  final TextEditingController controller;
  final String Function(String) validator;
  final void Function(String) onChanged;
  final void Function() onTap;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: this.keyboardType,
      textCapitalization: this.textCapitalization,
      obscureText: this.obscureText,
      enableSuggestions: this.enableSuggestions,
      autocorrect: this.autocorrect,
      enableInteractiveSelection: this.enableInteractiveSelection,
      controller: this.controller,
      validator: this.validator,
      onChanged: this.onChanged,
      onTap: this.onTap,
      focusNode: this.focusNode,
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

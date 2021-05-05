import 'package:flutter/material.dart';

class GrayTextFormField extends StatelessWidget {
  GrayTextFormField(
      {this.hintText,
      this.obscureText = false,
      this.autocorrect = true,
      this.textCapitalization = TextCapitalization.none,
      this.enableSuggestions = true,
      this.enableInteractiveSelection = true,
      this.keyboardType,
      this.controller,
      this.validator,
      this.onChanged,
      this.onTap,
      this.focusNode,
      this.suffixIcon,
      this.toolbarOptions,
      this.autovalidateMode,
      this.maxLines = 1,
      this.maxLength,
      this.readOnly = false,
      this.prefixIcon,
      this.labelText,
      this.onEditingComplete,
      //FIXME: Vease detail_page
      InputDecoration decoration,
      this.initialvalue,
      this.key});
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
  final Widget suffixIcon;
  final ToolbarOptions toolbarOptions;
  final AutovalidateMode autovalidateMode;
  final int maxLines;
  final int maxLength;
  final bool readOnly;
  final Widget prefixIcon;
  final String labelText;
  final void Function() onEditingComplete;
  final String initialvalue;
  final Key key;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color.fromRGBO(49, 232, 93, 1),
      ),
      child: TextFormField(
        key: this.key,
        onEditingComplete: this.onEditingComplete,
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
        toolbarOptions: this.toolbarOptions,
        autovalidateMode: this.autovalidateMode,
        maxLines: this.maxLines,
        maxLength: this.maxLength,
        readOnly: this.readOnly,
        initialValue: this.initialvalue,
        decoration: InputDecoration(
          errorMaxLines: 3,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          filled: true,
          fillColor: Color.fromRGBO(235, 235, 235, 1),
          hintText: this.hintText,
          hintStyle: TextStyle(
            color: Color.fromRGBO(202, 202, 202, 1),
          ),
          labelText: this.labelText == null ? this.hintText : this.labelText,
          labelStyle: TextStyle(
//          color: Color.fromRGBO(202, 202, 202, 1),
              // color: Color.fromRGBO(49, 232, 93, 1),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Color.fromRGBO(235, 235, 235, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Color.fromRGBO(30, 215, 96, 1),
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Color.fromRGBO(232, 49, 93, 1),
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Color.fromRGBO(232, 49, 93, 1),
              )),
          suffixIcon: this.suffixIcon,
          prefixIcon: this.prefixIcon,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planet/theme.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;

  const FormTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyles.whiteLabelTextStyle,
        ),
        const SizedBox(height: 10,),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: ColorStyles.mainAccent, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

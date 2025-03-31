import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const RoundedTextFormField({
    Key? key,
    this.obscureText = false,
    required this.textEditingController,
    required this.hintText,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300), // Light gray border
      ),
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: InputBorder.none, // Remove default border
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500, // Light gray hint text
          ),
        ),
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

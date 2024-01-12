import 'package:flutter/material.dart';

class MyLoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyLoginTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(6.0, 6.0),
              blurRadius: 0,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white), // user input color
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black87),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black87),
            ),
            fillColor: Colors.grey.shade700,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InputPassword extends StatefulWidget {
  const InputPassword({super.key, required this.controller, required this.labelText});
  final TextEditingController controller;
  final String labelText;

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool _isOff = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isOff,
      decoration: InputDecoration(
        labelText: widget.labelText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor)
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isOff = !_isOff;
            });
          },
          icon: Icon(_isOff ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

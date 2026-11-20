import 'package:flutter/material.dart';

class NumField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? suffix;

  const NumField({
    super.key,
    required this.controller,
    required this.label,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
      ),
    );
  }
}

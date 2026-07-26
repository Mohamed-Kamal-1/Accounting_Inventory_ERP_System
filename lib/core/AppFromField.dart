import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// typedef Validator = String? Function(String? text);
// typedef OnChange = void Function(String? text);
typedef SendProduct = void Function(
  String controllerName,
);

class AppTextField extends StatefulWidget {
  final SendProduct sendProduct;
  final String label;
  final TextInputType keyboardType;

  // final bool? isPassword;
  // final Validator? validator;
  final TextEditingController? controller;

  final TextInputAction? textInputAction;

  const AppTextField({
    required this.label,
    required this.sendProduct,
    this.keyboardType = TextInputType.text,
    // this.validator,
    this.controller,
    super.key,
    this.textInputAction = TextInputAction.next,
    // this.onChange,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool secureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        onChanged: widget.sendProduct,
        style: GoogleFonts.inter(fontSize: 16),
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: GoogleFonts.inter(fontSize: 16),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

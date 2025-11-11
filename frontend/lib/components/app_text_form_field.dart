import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.textInputAction,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.bottomPadding = 20,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical = TextAlignVertical.center,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String hintText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final double? bottomPadding;
  final int? maxLines;
  final bool expands;
  final TextAlignVertical textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding!),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onChanged: onChanged,
          autofocus: autofocus ?? false,
          validator: validator,
          obscureText: obscureText ?? false,
          // obscuringCharacter: '*',
          onEditingComplete: onEditingComplete,
          maxLines: maxLines,
          expands: expands,
          textAlignVertical: textAlignVertical,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFd9d9d9),
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          cursorColor: Colors.black,
          cursorWidth: 0.5,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

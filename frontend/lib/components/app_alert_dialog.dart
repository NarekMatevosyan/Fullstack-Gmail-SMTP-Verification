import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppAlertDialog extends StatefulWidget {
  const AppAlertDialog({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  State<AppAlertDialog> createState() => AlertDialogState();
}

class AlertDialogState extends State<AppAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(widget.description,
          style: GoogleFonts.plusJakartaSans(color: Colors.white)),
      backgroundColor: const Color(0xFF0D0D0D),
    );
  }
}

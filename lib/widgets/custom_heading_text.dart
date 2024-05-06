import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({Key? key, required this.headingText, required this.color})
      : super(key: key);
  final String headingText;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: GoogleFonts.ubuntu(fontSize: 30, color: color),
    );
  }
}

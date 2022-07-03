import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle TxtStyle(
      {required String fontstyle,
      required double fontSize,
      required FontWeight fontWeight,  Color? color}) {
    return GoogleFonts.getFont(fontstyle,
        textStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight,
            color: color)
    );
  }
}

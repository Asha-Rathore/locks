import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final Color fontColor;
  final TextAlign textAlign;
  final FontWeight fontweight;
  final bool underlined, lineThrough;
  final String? fontFamily;
  final double? fontSize;
  final double lineSpacing, letterSpacing;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;

  const CustomText({
    this.text,
    this.fontColor = AppColors.THEME_COLOR_WHITE,
    this.fontSize,
    this.textAlign = TextAlign.center,
    this.fontweight = FontWeight.normal,
    this.underlined = false,
    this.lineSpacing = 1,
    this.fontFamily,
    this.letterSpacing = 0,
    this.maxLines,
    this.textOverflow,
    this.lineThrough = false,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: TextStyle(
        color: fontColor,
        fontWeight: fontweight,
        height: lineSpacing,
        letterSpacing: letterSpacing,
        fontSize: fontSize ?? 15.sp,
        fontFamily: fontFamily,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: underlined
            ? TextDecoration.underline
            : (lineThrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}

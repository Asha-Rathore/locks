import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';

class CustomLocationSeasonRichWidget extends StatelessWidget {
  String? title, text;

  CustomLocationSeasonRichWidget({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title ?? "",
        style: TextStyle(
          color: AppColors.THEME_COLOR_WHITE,
          fontFamily: AppFonts.Poppins_SemiBold,
          fontSize: 13.0.sp,
        ),
        children:  <TextSpan>[
          TextSpan(text: text ?? "", style: TextStyle(fontFamily: AppFonts.Poppins_Medium)),
        ],
      ),
    );
  }
}

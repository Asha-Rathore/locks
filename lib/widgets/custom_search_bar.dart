import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_textfield.dart';

import '../utils/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hintText;
  final double? fontSize;
  final Function(String)? onchange;
  TextEditingController? controller;

  CustomSearchBar(
      {this.hintText, this.fontSize, this.controller, this.onchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.THEME_COLOR_WHITE.withOpacity(0.16),
            offset: Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomTextField(
        hint: hintText ?? AppStrings.SEARCH_NEWS_HERE,
        color: AppColors.THEME_COLOR_DARK_GREEN,
        textStyle: _textStyle(),
        prefxicon: AssetPath.SEARCH_ICON,
        borderColor: AppColors.THEME_COLOR_DARK_GREEN,
        onchange: onchange,
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: AppColors.THEME_COLOR_WHITE.withOpacity(0.14),
      fontFamily: AppFonts.Poppins_Medium,
      fontStyle: FontStyle.italic,
      fontSize: fontSize ?? 16.sp,
    );
  }
}

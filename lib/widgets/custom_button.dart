import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_padding.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? fontSize, width, verticalPadding;
  final Color? textColor;
  final Color? backgroundColor;
  String? fontFamily;
  void Function()? onTap;
  double? borderCircular;
  CustomButton(
      {required this.onTap,
      required this.text,
      this.verticalPadding,
      this.backgroundColor,
      this.width,
      this.fontSize,
      this.textColor,
      this.borderCircular,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.all(
            Radius.circular(borderCircular ?? 10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? AppPadding.BUTTON_VERTICAL_PADDING.h,
              horizontal: AppPadding.DEFAULT_BUTTON_HORIZONTAL_PADDING.w),
          child: CustomText(
            text: text,
            fontColor: textColor ?? AppColors.THEME_COLOR_WHITE,
            fontSize: fontSize ?? 18.sp,
            fontFamily: fontFamily ?? AppFonts.Poppins_SemiBold,
          ),
        ),
      ),
    );
  }
}

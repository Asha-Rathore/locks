import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';

import '../../utils/app_padding.dart';

class CustomSocialLoginButton extends StatelessWidget {
  final Function()? onTap;
  final String? title, iconPath;
  final double? fontSize, iconScale, horizontalPadding;
  final Color? backgroundColor, fontColor;
  const CustomSocialLoginButton({
    super.key,
    this.onTap,
    this.title,
    this.iconPath,
    this.fontSize,
    this.iconScale,
    this.horizontalPadding,
    this.backgroundColor,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          //  border: Border.all(color: AppColors.THEME_COLOR_WHITE, width: 1.5)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppPadding.BUTTON_VERTICAL_PADDING, horizontal: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                iconPath!,
                scale: iconScale,
                color: fontColor,
              ),
              SizedBox(width: 10.w),
              Text(
                title!,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                  fontFamily: AppFonts.Poppins_Medium,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

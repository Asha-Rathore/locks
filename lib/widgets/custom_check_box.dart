import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'custom_text.dart';

class CustomCheckBox extends StatelessWidget {
  bool? value;
  Function(bool?)? onchange;
  String? text;
  CustomCheckBox({
    super.key,
    this.onchange,
    this.text,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: Row(
        children: [
          SizedBox(
            width: 17.w,
            height: 14.h,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.THEME_COLOR_DARK_GREEN,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.THEME_COLOR_WHITE.withOpacity(0.16),
                    offset: const Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                value: value,
                onChanged: onchange,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: text,
            fontColor: AppColors.THEME_COLOR_WHITE,
            fontFamily: AppFonts.Poppins_SemiBold,
            fontSize: 14.sp,
          )
        ],
      ),
    );
  }
}

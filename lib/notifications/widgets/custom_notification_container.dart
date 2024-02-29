import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/widgets/custom_circular_profile.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

import '../../utils/app_colors.dart';

class CustomNotificationContainer extends StatelessWidget {
  final bool? shimmerEnable;
  final String? image, title, description, time;

  const CustomNotificationContainer(
      {this.shimmerEnable,
      this.image,
      this.title,
      this.description,
      this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_DARK_GREEN,
            borderRadius: BorderRadius.circular(10.r),
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
          child: shimmerEnable == false
              ? _mainNotificationWidget()
              : CustomShimmerWidget(child: _mainNotificationWidget()),
        ),
      ),
    );
  }

  Widget _mainNotificationWidget() {
    return Padding(
        padding:
            EdgeInsets.only(top: 12.h, bottom: 12.h, left: 16.w, right: 12.00),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleAndTime(),
            SizedBox(height: 3.h),
            _description(),
          ],
        ));
  }

  Widget _titleAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _title(),
        Padding(padding: EdgeInsets.only(top: 5.h, left: 10.w), child: _time()),
      ],
    );
  }

  Widget _title() {
    return Flexible(
      child: Container(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        child: CustomText(
          text: title,
          fontColor: AppColors.THEME_COLOR_WHITE,
          fontFamily: AppFonts.Poppins_Medium,
          fontSize: 14.sp,
          textAlign: TextAlign.left,
          lineSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _time() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: CustomText(
        text: time,
        fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 11.sp,
      ),
    );
  }

  Widget _description() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: CustomText(
        text: description,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Roboto_Regular,
        fontSize: 12.sp,
        textAlign: TextAlign.left,
        lineSpacing: 1.4,
      ),
    );
  }
}

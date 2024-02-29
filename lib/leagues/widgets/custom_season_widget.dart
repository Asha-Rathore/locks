import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/widgets/custom_season_event_circular_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_circular_profile.dart';
import '../../widgets/custom_text.dart';

class CustomSeasonWidget extends StatelessWidget {
  final bool? shimmerEnable;
  final String? imagePath, seasonText;
  final Function()? onTap;
  final int? index;

  const CustomSeasonWidget({
    this.shimmerEnable,
    this.imagePath,
    this.seasonText,
    this.onTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64.h,
        width: 105.w,
        child: Padding(
          padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
          child: shimmerEnable == false
              ? _seasonMainWidget()
              : CustomShimmerWidget(
                  child: _seasonMainWidget(),
                ),
        ),
      ),
    );
  }

  Widget _seasonMainWidget() {
    return Stack(
      children: [
        Align(alignment: Alignment.bottomCenter, child: _backContainer()),
        Align(alignment: Alignment.topCenter, child: _teamLogo()),
      ],
    );
  }

  Widget _teamLogo() {
    return CustomSeasonEventCircularImageWidget(
      image: imagePath,
      height: 36.h,
      width: 36.h,
    );
  }

  Widget _backContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        height: 45.h,
        width: 105.w,
        decoration: BoxDecoration(
          color: AppColors.THEME_COLOR_LIGHT_GREEN,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 28.h, left: 3.w, right: 3.w),
          child: CustomText(
            text: seasonText,
            fontColor: AppColors.THEME_COLOR_DARK_GREEN,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            fontSize: 11.0.sp,
            fontFamily: AppFonts.Poppins_Medium,
          ),
        ),
      ),
    );
  }
}

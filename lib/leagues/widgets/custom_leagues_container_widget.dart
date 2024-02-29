import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomLeaguesContainerWidget extends StatelessWidget {
  final String? image, title;
  final bool? shimmerEnable;
  final VoidCallback? onTap;

  const CustomLeaguesContainerWidget(
      {this.image, this.title, this.shimmerEnable, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_DARK_GREEN,
            borderRadius: BorderRadius.circular(10.r),
            border:
                Border.all(color: AppColors.THEME_COLOR_TRANSPARENT, width: 0),
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
              ? _leagueMainWidget()
              : CustomShimmerWidget(
                  child: _leagueMainWidget(),
                )),
    );
  }

  Widget _leagueMainWidget() {
    return Column(
      children: [
        // Expanded(child: Container(child: _imageWidget())),
        Expanded(child: _imageWidget()),
        SizedBox(height: 9.h),
        _titleWidget(),
        SizedBox(height: 8.h),
        // SizedBox(height: 10.h),
      ],
    );
  }

  Widget _imageWidget() {
    return Container(
      width: 1.sw,
      //color: AppColors.THEME_COLOR_WHITE,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        child: CustomExtendedImageWidget(
          imagePath: image,
          imageType: MediaPathType.network.name,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      height: shimmerEnable == false ? 32.h : 16.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: CustomText(
        text: title,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 12.sp,
        maxLines: 2,
        lineSpacing: 1.4,
      ),
    );
  }
}

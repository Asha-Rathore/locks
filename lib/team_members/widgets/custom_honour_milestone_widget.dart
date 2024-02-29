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

class CustomHonourMilestoneWidget extends StatelessWidget {
  final String? image, imageType;
  final String? honourMilestoneName, teamName, year;
  final bool? shimmerEnable;
  final VoidCallback? onTap;

  const CustomHonourMilestoneWidget(
      {this.image,
      this.imageType,
      this.honourMilestoneName,
      this.teamName,
      this.year,
      this.shimmerEnable,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 0.43.sw,
          margin: EdgeInsets.only(bottom: 10.0.h, left: 5.w, right: 5.w),
          height: 0.22.sh,
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
              ? _mainWidget()
              : CustomShimmerWidget(
                  child: _mainWidget(),
                )),
    );
  }

  Widget _mainWidget() {
    return Column(
      children: [
        Expanded(child: _imageWidget()),
        SizedBox(height: 10.h),
        _textWidget(),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _imageWidget() {
    return Container(
      width: 0.43.sw,
      decoration: BoxDecoration(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        child: CustomExtendedImageWidget(
          imagePath: image,
          imageType: imageType ?? MediaPathType.network.name,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          placeholderColor: AppColors.THEME_COLOR_DARK_GREEN,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _textWidget() {
    return Column(
      children: [
        _customTextWidget(
          text: honourMilestoneName,
        ),
        SizedBox(height: 6.h),
        _customTextWidget(
          text: shimmerEnable == false ? "(${year})" : year,
        ),
        SizedBox(height: 6.h),
        _customTextWidget(
          text: teamName,
        ),
      ],
    );
  }

  Widget _customTextWidget({String? text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      child: Container(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        child: CustomText(
          text: text,
          fontColor: AppColors.THEME_COLOR_WHITE,
          fontFamily: AppFonts.Poppins_Medium,
          fontSize: 12.sp,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

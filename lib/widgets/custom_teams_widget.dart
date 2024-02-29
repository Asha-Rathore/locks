import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomTeamsContainer extends StatelessWidget {
  final bool? shimmerEnable;
  final String? imagePath, title;
  final BoxFit? imageBoxFit;
  final VoidCallback? onTap;

  const CustomTeamsContainer(
      {this.shimmerEnable,
      this.imagePath,
      this.title,
      this.imageBoxFit,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_DARK_GREEN,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: shimmerEnable == false
              ? _teamsMainWidget()
              : CustomShimmerWidget(
                  child: _teamsMainWidget(),
                )),
    );
  }

  Widget _teamsMainWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Expanded(child: _imageWidget()),
          SizedBox(height: 10.h),
          _titleWidget(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      width: 1.sw,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CustomExtendedImageWidget(
          imagePath: imagePath,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          imageType: MediaPathType.network.name,
          placeholderColor: AppColors.THEME_COLOR_DARK_GREEN,
          fit: imageBoxFit,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: CustomText(
        text: title,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 13.sp,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
    );
  }
}

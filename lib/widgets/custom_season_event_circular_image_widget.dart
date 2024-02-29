import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';

import '../utils/app_colors.dart';
import '../utils/asset_paths.dart';

class CustomSeasonEventCircularImageWidget extends StatelessWidget {
  final String? image;
  final double? height, width;

  CustomSeasonEventCircularImageWidget({
    this.image,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 38.h,
      height: height ?? 38.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.THEME_COLOR_WHITE,
        border: Border.all(
          width: 1,
          color: AppColors.THEME_COLOR_LIGHT_GREEN,
        ),
      ),
      child: Center(
        child: Container(
          width: (width ?? 40.h) - 7.h,
          height: (height ?? 40.h) - 7.h,
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_WHITE,
            shape: BoxShape.circle
          ),
          child: ClipOval(
            child: CustomExtendedImageWidget(
                imagePath: image,
                imageType: MediaPathType.network.name,
                imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
                fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';

import '../utils/app_colors.dart';
import '../utils/asset_paths.dart';

class CustomCircularImageWidget extends StatelessWidget {
  final String? image;
  final double? height, width, borderWidth;
  final Color? borderColor;

  CustomCircularImageWidget({
    Key? key,
    this.image,
    this.width,
    this.borderColor,
    this.height,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50.h,
      height: height ?? 50.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: borderWidth ?? 4,
          color: borderColor ?? AppColors.THEME_COLOR_LIGHT_GREEN,
        ),
      ),
      child: ClipOval(
        child: CustomExtendedImageWidget(
            imagePath: image,
            imageType: MediaPathType.network.name,
            imagePlaceholder: AssetPath.USER_PLACEHOLDER_IMAGE),
      ),
    );
  }
}

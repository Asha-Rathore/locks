import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';

class CustomProfileImage extends StatelessWidget {
  final String? imagePath, imageType, icon;
  final Function()? onTap;
  final double? height;

  const CustomProfileImage(
      {this.onTap, this.imagePath, this.imageType, this.icon, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: 120.h,
      child: Stack(
        children: [
          _imageWidget(),
          _addIcon(),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      height: 120.h,
      width: 120.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.THEME_COLOR_LIGHT_GREEN)),
      child: ClipOval(
        child: CustomExtendedImageWidget(
          imagePath: imagePath,
          imageType: imageType,
          imagePlaceholder: AssetPath.USER_PLACEHOLDER_IMAGE,
        ),
      ),
    );
  }


  Widget _addIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h,right: 10.w),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.THEME_COLOR_LIGHT_GREEN,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.THEME_COLOR_WHITE),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                icon ?? AssetPath.ADD_ICON,
                height: height ?? 11.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

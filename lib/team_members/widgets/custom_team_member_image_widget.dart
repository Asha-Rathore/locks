import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomTeamMemberImageWidget extends StatelessWidget {
  final String? imagePath, number;
  final VoidCallback? onTap;

  const CustomTeamMemberImageWidget(
      {this.imagePath = null, this.number, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92.h,
        width: 92.h,
        child: Stack(
          children: [
            _imageWidget(),
            number?.checkNullEmptyText == true
                ? Align(alignment: Alignment.bottomRight, child: _addIcon())
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
        height: 90.h,
        width: 90.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColors.THEME_COLOR_LIGHT_GREEN, width: 2)),
        child: ClipOval(
          child: CustomExtendedImageWidget(
            imagePath: imagePath,
            imageType: MediaPathType.network.name,
            imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _addIcon() {
    return Container(
      width: 28.h,
      height: 28.h,
      margin: EdgeInsets.only(bottom: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.THEME_COLOR_LIGHT_GREEN,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.THEME_COLOR_DARK_GREEN),
      ),
      child: Center(
        child: CustomText(
          text: "#${number}",
          fontColor: AppColors.THEME_COLOR_DARK_GREEN,
          fontFamily: AppFonts.Poppins_Bold,
          fontSize: 11.0.sp,
          lineSpacing: 0,
        ),
      ),
    );
  }
}

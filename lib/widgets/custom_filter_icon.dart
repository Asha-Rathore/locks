import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/utils.dart';

import '../utils/app_colors.dart';

class CustomFilterIcon extends StatelessWidget {
  final Color? backgroundColor, iconColor;
  final double? scale, height, width;
  final Function()? onTap;
  const CustomFilterIcon(
      {super.key,
      this.backgroundColor,
      this.iconColor,
      this.scale,
      this.height,
      this.width,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 47.h,
        width: width ?? 57.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.THEME_COLOR_DARK_GREEN,
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
        child: _icon(),
      ),
    );
  }

  Widget _icon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        AssetPath.FILTER_ICON,
        scale: scale ?? 3,
        color: iconColor,
      ),
    );
  }
}

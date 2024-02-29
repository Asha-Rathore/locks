import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_size.dart';
import '../../utils/asset_paths.dart';

class ViewFullImageScreen extends StatelessWidget {
  final String? imagePath,placeholderImagePath;
  final String? mediaPathType;
  const ViewFullImageScreen(
      {this.imagePath, this.placeholderImagePath,this.mediaPathType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.THEME_COLOR_BLACK,
      appBar: AppBar(
        backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
        leading: InkWell(
            onTap: () {
              AppNavigation.navigatorPop(context);
            },
            child: Container(
              height: 100,
              child: Image.asset(
                AssetPath.BACK_ICON,
                scale: 4.sp,
                color: AppColors.THEME_COLOR_WHITE,
              ),
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomExtendedImageWidget(
              imagePath: imagePath,
              imageType: mediaPathType ?? MediaPathType.network.name,
              imagePlaceholder: placeholderImagePath ?? AssetPath.FEED_PLACEHOLDER_IMAGE,
              fit: BoxFit.contain,
            )
          ),
        ],
      ),
    );
  }
}

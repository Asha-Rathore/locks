import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';

class CustomImageWidget extends StatelessWidget {
  final String? image;
  final double? borderRadius;
  final BoxFit? fit;
  const CustomImageWidget({super.key, this.image, this.borderRadius, this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
        color: AppColors.PRIMARY_COLOR,
      ),
      child: Image.asset(
        image!,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

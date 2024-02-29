import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_size.dart';

class CustomScrollContainer extends StatelessWidget {
  final Widget? child;
  const CustomScrollContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.FULL_SCREEN_WIDTH.w,
      height: 0.6.sh,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child!,
    );
  }
}

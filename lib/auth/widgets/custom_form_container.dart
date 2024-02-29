import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_size.dart';

class CustomFormContainerWidget extends StatelessWidget {
  final Widget? child;
  const CustomFormContainerWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.FULL_SCREEN_WIDTH.w,
      height: AppSize.FORM_AREA_HEIGHT,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.LIGHT_PRIMARY_COLOR.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child!,
    );
  }
}

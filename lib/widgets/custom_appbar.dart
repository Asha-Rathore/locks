import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? leading;
  final Color? backgroundColor, leadingColor;
  final Function()? onclickLead;
  final bool showAction;
  final Widget? actionWidget;
  final double? leadingIconScale, titleFontSize;
  final Function()? onclickAction;
  final bool? isDivider;
  CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actionWidget,
    this.showAction = false,
    this.onclickAction,
    this.onclickLead,
    this.leadingColor,
    this.backgroundColor,
    this.leadingIconScale,
    this.titleFontSize,
    this.isDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: 70.h,
      backgroundColor: backgroundColor ?? AppColors.THEME_COLOR_TRANSPARENT,
      elevation: 0.0,
      title: Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Text(
          title ?? "",
          style: _textStyle(),
        ),
      ),
      centerTitle: true,
      leading: leading != null ? _leadingIcon() : const SizedBox(),
      actions: showAction ? [_actionIcon()] : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _leadingIcon() {
    return Padding(
      padding: EdgeInsets.only(
        // bottom: 2.h,
        left: 12.w,
      ),
      child: GestureDetector(
        onTap: onclickLead,
        child: Image.asset(
          leading!,
          scale: leadingIconScale ?? 4.sp,
          color: leadingColor,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _actionIcon() {
    return GestureDetector(
      onTap: onclickAction,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h, right: 12.w),
        child: actionWidget,
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: AppColors.THEME_COLOR_WHITE,
      fontSize: titleFontSize ?? 20.sp,
      // fontWeight: FontWeight.w800,
      fontFamily: AppFonts.Poppins_SemiBold,
    );
  }
}

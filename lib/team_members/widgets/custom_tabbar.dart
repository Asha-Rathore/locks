import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_text.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final String firstTabText, secTabText;
  const CustomTabBar({
    Key? key,
    required this.tabController,
    required this.firstTabText,
    required this.secTabText,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  Color _firstTextcolor = AppColors.THEME_COLOR_LIGHT_GREEN;
  Color _secTextcolor = AppColors.THEME_COLOR_WHITE;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _divider(),
        _tabBar(),
        // _divider(),
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      onTap: (data) {
        if (data == 0) {
          setState(() {
            _firstTextcolor = AppColors.THEME_COLOR_LIGHT_GREEN;
            _secTextcolor = AppColors.THEME_COLOR_WHITE;
          });
        } else if (data == 1) {
          setState(() {
            _firstTextcolor = AppColors.THEME_COLOR_WHITE;
            _secTextcolor = AppColors.THEME_COLOR_LIGHT_GREEN;
          });
        }
      },
      controller: widget.tabController,
      labelColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      unselectedLabelColor: AppColors.THEME_COLOR_WHITE,
      indicatorColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 60.w),
      indicatorWeight: 4,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(
          child: _customTabs(
            text: widget.firstTabText,
            textAlign: TextAlign.right,
            color: _firstTextcolor,
          ),
        ),
        Tab(
          child: _customTabs(
            text: widget.secTabText,
            textAlign: TextAlign.left,
            color: _secTextcolor,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Positioned(
      top: 1.h,
      child: CustomPadding(
        child: const Divider(
          color: AppColors.THEME_COLOR_DARK_GREEN,
          thickness: 1,
        ),
      ),
    );
  }

  Widget _customTabs({text, textAlign, color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: text,
          textOverflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          fontSize: 16.sp,
          fontweight: FontWeight.bold,
          fontColor: color,
          fontFamily: AppFonts.Poppins_SemiBold,
        ),
      ],
    );
  }
}

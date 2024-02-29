import 'package:flutter/material.dart';
import 'package:locks_hybrid/utils/app_colors.dart';

class CustomRefreshIndicatorWidget extends StatelessWidget {
  final Widget child;
  final  Future Function() onRefresh;

  CustomRefreshIndicatorWidget({
    required this.child,
    required this.onRefresh
});


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: AppColors.THEME_COLOR_LIGHT_GREEN,
        child: child,
        onRefresh: onRefresh);
  }
}

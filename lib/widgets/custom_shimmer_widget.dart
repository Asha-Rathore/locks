import 'package:flutter/material.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends StatelessWidget {
  final Color? shimmerBaseColor, shimmerHighlightColor;
  final bool? shimmerHighlightColorEnable;
  final Widget child;

  CustomShimmerWidget(
      {this.shimmerBaseColor,
      this.shimmerHighlightColor,
      this.shimmerHighlightColorEnable,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        highlightColor:
            shimmerHighlightColor ?? AppColors.SHIMMER_HIGHLIGHT_COLOR,
        baseColor: shimmerBaseColor ?? AppColors.SHIMMER_BASE_COLOR,
        enabled: shimmerHighlightColorEnable ?? true,
        child: child);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_padding.dart';

class CustomPadding extends StatelessWidget {
  final Widget? child;
  final double? padding;
  const CustomPadding({Key? key, this.child, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding ?? AppPadding.DEFAULT_HORIZONTAL_PADDING.w,
      ),
      child: child,
    );
  }
}

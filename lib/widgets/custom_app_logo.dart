import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/asset_paths.dart';

class CustomLogo extends StatelessWidget {
  void Function()? onTap;
  double? height, width;
  CustomLogo({Key? key, this.onTap, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        AssetPath.APP_ICON,
        height: height ?? 180.w,
        width: width ?? 290.w,
      ),
    );
  }
}

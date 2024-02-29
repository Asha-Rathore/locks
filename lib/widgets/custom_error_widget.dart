import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorImagePath, errorText;
  final double? imageSize;
  final Color? imageColor;

  CustomErrorWidget(
      {this.errorImagePath, this.errorText, this.imageSize, this.imageColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          errorImagePath != null
              ? Image.asset(
                  errorImagePath!,
                  width: imageSize ?? 70.h,
                  color: imageColor,
                )
              : Container(),
          SizedBox(
            height: 12.0,
          ),
          CustomText(
            text: errorText,
            fontSize: 16.sp,
            maxLines: 2,
            textAlign: TextAlign.center,
            textOverflow: TextOverflow.ellipsis,
            //fontweight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

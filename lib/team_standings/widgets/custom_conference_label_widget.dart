import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomConferenceLabelWidget extends StatelessWidget {
  final double? containerWidth;
  final String? labelName;
  final int? conferenceSelectedId,conferenceId;
final VoidCallback? onTap;


  CustomConferenceLabelWidget({
    this.containerWidth,
    this.labelName,
    this.conferenceSelectedId,
    this.conferenceId,
    this.onTap
});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: containerWidth,
        //color: Colors.red,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: labelName,
              fontSize: 17.5.sp,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 10.0,),

            Visibility(
              visible: conferenceId == conferenceSelectedId ? true : false,
              child: Container(
                height: 1.5.h,
                width: (containerWidth ?? 0) / 1.2,
                color: AppColors.THEME_COLOR_LIGHT_GREEN,
              ),
            )

          ],
        ),
      ),
    );
  }
}

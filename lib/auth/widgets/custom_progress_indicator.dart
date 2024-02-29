import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';

class CustomProgressIndicator extends StatelessWidget {
  final CountDownController? countDownController;
  final VoidCallback? onComplete;
  CustomProgressIndicator(
      {Key? key, this.countDownController,this.onComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: AppColors.PRIMARY_COLOR),
      child: CircularCountDownTimer(
        duration: 59,
        initialDuration: 0,
        controller: countDownController,
        width: 100.w,
        height: 100.h,
        ringColor: AppColors.PRIMARY_COLOR,
        fillColor: AppColors.THEME_COLOR_WHITE,
        strokeWidth: 2.0,
        backgroundColor: AppColors.PRIMARY_COLOR,
        textStyle: TextStyle(
            color: AppColors.THEME_COLOR_WHITE,
            fontSize: 18.sp,
            fontFamily: AppFonts.Poppins_SemiBold),
        textFormat: CountdownTextFormat.MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          debugPrint('Countdown Started');
        },
        onComplete: onComplete,
      ),
    );
  }
}

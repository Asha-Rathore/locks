import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_text.dart';

class CustomProgressBar extends StatefulWidget {
  double? sliderValue;
  final Color? textColor;
  CustomProgressBar({Key? key, this.sliderValue = 5, this.textColor})
      : super(key: key);

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  @override
  Widget build(BuildContext context) {
    // return Slider(
    //   min: 0.0,
    //   max: 100.0,
    //   value: _value,
    //   divisions: 10,
    //   label: '${_value.round()}',
    //   onChanged: (value) {
    //     setState(() {
    //       _value = value;
    //     });
    //   },
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          text: widget.sliderValue != null
              ? '${widget.sliderValue!.round()}%'
              : '${0}%',
          fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
          fontFamily: AppFonts.Poppins_Medium,
          fontSize: 14.sp,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5.h),
        Container(
          height: 14.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.THEME_COLOR_DARK_GREEN),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6.h,
                trackShape: CustomTrackShape(),
                valueIndicatorTextStyle: TextStyle(
                  color: AppColors.THEME_COLOR_LIGHT_GREEN,
                  fontFamily: AppFonts.Poppins_Medium,
                  fontSize: 14.sp,
                ),
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorColor: AppColors.THEME_COLOR_TRANSPARENT,
                activeTickMarkColor: (Colors.blue),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 5.r,
                ),
                thumbColor: AppColors.THEME_COLOR_LIGHT_GREEN,
              ),
              child: Slider(
                value: widget.sliderValue ?? 0,
                max: 100,
                min: 0,
                autofocus: false,
                divisions: 100,
                // label: '${_value.round()}%',
                activeColor: AppColors.THEME_COLOR_LIGHT_GREEN,
                inactiveColor: AppColors.THEME_COLOR_DARK_GREEN,
                onChanged: (value) {
                  // setState(() {
                  //   widget.sliderValue = value;
                  //   _value = value;
                  //   widget.sliderValue = value;
                  // });
                },
                
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

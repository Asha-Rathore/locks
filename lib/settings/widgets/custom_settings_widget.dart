import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';

import '../../../utils/app_strings.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_text.dart';

class SettingsWidget extends StatefulWidget {
  bool? isSwitch;
  bool switchEnable;
  String? text;
  Function()? onTap;
  Function(bool)? onSwitchChanged;

  SettingsWidget(
      {Key? key,
      this.isSwitch = false,
      this.switchEnable = false,
      this.text,
      this.onTap,
      this.onSwitchChanged});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.THEME_COLOR_DARK_GREEN,
          border:
              Border.all(color: AppColors.THEME_COLOR_WHITE.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.isSwitch! ? 9.h : 18.h,
            horizontal: 15.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _text(),
              widget.isSwitch! ? _switch() : _arrowWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text() {
    return CustomText(
      text: widget.text,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontSize: 16.sp,
      fontFamily: AppFonts.Poppins_SemiBold,
    );
  }

  Widget _switch() {
    return Transform.scale(
      scale: 0.7,
      child: CupertinoSwitch(
        activeColor: widget.switchEnable ? AppColors.PRIMARY_COLOR : Colors.grey,
        thumbColor: widget.switchEnable
            ? AppColors.THEME_COLOR_LIGHT_GREEN
            : AppColors.THEME_COLOR_WHITE,
        value: widget.switchEnable,
        onChanged: widget.onSwitchChanged,
      ),
    );
  }

  Widget _arrowWidget() {
    return Image.asset(
      AssetPath.FORWARD_ARROW_ICON,
      scale: 4,
    );
  }
}

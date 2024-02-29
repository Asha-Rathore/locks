import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

class PhoneNumberTextField extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor, color;
  String? hintText;
  String? label;
  final ValueChanged<PhoneNumber>? onChanged;
  final bool? isBorder, isReadOnly;
  final TextEditingController? controller;
  final Future<String?> Function(PhoneNumber?)? validator;
  // final String? Function(String?)? validator;
  final FocusNode _focusNode = FocusNode();
  PhoneNumberTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.backgroundColor,
      this.borderColor,
      this.isBorder,
      this.hintText,
      this.label,
      this.isReadOnly = false,
      this.onChanged,
      this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      borderColor: borderColor ?? AppColors.THEME_COLOR_WHITE,
      showDropdownIcon: true,
      dropdownIconPosition: IconPosition.trailing,
      dropdownIcon: _dropDownIcon(),
      invalidNumberMessage: AppStrings.NUMBER_INVALID_ERROR,
      validator: validator,
      style: _textStyle(),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      dropdownTextStyle: _textStyle(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        // fillColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
        fillColor: color ?? AppColors.PRIMARY_COLOR.withOpacity(0.6),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
        hintText: hintText,
        counter: const SizedBox.shrink(),
        hintStyle: _textStyle(),
        errorMaxLines: 3,
        border: _outLineInputBorder(),
        focusedBorder: _outLineInputBorder(),
        enabledBorder: _outLineInputBorder(),
        errorBorder: _outLineInputBorder(),
        focusedErrorBorder: _outLineInputBorder(),
        disabledBorder: _outLineInputBorder(),
      ),
      onChanged: onChanged,
      onCountryChanged: (country) {
        print('Country changed to: ' + country.name);
      },
    );
  }

  Icon _dropDownIcon() {
    return Icon(
      Icons.expand_more_rounded,
      color: AppColors.THEME_COLOR_WHITE,
      size: 25.sp,
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(
        // width: 5,
        color: borderColor ?? AppColors.THEME_COLOR_WHITE,
        style: BorderStyle.solid,
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 16.sp,
      color: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Regular,
    );
  }
}

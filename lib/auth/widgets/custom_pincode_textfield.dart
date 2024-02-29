import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';

class CustomPinCodeTextField extends StatelessWidget {
  TextEditingController? controller;
  Function(String)? onComplete;
  CustomPinCodeTextField({this.controller, this.onComplete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: _textStyle(),
      length: 6,
      obscureText: false,
      obscuringCharacter: '*',
      animationType: AnimationType.fade,
      pinTheme: _pinTheme(),
      cursorColor: AppColors.THEME_COLOR_WHITE,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: _textStyle(),
      enableActiveFill: true,
      controller: controller,
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: false),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      scrollPadding: EdgeInsets.zero,
      onCompleted: onComplete,
      onChanged: (value) {
        print(value);
      },
      beforeTextPaste: (text) {
        if (text != null && !containsOnlyNumbers(text)) {
          // If the copied text contains non-numeric characters, prevent pasting.
          // AppDialogs.showToast(message: "OTP is invalid.");
          return false;
        }
        return true;
      },
    );
  }

  bool containsOnlyNumbers(String text) {
    final isNumber = RegExp(r'^[0-9]+$');
    return isNumber.hasMatch(text);
  }

  PinTheme _pinTheme() {
    return PinTheme(
      shape: PinCodeFieldShape.box,
      activeColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      activeFillColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      inactiveFillColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      inactiveColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      selectedFillColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      selectedColor: AppColors.PRIMARY_COLOR.withOpacity(0.4),
      borderRadius: BorderRadius.circular(5.r),
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.PRIMARY_COLOR,
        style: BorderStyle.none,
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 18.sp,
      height: 1.4,
      fontFamily: AppFonts.Poppins_SemiBold,
      color: AppColors.THEME_COLOR_WHITE,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final void Function()? onPrefixTap;
  final void Function()? onTap, onTapSuffix;
  final String? prefxicon;
  final bool? isSuffixIcon;
  final TextInputType? keyboardType;
  final double? prefixRIghtPadding,
      sufixRIghtPadding,
      scale,
      borderRadius,
      suffixScale;
  final bool? isDataFill;
  final int? lines;
  final bool? readOnly, divider, label;
  final bool? isPasswordField;
  final Color? color, eyeColor, borderColor;
  final String? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final String hint;
  final double? fontsize, width;
  final bool? obscureText;
  final Color? prefixIconColor;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onchange;
  final void Function()? onclick;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? textStyle;
  final FocusNode? focusNode;

  CustomTextField({
    super.key,
    this.onPrefixTap,
    this.onTap,
    this.onTapSuffix,
    this.prefxicon,
    this.isSuffixIcon,
    this.keyboardType,
    this.prefixRIghtPadding,
    this.sufixRIghtPadding,
    this.scale,
    this.borderRadius,
    this.suffixScale,
    this.isDataFill = false,
    this.lines,
    this.readOnly = false,
    this.divider = true,
    this.label = true,
    this.isPasswordField = false,
    this.color,
    this.eyeColor,
    this.suffixIcon,
    this.focusNode,
    this.contentPadding,
    required this.hint,
    this.fontsize,
    this.width,
    this.obscureText = false,
    this.prefixIconColor,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.controller,
    this.validator,
    this.onchange,
    this.onclick,
    this.inputFormatters,
    this.textStyle,
    this.borderColor,
  });

  bool isVisible = true;
  bool textVisible = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: new ThemeData(
        primaryColor: Colors.redAccent,
        primaryColorDark: Colors.red,
      ),
      child: TextFormField(
         focusNode: focusNode,
        onTap: onTap,
        readOnly: readOnly!,
        textInputAction: TextInputAction.done,
        keyboardType: keyboardType,
        onChanged: onchange,
        validator: validator,
        // obscureText: textVisible,
        cursorColor: AppColors.THEME_COLOR_WHITE,
        controller: controller,
        maxLines: lines ?? 1,
        onFieldSubmitted: onFieldSubmitted,
        autofocus: false,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        style: _textStyle(),
        decoration: InputDecoration(
          fillColor: color ?? AppColors.PRIMARY_COLOR.withOpacity(0.6),
          filled: true,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          hintText: hint,
          hintStyle: textStyle ?? _textStyle(),
          border: _outLineInputBorder(),
          focusedBorder: _outLineInputBorder(),
          enabledBorder: _outLineInputBorder(),
          errorBorder: _outLineInputBorder(),
          focusedErrorBorder: _outLineInputBorder(),
          disabledBorder: _outLineInputBorder(),
          isDense: true,
          errorStyle: const TextStyle(overflow: TextOverflow.visible, color: AppColors.THEME_COLOR_WHITE),
          errorMaxLines: 3,
          prefixIcon: prefxicon != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: prefixRIghtPadding ?? 15.w, right: 5.w),
                  child: Image.asset(
                    prefxicon!,
                    // height: 20.h,
                    width: 22.w,
                    color: AppColors.THEME_COLOR_WHITE,
                    scale: scale ?? 3.sp,
                  ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: isPasswordField!
              ? _passwordSuffixIconWidget()
              : isSuffixIcon == true
                  ? _suffixIconWidget()
                  : null,
          suffixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
      borderSide: BorderSide(
        // width: 5,
        color: borderColor ?? AppColors.PRIMARY_COLOR,
        style: BorderStyle.solid,
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: fontsize ?? 16.sp,
      color: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Regular,
    );
  }

  Widget _suffixIconWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTapSuffix,
        child: Image.asset(
          suffixIcon!,
          scale: suffixScale ?? 2.7.sp,
        ),
      ),
    );
  }

  GestureDetector _passwordSuffixIconWidget() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: AppColors.THEME_COLOR_WHITE,
          size: 22.sp,
        ),
      ),
      onTap: onTapSuffix,
      // onTap: () {
      //   setState(() {
      //     isVisible = !isVisible;
      //     textVisible = !textVisible;
      //   });
      // },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/blocs/firebase_auth_bloc.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/widgets/custom_button.dart';
import 'package:locks_hybrid/utils/field_validator.dart';
import 'package:locks_hybrid/widgets/custom_keyboard_action_widget.dart';
import 'package:locks_hybrid/widgets/custom_textfield.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_text.dart';
import '../widgets/custom_auth_background.dart';

class PhoneLoginScreen extends StatefulWidget {
  PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneNoController = TextEditingController();

  final _phoneLoginFormKey = GlobalKey<FormState>();

  final FocusNode _phoneFocusNode = FocusNode();

  FirebaseAuthBloc _firebaseAuthBloc = FirebaseAuthBloc();

  @override
  Widget build(BuildContext context) {
    return CustomAuthBackground(
      child: Column(
        children: [
          SizedBox(height: 30.h),
          _title(),
          SizedBox(height: 10.h),
          _signInText(),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _phoneLoginFormKey,
                child: Column(
                  children: [
                    _phoneTextField(),
                    SizedBox(height: 10.h),
                    _button(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return CustomText(
      text: AppStrings.WELCOME_BACK,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_SemiBold,
      fontSize: 20.sp,
    );
  }

  Widget _signInText() {
    return CustomText(
      text: AppStrings.PLEASE_SIGN_IN_TO_YOUR_ACCOUNT,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.sp,
    );
  }

  Widget _phoneTextField() {
    return CustomKeyboardActionWidget(
      focusNode: _phoneFocusNode,
      child: CustomTextField(
        hint: AppStrings.PHONE_NUMBER,
        focusNode: Platform.isIOS ? _phoneFocusNode : null,
        controller: _phoneNoController,
        validator: (value) => value?.validatePhoneNumber(),
        keyboardType: TextInputType.number,
        inputFormatters: [Constants.MASK_TEXT_FORMATTER_PHONE_NO],
      ),
    );
  }

  // Widget _phoneTextField() {
  Widget _button(context) {
    return CustomButton(
      onTap: () => _phoneLoginValidationMethod(context),
      text: AppStrings.CONTINUE,
    );
  }

  void _phoneLoginValidationMethod(BuildContext context) {
    _keyBoardUnfocusMethod();
    if (_phoneLoginFormKey.currentState!.validate()) {
      _keyBoardUnfocusMethod();
      _phoneLoginMethod();
    }
  }


  void _phoneLoginMethod() {
    _firebaseAuthBloc.signInWithPhone(
        context: context,
        phoneCode: Constants.US_PHONE_CODE,
        countryCode: Constants.US_COUNTRY_CODE,
        phoneNumber: Constants.MASK_TEXT_FORMATTER_PHONE_NO.unmaskText(_phoneNoController.text),
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        },
        // cancelProgressBar: () {
        //   AppNavigation.navigatorPop(context);
        // }
        );
  }

  void _keyBoardUnfocusMethod() {
    Constants.unFocusKeyboardMethod(context: context);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/blocs/firebase_auth_bloc.dart';
import 'package:locks_hybrid/auth/blocs/resend_otp_bloc.dart';
import 'package:locks_hybrid/auth/blocs/verify_otp_bloc.dart';
import 'package:locks_hybrid/auth/widgets/custom_pincode_textfield.dart';
import 'package:locks_hybrid/auth/widgets/custom_progress_indicator.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_text.dart';
import '../widgets/custom_auth_background.dart';

class VerificationScreen extends StatefulWidget {
  final String? otpType, phoneNo, phoneCode, countryCode, phoneVerificationId;
  final int? userId;

  VerificationScreen({
    this.otpType,
    this.userId,
    this.phoneNo,
    this.phoneCode,
    this.countryCode,
    this.phoneVerificationId,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _verficationCodeController = TextEditingController();
  final CountDownController _countDownController = CountDownController();
  VerifyOtpBloc _verifyOtpBloc = VerifyOtpBloc();
  ResendOtpBloc _resendOtpBloc = ResendOtpBloc();
  FirebaseAuthBloc _firebaseAuthBloc = FirebaseAuthBloc();
  String? _phoneVerificationId;
  bool _isCodeExpired = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("Phone No:${widget.phoneNo}");
    print("Phone Code:${widget.phoneCode}");
    print("Country Code:${widget.countryCode}");
    print("Verification Id:${widget.phoneVerificationId}");
    _phoneVerificationId = widget.phoneVerificationId;
  }

  @override
  Widget build(BuildContext context) {
    return CustomAuthBackground(
      onLeadingTap: () {
        _keyBoardUnfocusMethod();
        AppNavigation.navigatorPop(context);
      },
      child: Column(
        children: [
          SizedBox(height: 30.h),
          _title(),
          SizedBox(height: 10.h),
          _verifyText(),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _pinCodeField(),
                  SizedBox(height: 10.h),
                  _progressIndicator(),
                ],
              ),
            ),
          ),
          _resendText(context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _title() {
    return CustomText(
      text: AppStrings.PLEASE_VERIFY_YOUR_ACCOUNT,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_SemiBold,
      fontSize: 20.sp,
    );
  }

  Widget _verifyText() {
    return CustomText(
      text: AppStrings.WE_SEND_YOU_A_SIX_DIGIT_CODE,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.sp,
      lineSpacing: 1.5,
    );
  }

  Widget _pinCodeField() {
    return CustomPinCodeTextField(
      controller: _verficationCodeController,
      onComplete: (String? verifyCode) {
        // AppNavigation.navigatorPop(context);
        // AppNavigation.navigateReplacementNamed(
        //   context,
        //   AppRouteName.SET_PROFILE_SCREEN_ROUTE,
        //   arguments: false,
        // );

        print("Verify Code:${verifyCode}");

        if (widget.otpType == OtpType.phone_login.name &&
            _isCodeExpired == true) {
          AppDialogs.showToast(message: AppStrings.CODE_EXPIRED_ERROR);
        } else {
          _verifyCodeMethod();
        }
      },
    );
  }

  Widget _progressIndicator() {
    return Visibility(
      visible: (widget.otpType == OtpType.phone_login.name &&
              _isCodeExpired == false)
          ? true
          : false,
      child: CustomProgressIndicator(
        countDownController: _countDownController,
        onComplete: () {
          print("timer completed");
          setState(() {
            _isCodeExpired = true;
          });
        },
      ),
    );
  }

  Widget _resendText(BuildContext context) {
    TextStyle linkTextStyle = TextStyle(
        color: AppColors.THEME_COLOR_WHITE,
        fontSize: 14.sp,
        fontFamily: AppFonts.Poppins_SemiBold,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline);
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0 &&
          (widget.otpType == OtpType.login.name ||
              (widget.otpType == OtpType.phone_login.name &&
                  _isCodeExpired == true)),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: AppColors.THEME_COLOR_WHITE,
              fontSize: 14.sp,
              fontFamily: AppFonts.Poppins_Medium,
            ),
            children: <TextSpan>[
              const TextSpan(text: AppStrings.DONT_RECEIVED_THE_CODE),
              TextSpan(
                text: AppStrings.RESEND,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _resendOtpMethod();
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyCodeMethod() {
    //If comes from login
    if (widget.otpType == OtpType.login.name) {
      _verifyOtpApiMethod();
    }
    //If comes from Social Login
    else if (widget.otpType == OtpType.phone_login.name) {
      _verifyPhoneOtpApiMethod();
    }
  }

  void _resendOtpMethod() {
    //If comes from login
    if (widget.otpType == OtpType.login.name) {
      _verficationCodeController.clear();
      _resendOtpApiMethod();
    }
    //If comes from Social Login
    else if (widget.otpType == OtpType.phone_login.name) {
      _resendPhoneOtpMethod();
    }
  }

  //When comes from login it verifies otp
  void _verifyOtpApiMethod() {
    _keyBoardUnfocusMethod();

    // print("User Id:${widget.userId}");
    // print("Verify Code:${_verficationCodeController.text}");

    _verifyOtpBloc.verifyOtpBlocMethod(
        context: context,
        userId: widget.userId,
        otp: _verficationCodeController.text,
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        });
  }

  void _verifyPhoneOtpApiMethod() {
    _keyBoardUnfocusMethod();

    print("User Id:${widget.userId}");
    // print("Verify Code:${_verficationCodeController.text}");

    _firebaseAuthBloc.verifyPhoneCode(
      context: context,
      phoneCode: widget.phoneCode,
      countryCode: widget.countryCode,
      phoneNumber: widget.phoneNo,
      verificationId: _phoneVerificationId ?? "",
      verificationCode: _verficationCodeController.text,
    );
  }

  //When comes from login it resends otp
  void _resendOtpApiMethod() {
    _keyBoardUnfocusMethod();

    // print("User Id:${widget.userId}");
    // print("Verify Code:${_verficationCodeController.text}");

    _resendOtpBloc.resendOtpBlocMethod(
        context: context,
        userId: widget.userId,
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        });
  }

  //When comes from phone login it resends otp
  void _resendPhoneOtpMethod() {
    _firebaseAuthBloc.resendPhoneCode(
      context: context,
      phoneCode: widget.phoneCode ?? Constants.US_PHONE_CODE,
      phoneNumber: widget.phoneNo ?? "",
      getVerificationId: (String? verificationId) {
        _phoneVerificationId = verificationId;
        _isCodeExpired = false;
        _verficationCodeController.text = "";
        print("Phone verification Id:${_phoneVerificationId}");
        setState(() {});
      },
      setProgressBar: () {
        AppDialogs.circularProgressDialog(context: context);
      },
    );
  }

  void _keyBoardUnfocusMethod() {
    Constants.unFocusKeyboardMethod(context: context);
  }

  @override
  void dispose() {
    _verficationCodeController.dispose();
    super.dispose();
  }
}

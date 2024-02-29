import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/blocs/firebase_auth_bloc.dart';
import 'package:locks_hybrid/auth/widgets/custom_auth_background.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

import '../../content/routing_arguments/content_routing_arguments.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/asset_paths.dart';
import '../widgets/custom_social_login_button.dart';

class PreLoginScreen extends StatelessWidget {

  FirebaseAuthBloc _firebaseAuthBloc = FirebaseAuthBloc();

  @override
  Widget build(BuildContext context) {
    return CustomAuthBackground(
      isLeading: false,
      child: Column(
        children: [
          SizedBox(height: 30.h),
          _title(),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _loginWithEmailButton(context),
                  SizedBox(height: 10.h),
                  _loginWithPhoneButton(context),
                  SizedBox(height: 10.h),
                  _loginWithGoogleButton(context),
                  if (Platform.isIOS) ...[
                    SizedBox(height: 10.h),
                    _loginWithAppleButton(context),
                  ],
                ],
              ),
            ),
          ),
          _termsAndprivacyNavigationWidget(context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _title() {
    return CustomText(
      text: AppStrings.SOCIAL_LOGIN,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_SemiBold,
      fontSize: 20.sp,
    );
  }

  Widget _loginWithEmailButton(BuildContext context) {
    return CustomSocialLoginButton(
      backgroundColor: AppColors.PRIMARY_COLOR,
      title: AppStrings.SIGN_IN_WITH_EMAIL,
      iconPath: AssetPath.EMAIL_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      horizontalPadding: 0,
      fontSize: 16,
      iconScale: 4,
      onTap: () {
        AppNavigation.navigateTo(context, AppRouteName.LOGIN_SCREEN_ROUTE);
      },
    );
  }

  Widget _loginWithPhoneButton(BuildContext context) {
    return CustomSocialLoginButton(
      backgroundColor: AppColors.THEME_COLOR_WHITE,
      title: AppStrings.SIGN_IN_WITH_PHONE,
      iconPath: AssetPath.PHONE_ICON,
      fontColor: AppColors.THEME_COLOR_BLACK,
      horizontalPadding: 0,
      fontSize: 16,
      iconScale: 4,
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.PHONE_LOGIN_SCREEN_ROUTE);
      },
    );
  }

  Widget _loginWithGoogleButton(BuildContext context) {
    return CustomSocialLoginButton(
      backgroundColor: AppColors.THEME_COLOR_GOOGLE,
      title: AppStrings.SIGN_IN_WITH_GOOGLE,
      iconPath: AssetPath.GOOGLE_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      horizontalPadding: 0,
      fontSize: 16,
      iconScale: 4,
      onTap: () {
        _firebaseAuthBloc.signInWithGoogle(context: context);
      },
    );
  }

  Widget _loginWithAppleButton(BuildContext context) {
    return CustomSocialLoginButton(
      backgroundColor: AppColors.THEME_COLOR_BLACK,
      title: AppStrings.SIGN_IN_WITH_APPLE,
      iconPath: AssetPath.APPLE_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      horizontalPadding: 0,
      fontSize: 16,
      iconScale: 4,
      onTap: () {
        _firebaseAuthBloc.signInWithApple(context: context);
      },
    );
  }

  Widget _termsAndprivacyNavigationWidget(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: AppColors.THEME_COLOR_WHITE,
      fontSize: 14.sp,
      fontFamily: AppFonts.Poppins_Medium,
    );
    TextStyle linkTextStyle = TextStyle(
      color: AppColors.THEME_COLOR_WHITE,
      fontSize: 14.sp,
      fontFamily: AppFonts.Poppins_Medium,
      decoration: TextDecoration.underline
    );
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textStyle,
            children: <TextSpan>[
              const TextSpan(
                  text: AppStrings.BY_SIGN_IN_YOU_AGREE_TO_OUR + '\n'),
              TextSpan(
                text: AppStrings.TERMS_AND_CONDITIONS,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppNavigation.navigateTo(
                      context,
                      AppRouteName.CONTENT_SCREEN_ROUTE,
                      arguments: ContentRoutingArgument(
                        title: AppStrings.TERMS_AND_CONDITIONS,
                        contentType: AppStrings.TERMS_CONDITION_TYPE
                      ),
                    );
                  },
              ),
              const TextSpan(text: AppStrings.AND),
              TextSpan(
                text: AppStrings.PRIVACY_POLICY,
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppNavigation.navigateTo(
                      context,
                      AppRouteName.CONTENT_SCREEN_ROUTE,
                      arguments: ContentRoutingArgument(
                        title: AppStrings.PRIVACY_POLICY,
                          contentType: AppStrings.PRIVACY_POLICY_TYPE
                      ),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

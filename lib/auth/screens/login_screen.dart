import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/blocs/login_bloc.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_button.dart';
import 'package:locks_hybrid/widgets/custom_textfield.dart';
import 'package:locks_hybrid/utils/field_validator.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text.dart';
import '../widgets/custom_auth_background.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailAddressController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  LoginBloc _loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return CustomAuthBackground(
      onLeadingTap: (){
        _keyBoardUnfocusMethod();
        AppNavigation.navigatorPop(context);
      },
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
                key: _loginFormKey,
                child: Column(
                  children: [
                    _emailTextField(),
                    SizedBox(height: 10.h),
                    _button(context),
                    SizedBox(height: 10.h),
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

  Widget _emailTextField() {
    return CustomTextField(
      hint: AppStrings.ENTER_YOUR_EMAIL,
      prefxicon: AssetPath.EMAIL_ICON,
      keyboardType: TextInputType.emailAddress,
      controller: _emailAddressController,
      validator: (value) => value?.validateEmail,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
      ],
      scale: 4,
    );
  }

  Widget _button(context) {
    return CustomButton(
      onTap: () => _loginValidationMethod(context),
      text: AppStrings.CONTINUE,
    );
  }

  void _loginValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_loginFormKey.currentState!.validate()) {
      // AppNavigation.navigateTo(context, AppRouteName.VERIFICATION_SCREEN_ROUTE);
      _loginApiMethod();
    }
  }

  void _loginApiMethod() {
    _keyBoardUnfocusMethod();
    _loginBloc.loginBlocMethod(
        context: context,
        userEmail: _emailAddressController.text,
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        });
  }

  void _keyBoardUnfocusMethod() {
    Constants.unFocusKeyboardMethod(context: context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailAddressController.dispose();
    super.dispose();
  }
}

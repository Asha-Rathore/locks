import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/models/user_model.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/profile/blocs/complete_profile_bloc.dart';
import 'package:locks_hybrid/profile/widgets/custom_profile_image.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:locks_hybrid/widgets/custom_appbar.dart';
import 'package:locks_hybrid/widgets/custom_button.dart';
import 'package:locks_hybrid/widgets/custom_keyboard_action_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_textfield.dart';
import 'package:locks_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../auth/widgets/custom_phone_textfield.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_route_name.dart';
import '../../utils/asset_paths.dart';
import '../../utils/constants.dart';
import '../../utils/image_gallery_class.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();
  String? _imagePath, _imageType, _phoneCode, _countryCode;
  final FocusNode _phoneFocusNode = FocusNode();
   String? _socialType;

  bool _isProfileComplete = false;

  CompleteProfileBloc _completeProfileBloc = CompleteProfileBloc();

  UserModelData? _userModelData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: _isProfileComplete
          ? null
          : const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
                fit: BoxFit.cover,
              ),
            ),
      child: _scaffoldWidget(
        context: context,
        backgroundColor: _isProfileComplete
            ? AppColors.PRIMARY_COLOR
            : AppColors.THEME_COLOR_TRANSPARENT,
      ),
    );
  }

  Widget _scaffoldWidget({BuildContext? context, Color? backgroundColor}) {
    return Scaffold(
      // resizeToAvoidBottomInset: widget.isEdit! ? false : true,
      //  resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: _appBar(context),
      body: CustomPadding(
        child: SingleChildScrollView(
          child: Form(
            key: _profileFormKey,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                _profileImage(context),
                SizedBox(height: 20.h),
                _firstNameTextField(),
                SizedBox(height: 10.h),
                _lastNameTextField(),
                _emailTextField(),
                _phoneTextField(),
                SizedBox(height: _isProfileComplete ?
                _socialType == null ? 0.28.sh : 0.38.sh : 10.h),
                _button(context),
                SizedBox(height: 38.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      leading: _isProfileComplete == true ? AssetPath.BACK_ICON : null,
      title:
          _isProfileComplete ? AppStrings.EDIT_PROFILE : AppStrings.SET_PROFILE,
      onclickLead: () {
        _keyBoardUnfocusMethod();
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _profileImage(context) {
    return CustomProfileImage(
      icon: _isProfileComplete ? AssetPath.UPLOAD_ICON : AssetPath.ADD_ICON,
      height: _isProfileComplete ? 10.h : 11.0.h,
      imagePath: _imagePath,
      imageType: _imageType,
      onTap: () {
        ImageGalleryClass().imageGalleryBottomSheet(
          context: context,
          onMediaChanged: (Map<String, dynamic>? mediaData) {
            if (mediaData?["media_path"] != null) {
              print("Media Data:${mediaData}");
              _imagePath = mediaData?["media_path"];
              _imageType = MediaPathType.file.name;
              print("Image Path:${_imagePath}");
              setState(() {});
            }
          },
        );
      },
    );
  }

  Widget _firstNameTextField() {
    return CustomTextField(
      hint: AppStrings.FIRST_NAME,
      borderColor: _isProfileComplete
          ? AppColors.THEME_COLOR_WHITE.withOpacity(0.6)
          : AppColors.PRIMARY_COLOR,
      controller: _firstNameController,
      validator: (value) => value?.validateEmpty("First name"),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _lastNameTextField() {
    return CustomTextField(
      hint: AppStrings.LAST_NAME,
      borderColor: _isProfileComplete
          ? AppColors.THEME_COLOR_WHITE.withOpacity(0.6)
          : AppColors.PRIMARY_COLOR,
      controller: _lastNameController,
      validator: (value) => value?.validateEmpty("Last name"),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _emailTextField() {
    return Visibility(
      visible: _userModelData?.userSocialType == null ? true : false,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: CustomTextField(
          hint: AppStrings.EMAIL_ADDRESS,
          borderColor: _isProfileComplete
              ? AppColors.THEME_COLOR_WHITE.withOpacity(0.6)
              : AppColors.PRIMARY_COLOR,
          controller: _emailAddressController,
          validator: (value) => value?.validateEmail,
          readOnly: true,
          inputFormatters: [
            LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
          ],
        ),
      ),
    );
  }

  Widget _phoneTextField() {
    return Visibility(
      visible: _userModelData?.userSocialType == SocialType.phone.name
          ? true
          : false,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: CustomKeyboardActionWidget(
          focusNode: _phoneFocusNode,
          child: CustomTextField(
            hint: AppStrings.PHONE_NUMBER,
            focusNode: Platform.isIOS ? _phoneFocusNode : null,
            borderColor: _isProfileComplete
                ? AppColors.THEME_COLOR_WHITE.withOpacity(0.6)
                : AppColors.PRIMARY_COLOR,
            controller: _phoneNumberController,
            validator: (value) => value?.validatePhoneNumber(),
            keyboardType: TextInputType.number,
            readOnly: true,
            inputFormatters: [Constants.MASK_TEXT_FORMATTER_PHONE_NO],
          ),
        ),
      ),
    );
  }

  Widget _button(context) {
    return CustomButton(
      onTap: () => _profileValidationMethod(context),
      text: _isProfileComplete ? AppStrings.SAVE : AppStrings.CREATE,
      backgroundColor: _isProfileComplete
          ? AppColors.THEME_COLOR_LIGHT_GREEN
          : AppColors.PRIMARY_COLOR,
      textColor: _isProfileComplete
          ? AppColors.THEME_COLOR_DARK_GREEN
          : AppColors.THEME_COLOR_WHITE,
    );
  }

  void _profileValidationMethod(BuildContext context) {
    if (_profileFormKey.currentState!.validate()) {
      _completeProfileApiMethod();
    }
  }

  void _completeProfileApiMethod() {
    _keyBoardUnfocusMethod();
    print("First Name:${_firstNameController.text}");
    print("Last Name:${_lastNameController.text}");
    print(
        "Phone Number:${Constants.MASK_TEXT_FORMATTER_PHONE_NO.unmaskText(_phoneNumberController.text)}");
    print("Phone Code:${_phoneCode ?? Constants.US_PHONE_CODE}");
    print("Country Code:${_countryCode ?? Constants.US_COUNTRY_CODE}");
    print("Email:${_emailAddressController.text}");
    print("User Profile Image:${_imagePath}");
    print("Image Type:${_imageType}");
    print("Profile Complete Status:${_isProfileComplete}");

    _completeProfileBloc.completeProfileBlocMethod(
        context: context,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: Constants.MASK_TEXT_FORMATTER_PHONE_NO
            .unmaskText(_phoneNumberController.text),
        phoneCode: _phoneCode ?? Constants.US_PHONE_CODE,
        countryCode: _countryCode ?? Constants.US_COUNTRY_CODE,
        email: _emailAddressController.text,
        userProfileImage: _imagePath,
        imageType: _imageType,
        isProfileComplete: _isProfileComplete,
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        });
  }

  void _getUserData() {
    _userModelData =
        Provider.of<UserProvider>(context, listen: false).getCurrentUser?.data;

    if (_userModelData != null) {
      _firstNameController.text = _userModelData?.firstName ?? "";
      _lastNameController.text = _userModelData?.lastName ?? "";
      _phoneNumberController.text =
          _userModelData!.phoneNumber.checkNullEmptyText
              ? Constants.MASK_TEXT_FORMATTER_PHONE_NO
                  .maskText(_userModelData!.phoneNumber!)
              : "";
      _phoneCode = _userModelData?.phoneCode ?? Constants.US_PHONE_CODE;
      _countryCode = _userModelData?.countryCode ?? Constants.US_COUNTRY_CODE;
      _emailAddressController.text = _userModelData?.email ?? "";
      _imagePath = Constants.getImage(
          imagePath: _userModelData?.profileImage);
      _imageType = _imagePath != null ? MediaPathType.network.name : null;
      _isProfileComplete =
          _userModelData?.isProfileComplete == NetworkStrings.PROFILE_COMPLETED
              ? true
              : false;

      _socialType = _userModelData?.userSocialType;
    }
  }

  void _keyBoardUnfocusMethod() {
    Constants.unFocusKeyboardMethod(context: context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }
}

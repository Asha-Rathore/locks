import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:path/path.dart' as getImagePath;
import 'package:provider/provider.dart';

class CompleteProfileBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _completeProfileResponse;
  File? _userFileImage;
  Map<String, dynamic> _userObject = {};
  String? imagePath, imageName;
  UserProvider? _userProvider;

  /// ------------- Complete Profile Bloc Method -------------- ///
  void completeProfileBlocMethod({
    required BuildContext context,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? phoneCode,
    String? countryCode,
    String? email,
    String? userProfileImage,
    String? imageType,
    bool? isProfileComplete,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    _userObject = {
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      "phone_code": phoneCode,
      "country_code": countryCode,
      "email": email
    };

    if (imageType == MediaPathType.file.name) {
      _userFileImage = File(userProfileImage!);
      imagePath = _userFileImage!.path;
      imageName = getImagePath.basename(_userFileImage!.path);

      print("Image Path:${imagePath}");
      print("Image Name:${imageName}");

      _userObject["profile_image"] =
          await MultipartFile.fromFile(imagePath!, filename: imageName);
    }
    _formData = FormData.fromMap(_userObject);

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.COMPLETE_PROFILE_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _completeProfileResponseMethod(
          context: context, isProfileComplete: isProfileComplete);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().postRequest(
        baseUrl: NetworkStrings.API_BASE_URL,
        endPoint: endPoint,
        formData: _formData,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _completeProfileResponseMethod(
      {required BuildContext context, bool? isProfileComplete}) {
    try {
      _completeProfileResponse = _response?.data;

      if (_completeProfileResponse != null) {
        print("Complete Profile Response:${_completeProfileResponse}");

        //set user data in shared preference
        SharedPreference().setUser(user: jsonEncode(_completeProfileResponse));

        //assign reference to user provider
        _userProvider = Provider.of<UserProvider>(context, listen: false);

        //set verify otp response to user provider method
        _userProvider?.setCurrentUser(user: _completeProfileResponse);

        //If profile has been completed
        if (isProfileComplete == true) {
          AppNavigation.navigatorPop(context);
        }
        //If profile is incomplete
        else {
          AppNavigation.navigateToRemovingAll(
              context, AppRouteName.MAIN_SCREEN_ROUTE);
        }

        // AppNavigation.navigateTo(
        //     context, AppRouteName.VERIFICATION_SCREEN_ROUTE,
        //     arguments: OtpArguments(
        //         otpType: OtpType.login.name,
        //         userId: _loginResponse["data"]["user_id"]));
      }
    } catch (error) {
      log("Error:${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}

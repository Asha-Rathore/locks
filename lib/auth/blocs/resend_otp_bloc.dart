import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class ResendOtpBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  /// ------------- Resend Otp Bloc Method -------------- ///
  void resendOtpBlocMethod({
    required BuildContext context,
    int? userId,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    //Form Data
    _formData = FormData.fromMap({"user_id": userId});

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.RESEND_OTP_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
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
        isHeaderRequire: false);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

}

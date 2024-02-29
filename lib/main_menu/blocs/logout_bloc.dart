import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/auth/routing_arguments/otp_arguments.dart';
import 'package:locks_hybrid/services/firebase_messaging_service.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';

class LogoutBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  /// ------------- Logout Bloc Method -------------- ///
  void logoutBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    //Form Data
    _formData = FormData.fromMap({
      "user_id": Provider.of<UserProvider>(context,listen: false).getCurrentUser?.data?.id,
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.LOGOUT_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      StaticData.clearAllAppData(context: context);
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
}

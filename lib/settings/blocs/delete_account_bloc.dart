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

class DeleteAccountBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  /// ------------- Delete Account Bloc Method -------------- ///
  void deleteAccountBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();


    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _getRequest(endPoint: NetworkStrings.DELETE_ACCOUNT_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      StaticData.clearAllAppData(context: context);
    };

    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().getRequest(
        baseUrl: NetworkStrings.API_BASE_URL,
        endPoint: endPoint,
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

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class LeaguesBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _leaguesResponse;
  LeaguesProvider? _leaguesProvider;

  Future<void> leaguesBlocMethod(
      {required BuildContext context, String? apiTimeStamp}) async {
    _leaguesProvider = LeaguesService().getLeaguesProvider;

    _leaguesProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);

    _onFailure = () {
      //log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.LEAGUES_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _leaguesResponseMethod(apiTimeStamp: apiTimeStamp);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().getRequest(
      baseUrl: NetworkStrings.API_BASE_URL,
      endPoint: endPoint,
      onFailure: _onFailure,
      isHeaderRequire: false,
      isToast: false,
      isErrorToast: true,
      connectTimeOut: 15000
    );
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response,
          onSuccess: _onSuccess,
          onFailure: _onFailure,
          isToast: false);
    }
  }

  void _leaguesResponseMethod({String? apiTimeStamp}) {
    try {
      _leaguesResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_leaguesResponse != null &&
          _leaguesProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("Leagues Response:${_leaguesResponse}");
        _leaguesProvider?.setLeaguesData(
            leaguesModel: LeaguesModel.fromJson(_leaguesResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_leaguesProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_leaguesProvider?.getLeaguesModel == null) {
        _leaguesProvider?.setLeaguesData(leaguesModel: null);
      }
    }
  }

  void clearData() {
    _leaguesProvider?.clearData();
  }

}

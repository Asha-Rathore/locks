import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class TeamsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _teamsResponse;
  TeamsProvider? _teamsProvider;

  Future<void> teamsBlocMethod(
      {required BuildContext context,
      String? leagueAbbreviation,
      String? apiTimeStamp,
      VoidCallback? setProgressBar,
      VoidCallback? onSuccess,
      VoidCallback? onFailure,
      bool? isToast}) async {
    setProgressBar != null ? setProgressBar() : null;

    _teamsProvider = LeaguesService().getTeamsProvider;

    _teamsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"l": leagueAbbreviation};

    _onFailure = () {
      //log("fail ha");
      onFailure != null ? onFailure() : null;
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(
        endPoint: NetworkStrings.TEAMS_ENDPOINT, isToast: isToast);

    _onSuccess = () {
      //log("success ha");
      onSuccess != null ? onSuccess() : null;
      _teamsResponseMethod(apiTimeStamp: apiTimeStamp);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint, bool? isToast}) async {
    //print("post request");
    _response = await Network().getRequest(
        endPoint: endPoint,
        queryParameters: _queryParameters,
        onFailure: _onFailure,
        isHeaderRequire: true,
        isToast: isToast ?? false,
        isErrorToast: isToast ?? false,
        connectTimeOut: 15000);
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

  void _teamsResponseMethod({String? apiTimeStamp}) {
    try {
      _teamsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_teamsResponse != null &&
          _teamsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("Teams Response:${_teamsResponse}");
        _teamsProvider?.setTeamsData(
            teamsModel: TeamsModel.fromJson(_teamsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_teamsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_teamsProvider?.getTeamsModel == null) {
        _teamsProvider?.setTeamsData(teamsModel: null);
      }
    }
  }

  void clearData() {
    _teamsProvider?.clearData();
  }

// void initializeTeamsProvider({required BuildContext context}) {
//   _teamsProvider = Provider.of<TeamsProvider>(context, listen: false);
// }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/team_standings/blocs/team_standings_service.dart';
import 'package:locks_hybrid/team_standings/provider/team_standings_provider.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class TeamStandingsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _teamStandingsResponse;
  TeamStandingsProvider? _teamStandingsProvider;
  TeamStandingsService _teamStandingsService = TeamStandingsService();

  Future<void> teamStandingsBlocMethod({
    required BuildContext context,
    String? standingsType,
    String? seasonYear,
    String? apiTimeStamp,
  }) async {
    _teamStandingsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {
      "key": NetworkStrings.STANDINGS_API_KEYS_LIST[standingsType]
    };

    print("Query Parameters:${_queryParameters}");

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(
        endPoint:
            (NetworkStrings.STANDINGS_ENDPOINTS_LIST[standingsType] ?? "") +
                "/" +
                (seasonYear ?? ""),
        standingsType: standingsType);

    _onSuccess = () {
      //log("success ha");
      _teamStandingsResponseMethod(
          apiTimeStamp: apiTimeStamp, standingsType: standingsType);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, String? standingsType}) async {
    //print("post request");
    _response = await Network().getRequest(
        baseUrl: NetworkStrings.STANDINGS_API_BASE_URL,
        endPoint: endPoint,
        queryParameters: _queryParameters,
        onFailure: _onFailure,
        isStandingsApi: true,
        isHeaderRequire: false,
        isToast: false,
        isErrorToast: false);
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

  void _teamStandingsResponseMethod(
      {String? apiTimeStamp, String? standingsType}) {
    try {
      _teamStandingsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_teamStandingsResponse != null &&
          _teamStandingsProvider?.getApiTimeStamp == apiTimeStamp) {
        _teamStandingsService.setTeamStandingsCommonModel(
            standingsType: standingsType,
            standingsResponse: _teamStandingsResponse);
      }
    } catch (error) {
      log("Upcoming :${error}");
      //AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  // void setTeamStandingsData({dynamic teamStandingsFilterResponse}) {
  //   try {
  //     _teamStandingsProvider?.setTeamStandingsData(
  //         teamStandingsModel:
  //             TeamStandingsModel.fromJson(_teamStandingsResponse));
  //     // Provider.of<TeamStandingsProvider>(StaticData.navigatorKey.currentContext!,
  //     //     listen: false)
  //     //     .setTeamStandingsData(
  //     //     teamStandingsModel:
  //     //     TeamStandingsModel.fromJson(_teamStandingsResponse));
  //   } catch (e) {}
  // }

  void _setDataNull({String? apiTimeStamp}) {
    if (_teamStandingsProvider?.getApiTimeStamp == apiTimeStamp) {
      _teamStandingsProvider?.setTeamStandingsData(teamStandingsModel: null);
    }
  }

  void clearData() {
    _teamStandingsProvider?.clearData();
  }

  void clearDataRebuild() {
    _teamStandingsProvider?.clearDataRebuild();
  }

  void initializeTeamStandingsProvider({required BuildContext context}) {
    _teamStandingsProvider =
        Provider.of<TeamStandingsProvider>(context, listen: false);
  }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class LeagueLatestResultEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _latestEventsResponse;
  LeagueLatestResultEventsProvider? _leagueLatestResultEventsProvider;

  Future<void> leagueLatestResultEventsBlocMethod(
      {required BuildContext context,
      String? apiTimeStamp,
      String? leagueId}) async {
    _leagueLatestResultEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": leagueId ?? "0"};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.LEAGUE_LATEST_RESULT_EVENTS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _leagueLatestEventsResponseMethod(apiTimeStamp: apiTimeStamp);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().getRequest(
        endPoint: endPoint,
        queryParameters: _queryParameters,
        onFailure: _onFailure,
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

  void _leagueLatestEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _latestEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_latestEventsResponse != null &&
          _leagueLatestResultEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("League Upcoming Events Response:${_latestEventsResponse}");
        _leagueLatestResultEventsProvider?.setLatestEventData(
            eventsModel: EventsModel.fromJson(_latestEventsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_leagueLatestResultEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_leagueLatestResultEventsProvider?.getEventsModel == null) {
        _leagueLatestResultEventsProvider?.setLatestEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    _leagueLatestResultEventsProvider?.clearData();
  }

  void initializeLeagueLatestResultEventsProvider({required BuildContext context}) {
    _leagueLatestResultEventsProvider =
        Provider.of<LeagueLatestResultEventsProvider>(context, listen: false);
  }
}

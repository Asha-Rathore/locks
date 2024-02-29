import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class TeamLatestResultEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _latestEventsResponse;
  TeamLatestResultEventsProvider? _teamLatestResultEventsProvider;

  Future<void> teamLatestResultEventsBlocMethod(
      {required BuildContext context,
        String? apiTimeStamp,
        String? teamId}) async {
    _teamLatestResultEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": teamId ?? "0"};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.TEAM_LATEST_RESULT_EVENTS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _teamLatestEventsResponseMethod(apiTimeStamp: apiTimeStamp);
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

  void _teamLatestEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _latestEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_latestEventsResponse != null &&
          _teamLatestResultEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("Team Latest Events Response:${_latestEventsResponse}");

        _latestEventsResponse["events"] = _latestEventsResponse["results"];
        _latestEventsResponse["results"] = [];

        _teamLatestResultEventsProvider?.setLatestEventData(
            eventsModel: EventsModel.fromJson(_latestEventsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_teamLatestResultEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_teamLatestResultEventsProvider?.getEventsModel == null) {
        _teamLatestResultEventsProvider?.setLatestEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    _teamLatestResultEventsProvider?.clearData();
  }

  void initializeTeamLatestResultsEventsProvider({required BuildContext context}) {
    _teamLatestResultEventsProvider =
        Provider.of<TeamLatestResultEventsProvider>(context, listen: false);
  }
}

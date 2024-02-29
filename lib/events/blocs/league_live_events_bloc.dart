import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class LeagueLiveEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _liveEventsResponse;
  LeagueLiveEventsProvider? _leagueLiveEventsProvider;

  Future<void> leagueLiveEventsBlocMethod(
      {required BuildContext context,
      String? apiTimeStamp,
      String? leagueId}) async {
    _leagueLiveEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"l": leagueId ?? "0"};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.LIVE_SCORE_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _leagueLiveEventsResponseMethod(apiTimeStamp: apiTimeStamp);
    };
    log("Response ha:${_response?.statusCode}");

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    //print("post request");
    _response = await Network().getRequest(
        baseUrl: NetworkStrings.SPORTS_DB_LIVE_EVENTS_API_BASE_URL,
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

  void _leagueLiveEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _liveEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_liveEventsResponse != null &&
          _leagueLiveEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("League Live Events Response:${_liveEventsResponse}");
        _leagueLiveEventsProvider?.setLiveEventData(
            eventsModel: EventsModel.fromJson(_liveEventsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_leagueLiveEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_leagueLiveEventsProvider?.getEventsModel == null) {
        _leagueLiveEventsProvider?.setLiveEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    print("Clear Data");
    _leagueLiveEventsProvider?.clearData();
  }

  void initializeLeagueLiveEventsProvider({required BuildContext context}) {
    _leagueLiveEventsProvider =
        Provider.of<LeagueLiveEventsProvider>(context, listen: false);
  }
}

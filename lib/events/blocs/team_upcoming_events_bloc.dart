import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class TeamUpcomingEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _upcomingEventsResponse;
  TeamUpcomingEventsProvider? _teamUpcomingEventsProvider;

  Future<void> teamUpComingEventsBlocMethod(
      {required BuildContext context,
        String? apiTimeStamp,
        String? teamId}) async {
    _teamUpcomingEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": teamId ?? "0"};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.TEAM_UPCOMING_EVENTS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _teamUpComingEventsResponseMethod(apiTimeStamp: apiTimeStamp);
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

  void _teamUpComingEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _upcomingEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_upcomingEventsResponse != null &&
          _teamUpcomingEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("League Upcoming Events Response:${_upcomingEventsResponse}");
        _teamUpcomingEventsProvider?.setUpComingEventData(
            eventsModel: EventsModel.fromJson(_upcomingEventsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_teamUpcomingEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_teamUpcomingEventsProvider?.getEventsModel == null) {
        _teamUpcomingEventsProvider?.setUpComingEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    _teamUpcomingEventsProvider?.clearData();
  }

  void initializeTeamUpcomingEventsProvider({required BuildContext context}) {
    _teamUpcomingEventsProvider =
        Provider.of<TeamUpcomingEventsProvider>(context, listen: false);
  }
}

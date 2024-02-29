import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/teams/provider/team_members_provider.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class LeagueUpcomingEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _upcomingEventsResponse;
  LeagueUpcomingEventsProvider? _leagueUpcomingEventsProvider;

  Future<void> leagueUpComingEventsBlocMethod(
      {required BuildContext context,
      String? apiTimeStamp,
      String? leagueId}) async {
    _leagueUpcomingEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": leagueId ?? "0"};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.LEAGUE_UPCOMING_EVENTS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _leagueUpComingEventsResponseMethod(apiTimeStamp: apiTimeStamp);
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

  void _leagueUpComingEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _upcomingEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_upcomingEventsResponse != null &&
          _leagueUpcomingEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("League Upcoming Events Response:${_upcomingEventsResponse}");
        _leagueUpcomingEventsProvider?.setUpComingEventData(
            eventsModel: EventsModel.fromJson(_upcomingEventsResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_leagueUpcomingEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_leagueUpcomingEventsProvider?.getEventsModel == null) {
        _leagueUpcomingEventsProvider?.setUpComingEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    print("Clearv Data");
    _leagueUpcomingEventsProvider?.clearData();
  }

  void initializeLeagueUpcomingEventsProvider({required BuildContext context}) {
    _leagueUpcomingEventsProvider =
        Provider.of<LeagueUpcomingEventsProvider>(context, listen: false);
  }
}

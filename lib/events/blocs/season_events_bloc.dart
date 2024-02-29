import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class SeasonEventsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _seasonEventsResponse;
  SeasonEventsProvider? _seasonEventsProvider;
  EventsModel? _eventsModel;

  Future<void> seasonEventsBlocMethod(
      {required BuildContext context,
      String? apiTimeStamp,
      String? seasonId,
      String? seasonYear}) async {
    _seasonEventsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": seasonId, "s": seasonYear};

    _onFailure = () {
      log("fail ha:${_response}");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.SEASON_EVENTS_ENDPOINT);

    _onSuccess = () {
      //log("success ha:${_response}");
      _seasonEventsResponseMethod(apiTimeStamp: apiTimeStamp);
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
        isErrorToast: true,
       connectTimeOut: 25000);
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

  void _seasonEventsResponseMethod({String? apiTimeStamp}) {
    try {
      _seasonEventsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_seasonEventsResponse != null &&
          _seasonEventsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("Seasons Response:${_seasonEventsResponse}");
        _eventsModel = EventsModel.fromJson(_seasonEventsResponse);
        _eventsModel?.events = _eventsModel?.events?.reversed.toList();
        _seasonEventsProvider?.setEventData(eventsModel: _eventsModel);
      }
    } catch (error) {
      //log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_seasonEventsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_seasonEventsProvider?.getEventsModel == null) {
        _seasonEventsProvider?.setEventData(eventsModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    _seasonEventsProvider?.clearData();
  }

  void initializeSeasonEventsProvider({required BuildContext context}) {
    _seasonEventsProvider =
        Provider.of<SeasonEventsProvider>(context, listen: false);
  }
}

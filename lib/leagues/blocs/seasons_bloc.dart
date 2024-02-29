import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/models/seasons_model.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class SeasonsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _seasonsResponse;
  StreamController<SeasonsModel?> _seasonsEvent =
      StreamController<SeasonsModel?>();
  SeasonsModel? _seasonsModel;
  ValueChanged<SeasonsModel?>? _successSeasonData;

  //////////////////////////Seasons Bloc Method //////////////////////////////////
  Future seasonsBlocMethod(
      {int? leagueId, ValueChanged<SeasonsModel?>? successSeasonData}) async {
    _successSeasonData = successSeasonData;

    _queryParameters = {"id": leagueId ?? 0};

    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(endPoint: NetworkStrings.SEASON_ENDPOINT);

    _onSuccess = () {
      _seasonsResponseMethod();
    };

    _validateResponse();

    return _response;
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
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

  void _seasonsResponseMethod() {
    try {
      _seasonsResponse = _response?.data;
      if (!_seasonsEvent.isClosed) {
        if (_seasonsResponse != null) {
          //log("Seasons Response:${_seasonsResponse}");
          _seasonsModel = SeasonsModel.fromJson(_seasonsResponse);
          _seasonsModel?.seasons = _seasonsModel?.seasons?.reversed.toList();
          _seasonsEvent.add(_seasonsModel);
          _successSeasonData!= null ? _successSeasonData!(_seasonsModel) : null;
        } else {
          _setStreamNull();
        }
      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setStreamNull();
    }
  }

  void _setStreamNull() {
    if (!_seasonsEvent.isClosed) {
      if (_seasonsModel == null) {
        _seasonsEvent.add(null);

        _successSeasonData!= null ? _successSeasonData!(null) : null;
      }
    }
  }

  Stream<SeasonsModel?>? getSeasons() {
    if (!_seasonsEvent.isClosed) {
      return _seasonsEvent.stream;
    }
  }

  void cancelStream() {
    _seasonsEvent.close();
  }
}

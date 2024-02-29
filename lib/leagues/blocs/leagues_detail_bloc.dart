import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/models/leagues_detail_model.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class LeaguesDetailBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _leaguesDetailResponse;
  StreamController<LeaguesDetailModel?> _leaguesDetailEvent =
      StreamController<LeaguesDetailModel?>();
  LeaguesDetailModel? _leaguesDetailModel;

  //////////////////////////Leagues Detail Bloc Method //////////////////////////////////
  Future leaguesDetailBlocMethod({int? leagueId}) async {

    _queryParameters = {"id": leagueId};


    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(endPoint: NetworkStrings.LEAGUES_DETAIL_ENDPOINT);

    _onSuccess = () {
      _leaguesDetailResponseMethod();
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
        isToast: false);
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

  void _leaguesDetailResponseMethod() {
    try {
      _leaguesDetailResponse = _response?.data;
      if (!_leaguesDetailEvent.isClosed) {
        if (_leaguesDetailResponse != null) {
         // log("Leagues Detail Response:${_leaguesDetailResponse}");
          _leaguesDetailModel =
              LeaguesDetailModel.fromJson(_leaguesDetailResponse);
          _leaguesDetailEvent.add(_leaguesDetailModel);
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
    if (!_leaguesDetailEvent.isClosed) {
      if (_leaguesDetailModel == null) {
        _leaguesDetailEvent.add(null);
      }
    }
  }

  Stream<LeaguesDetailModel?>? getLeaguesDetail() {
    if (!_leaguesDetailEvent.isClosed) {
      return _leaguesDetailEvent.stream;
    }
  }

  void cancelStream() {
    _leaguesDetailEvent.close();
  }
}

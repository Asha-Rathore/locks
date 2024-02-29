import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/models/leagues_detail_model.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class TeamsDetailBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _teamsDetailResponse;
  StreamController<TeamsModelTeams?> _teamsDetailEvent =
      StreamController<TeamsModelTeams?>();
  TeamsModelTeams? _teamsDetailModel;

  //////////////////////////Leagues Detail Bloc Method //////////////////////////////////
  Future teamsDetailBlocMethod({String? teamId}) async {
    _queryParameters = {"id": teamId};

    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(endPoint: NetworkStrings.TEAMS_DETAIL_ENDPOINT);

    _onSuccess = () {
      _teamsDetailResponseMethod();
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

  void _teamsDetailResponseMethod() {
    try {
      _teamsDetailResponse = _response?.data;
      if (!_teamsDetailEvent.isClosed) {
        if (_teamsDetailResponse != null) {
          //log("Teams Detail Response:${_teamsDetailResponse}");
          _teamsDetailModel =
              TeamsModelTeams.fromJson(_teamsDetailResponse["teams"]?[0]);
          _teamsDetailEvent.add(_teamsDetailModel);
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
    if (!_teamsDetailEvent.isClosed) {
      if (_teamsDetailModel == null) {
        _teamsDetailEvent.add(null);
      }
    }
  }

  Stream<TeamsModelTeams?>? getTeamsDetail() {
    if (!_teamsDetailEvent.isClosed) {
      return _teamsDetailEvent.stream;
    }
  }

  void cancelStream() {
    _teamsDetailEvent.close();
  }
}

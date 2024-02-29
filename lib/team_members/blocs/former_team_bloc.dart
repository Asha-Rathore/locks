import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/models/leagues_detail_model.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/team_members/models/former_team_model.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class FormerTeamBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _formerTeamResponse;
  StreamController<FormerTeamModel?> _formerTeamEvent =
      StreamController<FormerTeamModel?>();
  FormerTeamModel? _formerTeamModel;

  //////////////////////////Former Detail Bloc Method //////////////////////////////////
  Future formerTeamBlocMethod({String? playerId}) async {
    _queryParameters = {"id": playerId};

    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(endPoint: NetworkStrings.FORMER_TEAM_ENDPOINT);

    _onSuccess = () {
      _formerTeamResponseMethod();
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

  void _formerTeamResponseMethod() {
    try {
      _formerTeamResponse = _response?.data;
      if (!_formerTeamEvent.isClosed) {
        if (_formerTeamResponse != null) {
          // log("Leagues Detail Response:${_leaguesDetailResponse}");
          _formerTeamModel = FormerTeamModel.fromJson(_formerTeamResponse);
          _formerTeamEvent.add(_formerTeamModel);
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
    if (!_formerTeamEvent.isClosed) {
      if (_formerTeamModel == null) {
        _formerTeamEvent.add(null);
      }
    }
  }

  Stream<FormerTeamModel?>? getFormerTeam() {
    if (!_formerTeamEvent.isClosed) {
      return _formerTeamEvent.stream;
    }
  }

  void cancelStream() {
    _formerTeamEvent.close();
  }
}

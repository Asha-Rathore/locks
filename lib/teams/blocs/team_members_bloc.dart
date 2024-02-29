import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/teams/provider/team_members_provider.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class TeamMembersBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _teamMembersResponse;
  TeamMembersProvider? _teamMembersProvider;

  Future<void> teamMembersBlocMethod(
      {required BuildContext context,
      String? apiTimeStamp,
      String? teamId}) async {
    _teamMembersProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": teamId};

    _onFailure = () {
      log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.TEAM_MEMBERS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _teamMembersResponseMethod(apiTimeStamp: apiTimeStamp);
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

  void _teamMembersResponseMethod({String? apiTimeStamp}) {
    try {
      _teamMembersResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_teamMembersResponse != null &&
          _teamMembersProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("Team Members Response:${_teamMembersResponse}");
        _teamMembersProvider?.setTeamMembersData(
            teamMembersModel: TeamMembersModel.fromJson(_teamMembersResponse));
      }
    } catch (error) {
      log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_teamMembersProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_teamMembersProvider?.getTeamMembersModel == null) {
        _teamMembersProvider?.setTeamMembersData(teamMembersModel: null);
      }
    }
  }

  void clearData({required BuildContext context}) {
    _teamMembersProvider?.clearData();
  }

  void initializeTeamMembersProvider({required BuildContext context}) {
    _teamMembersProvider =
        Provider.of<TeamMembersProvider>(context, listen: false);
  }
}

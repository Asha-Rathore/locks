import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/home/provider/news_provider.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/team_members/models/honours_model.dart';
import 'package:locks_hybrid/team_members/models/milestones_model.dart';
import 'package:locks_hybrid/team_members/provider/honours_provider.dart';
import 'package:locks_hybrid/team_members/provider/milestones_provider.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class MilestonesBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _milestonesResponse;
  MilestonesProvider? _milestonesProvider;

  Future<void> milestonesBlocMethod(
      {required BuildContext context,
      String? playerId,
      String? apiTimeStamp,
      String? endPoint}) async {
    _milestonesProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);
    _queryParameters = {"id": playerId};

    _onFailure = () {
      //log("fail ha");

      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: NetworkStrings.CAREER_MILESTONES_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _milestonesResponseMethod(apiTimeStamp: apiTimeStamp);
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
        isHeaderRequire: true,
        isToast: false,
        isErrorToast: true,
        connectTimeOut: 20000);
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

  void _milestonesResponseMethod({String? apiTimeStamp}) {
    try {
      _milestonesResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_milestonesResponse != null &&
          _milestonesProvider?.getApiTimeStamp == apiTimeStamp) {
        log("Milestones Response:${_milestonesResponse}");
        _milestonesProvider?.setMilestonesData(
            milestonesModel: MilestonesModel.fromJson(_milestonesResponse));
      }
    } catch (error) {
      //log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_milestonesProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      _milestonesProvider?.setMilestonesData(milestonesModel: null);
    }
  }

  void clearData({required BuildContext context}) {
    _milestonesProvider?.clearData();
  }

  void initializeMilestonesProvider({required BuildContext context}) {
    _milestonesProvider =
        Provider.of<MilestonesProvider>(context, listen: false);
  }
}

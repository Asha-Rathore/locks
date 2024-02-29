import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/notifications/model/notification_model.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/team_members/models/former_team_model.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class NotificationBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _notificationResponse;
  StreamController<NotificationModel?> _notificationEvent =
      StreamController<NotificationModel?>();
  NotificationModel? _notificationModel;

  //////////////////////////Notification Bloc Method //////////////////////////////////
  Future notificationBlocMethod() async {
    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(endPoint: NetworkStrings.NOTIFICATION_ENDPOINT);

    _onSuccess = () {
      _notificationResponseMethod();
    };

    _validateResponse();

    return _response;
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    _response = await Network().getRequest(
      baseUrl: NetworkStrings.API_BASE_URL,
        endPoint: endPoint,
        onFailure: _onFailure,
        isHeaderRequire: true,
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

  void _notificationResponseMethod() {
    try {
      _notificationResponse = _response?.data;
      if (!_notificationEvent.isClosed) {
        if (_notificationResponse != null) {
          // log("Leagues Detail Response:${_leaguesDetailResponse}");
          _notificationModel =
              NotificationModel.fromJson(_notificationResponse);
          _notificationEvent.add(_notificationModel);
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
    if (!_notificationEvent.isClosed) {
      if (_notificationModel == null) {
        _notificationEvent.add(null);
      }
    }
  }

  Stream<NotificationModel?>? getNotification() {
    if (!_notificationEvent.isClosed) {
      return _notificationEvent.stream;
    }
  }

  void cancelStream() {
    _notificationEvent.close();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

class ContentBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess;
  dynamic contentTypeResponse;

  ////////////////////////// Content //////////////////////////////////
  Future content({required BuildContext context, String? contentType}) async {
    _queryParameters = {"type": contentType};

    await _getRequest(
      endPoint: NetworkStrings.CONTENT_ENDPOINT,
    );

    _onSuccess = () {
      contentTypeResponse = _response?.data;
    };
    _validateResponse();

    return contentTypeResponse;
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint}) async {
    _response = await Network().getRequest(
        baseUrl: NetworkStrings.API_BASE_URL,
        endPoint: endPoint,
        queryParameters: _queryParameters,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, isToast: false);
    }
  }
}

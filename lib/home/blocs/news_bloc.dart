import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/home/provider/news_provider.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/services/network.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:provider/provider.dart';

class NewsBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _newsResponse;
  NewsProvider? _newsProvider;

  Future<void> newsBlocMethod(
      {required BuildContext context,
      String? leagueAbbreviation,
      String? apiTimeStamp,
      String? endPoint}) async {
    _newsProvider?.setApiTimeStamp(apiTimeStamp: apiTimeStamp);

    _onFailure = () {
      //log("fail ha");
      _setDataNull(apiTimeStamp: apiTimeStamp);
    };

    await _getRequest(endPoint: endPoint ?? NetworkStrings.ERROR_NEWS_ENDPOINT);

    _onSuccess = () {
      //log("success ha");
      _newsResponseMethod(apiTimeStamp: apiTimeStamp);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint, bool? isToast}) async {
    //print("post request");
    _response = await Network().getRequest(
        baseUrl: NetworkStrings.NEWS_API_BASE_URL,
        endPoint: endPoint,
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

  void _newsResponseMethod({String? apiTimeStamp}) {
    try {
      _newsResponse = _response?.data;

      //log("recent api:${_recentSearchesProvider?.getApiTimeStamp}");
      if (_newsResponse != null &&
          _newsProvider?.getApiTimeStamp == apiTimeStamp) {
        //log("News Response:${_newsResponse}");
        _newsProvider?.setNewsData(
            newsModel: NewsModel.fromJson(_newsResponse));
      }
    } catch (error) {
      //log("Upcoming :${error}");
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull(apiTimeStamp: apiTimeStamp);
    }
  }

  void _setDataNull({String? apiTimeStamp}) {
    if (_newsProvider?.getApiTimeStamp == apiTimeStamp) {
      //for refresh indicator we set if condition otherwise no need of if condition
      if (_newsProvider?.getNewsModel == null) {
        _newsProvider?.setNewsData(newsModel: null);
      }
    }
  }

  void searchNewsMethod({String? searchText}) {
    _newsProvider?.searchNewsMethod(searchText: searchText);
  }

  void setSearchTextNull({String? searchText}) {
    _newsProvider?.setSearchTextNull();
  }

  void clearData({required BuildContext context}) {
    _newsProvider?.clearData();
  }

  void initializeNewsProvider({required BuildContext context}) {
    _newsProvider = Provider.of<NewsProvider>(context, listen: false);
  }
}

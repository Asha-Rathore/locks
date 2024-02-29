import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/extension.dart';

class NewsProvider with ChangeNotifier {
  NewsModel? _mainNewsModel, _newsModel, _searchNewsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp, _searchText;

////////////////getters//////////////////

  NewsModel? get getMainNewsModel => _mainNewsModel;

  NewsModel? get getNewsModel => _newsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setNewsData({NewsModel? newsModel}) {
    if ((newsModel?.articles?.length ?? 0) > 0) {
      _mainNewsModel = newsModel;
      _newsModel = newsModel;
      searchNewsMethod(searchText: _searchText);
    } else {
      _newsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void searchNewsMethod({String? searchText}) {
    try {
      _searchText = searchText?.toLowerCase();

      if (_newsModel != null) {
        if (_searchText.checkNullEmptyText == true) {
          _searchNewsModel = NewsModel.fromJson(_newsModel?.toJson() ?? {});
          _searchNewsModel?.articles = _searchNewsModel?.articles
              ?.where((newsData) =>
                  (newsData?.headline
                          ?.toLowerCase()
                          .contains(_searchText ?? "") ??
                      false) ||
                  (newsData?.description
                          ?.toLowerCase()
                          .contains(_searchText ?? "") ??
                      false))
              .toList();

          _mainNewsModel = _searchNewsModel;
        } else {
          _searchNewsModel = null;
          _mainNewsModel = _newsModel;
        }
      }
    } catch (error) {
      //AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
    notifyListeners();
  }

  void setSearchTextNull() {
    _searchText = null;
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _newsModel = null;
    _mainNewsModel = null;
    _searchNewsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

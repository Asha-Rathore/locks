import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';

class LeaguesProvider with ChangeNotifier {
  LeaguesModel? _leaguesModel;
  LeaguesModelData? _singleLeagueData;
  bool _waitingStatus = true;
  bool? _errorLeagueData;
  String? _apiTimeStamp;

////////////////getters//////////////////

  LeaguesModel? get getLeaguesModel => _leaguesModel;

  LeaguesModelData? get getSingleLeagueData => _singleLeagueData;

  bool? get getWaitingStatus => _waitingStatus;

  bool? get getErrorLeagueData => _errorLeagueData;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setLeaguesData({LeaguesModel? leaguesModel}) {
    if ((leaguesModel?.data?.length ?? 0) > 0) {
      _leaguesModel = leaguesModel;
      _errorLeagueData = false;
    } else {
      _leaguesModel = null;
      _errorLeagueData = true;
    }
    _waitingStatus = false;
    notifyListeners();
  }


  void setSingleLeaguesData({LeaguesModelData? singleLeagueData}) {
    if (singleLeagueData != null) {
      _singleLeagueData = singleLeagueData;
          _errorLeagueData = false;
    } else {
      _singleLeagueData = null;
      _errorLeagueData = true;
    }
    notifyListeners();
  }


  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _leaguesModel = null;
    _singleLeagueData = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    _errorLeagueData = null;
    //log("Clear data");
  }
}

import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/team_standings/models/Team_Standings_Model.dart';

class TeamStandingsProvider with ChangeNotifier {
  TeamStandingsModel? _teamStandingsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  TeamStandingsModel? get getTeamStandingsModel => _teamStandingsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setTeamStandingsData({TeamStandingsModel? teamStandingsModel}) {
    if ((teamStandingsModel?.data?.length ?? 0) > 0) {
      _teamStandingsModel = teamStandingsModel;
    } else {
      _teamStandingsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _teamStandingsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }

  void clearDataRebuild() {
    _teamStandingsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    notifyListeners();
    //log("Clear data");
  }
}

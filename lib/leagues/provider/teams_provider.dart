import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';

class TeamsProvider with ChangeNotifier {
  TeamsModel? _teamsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  TeamsModel? get getTeamsModel => _teamsModel;


  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setTeamsData({TeamsModel? teamsModel}) {
    if ((teamsModel?.teams?.length ?? 0) > 0) {
      _teamsModel = teamsModel;
    } else {
      _teamsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }



  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _teamsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

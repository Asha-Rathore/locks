import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';

class TeamMembersProvider with ChangeNotifier {
  TeamMembersModel? _teamMembersModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  TeamMembersModel? get getTeamMembersModel => _teamMembersModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setTeamMembersData({TeamMembersModel? teamMembersModel}) {
    if ((teamMembersModel?.player?.length ?? 0) > 0) {
      _teamMembersModel = teamMembersModel;
    } else {
      _teamMembersModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _teamMembersModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

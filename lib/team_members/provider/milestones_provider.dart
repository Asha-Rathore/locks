import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/team_members/models/honours_model.dart';
import 'package:locks_hybrid/team_members/models/milestones_model.dart';

class MilestonesProvider with ChangeNotifier {
  MilestonesModel? _milestonesModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  MilestonesModel? get getMilestonesModel => _milestonesModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setMilestonesData({MilestonesModel? milestonesModel}) {
    if ((milestonesModel?.milestones?.length ?? 0) > 0) {
      _milestonesModel = milestonesModel;
    } else {
      _milestonesModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _milestonesModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

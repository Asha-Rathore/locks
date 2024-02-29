import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/team_members/models/honours_model.dart';

class HonoursProvider with ChangeNotifier {
  HonoursModel? _honoursModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  HonoursModel? get getHonoursModel => _honoursModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setHonoursData({HonoursModel? honoursModel}) {
    if ((honoursModel?.honours?.length ?? 0) > 0) {
      _honoursModel = honoursModel;
    } else {
      _honoursModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _honoursModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

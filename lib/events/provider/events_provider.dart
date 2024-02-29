import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/constants.dart';

/// ------------- League Upcoming Events Provider Start --------------- //
class LeagueUpcomingEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel, _filterEventModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setUpComingEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
      //_filterUpComingEventData();
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void _filterUpComingEventData() {
    _filterEventModel = EventsModel.fromJson(_eventsModel!.toJson());

    _filterEventModel?.events = [];

    for (int i = 0; i < (_eventsModel?.events?.length ?? 0); i++) {
      if (_eventsModel?.events?[i]?.intHomeScore == null &&
          _eventsModel?.events?[i]?.intAwayScore == null)
        _filterEventModel?.events?.add(_eventsModel?.events?[i]);
    }

    _eventsModel = _filterEventModel;
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _filterEventModel = null;
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- League Upcoming Events Provider End --------------- //

/// ------------- League Latest Result Events Provider Start --------------- //
class LeagueLatestResultEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setLatestEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- League Latest Result Events Provider End --------------- ///

/// ------------- Team Upcoming Events Provider Start --------------- ///

class TeamUpcomingEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel, _filterEventModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setUpComingEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
      //_filterUpComingEventData();
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void _filterUpComingEventData() {
    _filterEventModel = EventsModel.fromJson(_eventsModel!.toJson());

    _filterEventModel?.events = [];

    for (int i = 0; i < (_eventsModel?.events?.length ?? 0); i++) {
      if (_eventsModel?.events?[i]?.intHomeScore == null &&
          _eventsModel?.events?[i]?.intAwayScore == null)
        _filterEventModel?.events?.add(_eventsModel?.events?[i]);
    }

    _eventsModel = _filterEventModel;
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _filterEventModel = null;
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- Team Upcoming Events Provider End --------------- //

/// ------------- Team Latest Result Events Provider Start --------------- //
class TeamLatestResultEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setLatestEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- Team Latest Result Events Provider End --------------- ///

/// ------------- Season Events Provider Start --------------- //
class SeasonEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- Season  Events Provider End --------------- ///

/// ------------- League Live Events Provider Start --------------- //
class LeagueLiveEventsProvider with ChangeNotifier {
  EventsModel? _eventsModel, _filterLiveEventModel;
  bool _waitingStatus = true;
  String? _apiTimeStamp;
  String? _currentDate, _eventDate;

////////////////getters//////////////////

  EventsModel? get getEventsModel => _eventsModel;

  bool? get getWaitingStatus => _waitingStatus;

  String? get getApiTimeStamp => _apiTimeStamp;

////////////////setters//////////////////

  void setLiveEventData({EventsModel? eventsModel}) {
    if ((eventsModel?.events?.length ?? 0) > 0) {
      _eventsModel = eventsModel;
      _filterLiveEventData();
    } else {
      _eventsModel = null;
    }
    _waitingStatus = false;
    notifyListeners();
  }

  void _filterLiveEventData() {
    try {
      _filterLiveEventModel = EventsModel.fromJson(_eventsModel!.toJson());
      _filterLiveEventModel?.events = [];

      _currentDate = Constants.formatDateTime(
          parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_YYYY_MM_DD,
          inputDateTime: DateTime.now());

      //print("Current Date:${_currentDate}");

      for (int i = 0; i < (_eventsModel?.events?.length ?? 0); i++) {
        _eventDate = Constants.getLiveEventData(
            eventTimeStamp: _eventsModel?.events?[i]?.strTimestamp);

      //  print("Event Dates:${_eventDate}");

        if (_currentDate == _eventDate) {
          _filterLiveEventModel?.events?.add(_eventsModel?.events?[i]);
        }
      }
      //
       _eventsModel = _filterLiveEventModel;
    } catch (e) {}
  }

  void setApiTimeStamp({String? apiTimeStamp}) {
    _apiTimeStamp = apiTimeStamp;
  }

  void clearData() {
    _filterLiveEventModel = null;
    _eventsModel = null;
    _waitingStatus = true;
    _apiTimeStamp = null;
    //log("Clear data");
  }
}

/// ------------- League Live Events Provider End --------------- //

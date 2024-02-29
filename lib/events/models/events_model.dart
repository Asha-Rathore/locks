class EventsModelEvents {
  String? idEvent;
  String? strEvent;
  String? strSport;
  String? strSeason;
  String? strHomeTeam;
  String? strAwayTeam;
  String? intHomeScore;
  String? intAwayScore;
  String? dateEvent;
  String? strTime;
  String? strTimestamp;
  String? idHomeTeam;
  String? idAwayTeam;
  String? strVenue;
  String? strCountry;
  String? strCity;

  EventsModelEvents({
    this.idEvent,
    this.strEvent,
    this.strSport,
    this.strSeason,
    this.strHomeTeam,
    this.strAwayTeam,
    this.intHomeScore,
    this.intAwayScore,
    this.dateEvent,
    this.strTime,
    this.strTimestamp,
    this.idHomeTeam,
    this.idAwayTeam,
    this.strVenue,
    this.strCountry,
    this.strCity,
  });

  EventsModelEvents.fromJson(Map<String, dynamic> json) {
    idEvent = json['idEvent']?.toString();
    strEvent = json['strEvent']?.toString();
    strSport = json['strSport']?.toString();
    strSeason = json['strSeason']?.toString();
    strHomeTeam = json['strHomeTeam']?.toString();
    strAwayTeam = json['strAwayTeam']?.toString();
    intHomeScore = json['intHomeScore']?.toString();
    intAwayScore = json['intAwayScore']?.toString();
    dateEvent = json['dateEvent']?.toString() ?? "0000-00-00";
    strTime = json['strEventTime'] != null
        ? json['strEventTime']?.toString()
        : (json['strTime']?.toString() ?? "00:00:00");
    strTimestamp = dateEvent! + "T" + strTime!;
    idHomeTeam = json['idHomeTeam']?.toString();
    idAwayTeam = json['idAwayTeam']?.toString();
    strVenue = json['strVenue']?.toString();
    strCountry = json['strCountry']?.toString();
    strCity = json['strCity']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idEvent'] = idEvent;
    data['strEvent'] = strEvent;
    data['strSport'] = strSport;
    data['strSeason'] = strSeason;
    data['strHomeTeam'] = strHomeTeam;
    data['strAwayTeam'] = strAwayTeam;
    data['intHomeScore'] = intHomeScore;
    data['intAwayScore'] = intAwayScore;
    data['dateEvent'] = dateEvent;
    data['strTime'] = strTime;
    data['strTimestamp'] = strTimestamp;
    data['idHomeTeam'] = idHomeTeam;
    data['idAwayTeam'] = idAwayTeam;
    data['strVenue'] = strVenue;
    data['strCountry'] = strCountry;
    data['strCity'] = strCity;
    return data;
  }
}

class EventsModel {
/*
{
  "events": [
    {
      "idEvent": "1906652",
      "strEvent": "San Antonio Spurs vs Houston Rockets",
      "strSport": "Basketball",
      "strSeason": "2023-2024",
      "strHomeTeam": "San Antonio Spurs",
      "strAwayTeam": "Houston Rockets",
      "intHomeScore": "89",
      "intAwayScore": "99",
      "strTimestamp": "2023-10-17T00:00:00",
      "idHomeTeam": "134879",
      "idAwayTeam": "134876",
      "strVenue": "",
      "strCountry": "USA",
      "strCity": ""
    }
  ]
}
*/

  List<EventsModelEvents?>? events;

  EventsModel({
    this.events,
  });

  EventsModel.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      final v = json['events'];
      final arr0 = <EventsModelEvents>[];
      v.forEach((v) {
        arr0.add(EventsModelEvents.fromJson(v));
      });
      events = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (events != null) {
      final v = events;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['events'] = arr0;
    }
    return data;
  }
}

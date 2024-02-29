import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:locks_hybrid/leagues/blocs/leagues_bloc.dart';
import 'package:locks_hybrid/leagues/blocs/teams_bloc.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/team_standings/blocs/team_standings_bloc.dart';
import 'package:locks_hybrid/team_standings/models/MLB_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/models/MLS_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/models/NBA_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/models/NFL_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/models/NHL_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/models/Team_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/provider/team_standings_provider.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';

class TeamStandingsService {
  dynamic _commonStandingsModel;

  List _conferenceList = [];

  dynamic _teamStandingsResponse = {"data": []};
  TeamStandingsProvider? _teamStandingsProvider;
  TeamStandingsModel? _teamStandingsModel;
  TeamStandingsModelDataConferenceData? _firstConferenceObject;

  //Set Response in Model
  void setTeamStandingsCommonModel(
      {String? standingsType,
      dynamic standingsResponse,
      String? apiTimeStamp}) {
    try {
      _conferenceList = [];
      _teamStandingsResponse = {"data": []};

      _teamStandingsProvider = Provider.of<TeamStandingsProvider>(
          StaticData.navigatorKey.currentContext!,
          listen: false);

      //for NHL Response
      if (standingsType == LeagueType.NHL.name) {
        _commonStandingsModel =
            NHLStandingsModel.fromJson({"data": standingsResponse});
      }
      //for NFL Response
      else if (standingsType == LeagueType.NFL.name) {
        _commonStandingsModel =
            NFLStandingsModel.fromJson({"data": standingsResponse});
      }
      //for NBA Response
      else if (standingsType == LeagueType.NBA.name) {
        _commonStandingsModel =
            NBAStandingsModel.fromJson({"data": standingsResponse});
      }
      //for MLB Response
      else if (standingsType == LeagueType.MLB.name) {
        _commonStandingsModel =
            MLBStandingsModel.fromJson({"data": standingsResponse});
      }
      //for MLB Response
      else if (standingsType == LeagueType.MLS.name) {
        //print("Standings Response:${standingsResponse[0]["Standings"]}");

        _commonStandingsModel = MLSStandingsModel.fromJson(
            {"data": standingsResponse[0]["Standings"]});
      }
      _filterStandingsConferenceData(standingsType: standingsType);
    } catch (e) {
      print("Error:${e}");
      _teamStandingsProvider?.setTeamStandingsData(teamStandingsModel: null);
    }
  }

  //This will filter standings conference
  void _filterStandingsConferenceData({String? standingsType}) {
    for (int i = 0; i < (_commonStandingsModel?.data?.length ?? 0); i++) {
      if (!(_conferenceList
          .contains(_commonStandingsModel?.data?[i]?.Conference))) {
        _conferenceList.add(_commonStandingsModel?.data?[i]?.Conference);
        _addConferenceName(
            standingsType: standingsType,
            conferenceName: _commonStandingsModel?.data?[i]?.Conference);
      }
    }

    //log("Conference Team Standings Response:${_teamStandingsResponse}");

    _setTeamStandingsData(standingsType: standingsType);

    //_filterStandingsDivisionData();
  }

  void _addConferenceName({String? standingsType, String? conferenceName}) {
    //ADD NHL FIRST DATA
    if (standingsType == LeagueType.NHL.name) {
      _teamStandingsResponse["data"].add({
        "conference_name": conferenceName,
        "conference_id": (_teamStandingsResponse["data"]?.length ?? 0),
        "conference_data": [
          {
            "team_rank": "R",
            "team_name": "Teams",
            "division_name": "Division Name",
            AppStrings.FIELD_ONE_KEY: "GP",
            AppStrings.FIELD_TWO_KEY: "W",
            AppStrings.FIELD_THREE_KEY: "L",
            AppStrings.FIELD_FOUR_KEY: "OT",
            AppStrings.FIELD_FIVE_KEY: "PTS"
          } as dynamic
        ],
      });
    }
    //ADD NFL FIRST DATA
    else if (standingsType == LeagueType.NFL.name) {
      _teamStandingsResponse["data"].add({
        "conference_name": conferenceName,
        "conference_id": (_teamStandingsResponse["data"]?.length ?? 0),
        "conference_data": [
          {
            "team_rank": "R",
            "team_name": "Teams",
            "division_name": "Division Name",
            AppStrings.FIELD_ONE_KEY: "W",
            AppStrings.FIELD_TWO_KEY: "L",
            AppStrings.FIELD_THREE_KEY: "T",
            AppStrings.FIELD_FOUR_KEY: "PCT",
            AppStrings.FIELD_FIVE_KEY: "NP"
          } as dynamic
        ],
      });
    }

    //ADD NBA FIRST DATA
    else if (standingsType == LeagueType.NBA.name) {
      _teamStandingsResponse["data"].add({
        "conference_name": conferenceName,
        "conference_id": (_teamStandingsResponse["data"]?.length ?? 0),
        "conference_data": [
          {
            "team_rank": "R",
            "team_name": "Teams",
            "division_name": "Division Name",
            AppStrings.FIELD_ONE_KEY: "W",
            AppStrings.FIELD_TWO_KEY: "L",
            AppStrings.FIELD_THREE_KEY: "GB",
            AppStrings.FIELD_FOUR_KEY: "PCT",
            AppStrings.FIELD_FIVE_KEY: "ST"
          } as dynamic
        ],
      });
    }

    //ADD MLB FIRST DATA
    else if (standingsType == LeagueType.MLB.name) {
      _teamStandingsResponse["data"].add({
        "conference_name": conferenceName,
        "conference_id": (_teamStandingsResponse["data"]?.length ?? 0),
        "conference_data": [
          {
            "team_rank": "R",
            "team_name": "Teams",
            "division_name": "Division Name",
            AppStrings.FIELD_ONE_KEY: "W",
            AppStrings.FIELD_TWO_KEY: "L",
            AppStrings.FIELD_THREE_KEY: "GB",
            AppStrings.FIELD_FOUR_KEY: "PCT",
            AppStrings.FIELD_FIVE_KEY: "ST"
          } as dynamic
        ],
      });
    }
    //ADD MLS FIRST DATA
    else if (standingsType == LeagueType.MLS.name) {
      _teamStandingsResponse["data"].add({
        "conference_name": conferenceName,
        "conference_id": (_teamStandingsResponse["data"]?.length ?? 0),
        "conference_data": [
          {
            "team_rank": "R",
            "team_name": "Teams",
            "division_name": "Division Name",
            AppStrings.FIELD_ONE_KEY: "GP",
            AppStrings.FIELD_TWO_KEY: "W",
            AppStrings.FIELD_THREE_KEY: "L",
            AppStrings.FIELD_FOUR_KEY: "T",
            AppStrings.FIELD_FIVE_KEY: "PTS"
          } as dynamic
        ],
      });
    }
  }

  //set Team Standings Data in Conference()
  void _setTeamStandingsData({String? standingsType}) {
    //try {
    for (int j = 0; j < (_commonStandingsModel?.data?.length ?? 0); j++) {
      for (int k = 0; k < (_teamStandingsResponse["data"]?.length ?? 0); k++) {
        //It sets unique division in that particular conference
        if (_commonStandingsModel?.data?[j]?.Conference ==
            _teamStandingsResponse["data"][k]["conference_name"]) {
          // print(_teamStandingsResponse["data"][k]["conference_data"].length.toString());

          _addConferenceWholeData(
              standingsType: standingsType, mainIndex: j, subIndex: k);

          break;
        }
      }
    }
    // catch (e) {
    //   print("Error:${e}");
    // }

    //log("Division Team Standings Response:${jsonEncode(_teamStandingsResponse)}");

    _sortTeamStandingsData(standingsType: standingsType);
  }

  void _addConferenceWholeData(
      {String? standingsType, required int mainIndex, required int subIndex}) {
    //ADD NHL RECORDS
    if (standingsType == LeagueType.NHL.name) {
      _teamStandingsResponse["data"][subIndex]["conference_data"].add({
        "team_rank": _commonStandingsModel?.data?[mainIndex]?.ConferenceRank,
        "team_name": _commonStandingsModel?.data?[mainIndex]?.Name,
        "division_name": _commonStandingsModel?.data?[mainIndex]?.Division,
        AppStrings.FIELD_ONE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.TotalGamePlayed,
        AppStrings.FIELD_TWO_KEY: _commonStandingsModel?.data?[mainIndex]?.Wins,
        AppStrings.FIELD_THREE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Losses,
        AppStrings.FIELD_FOUR_KEY:
            _commonStandingsModel?.data?[mainIndex]?.OvertimeLosses,
        AppStrings.FIELD_FIVE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.TotalPoints
      });
    }
    //ADD NFL RECORDS
    else if (standingsType == LeagueType.NFL.name) {
      _teamStandingsResponse["data"][subIndex]["conference_data"].add({
        "team_rank": _commonStandingsModel?.data?[mainIndex]?.ConferenceRank,
        "team_name": _commonStandingsModel?.data?[mainIndex]?.Name,
        "division_name": _commonStandingsModel?.data?[mainIndex]?.Division,
        AppStrings.FIELD_ONE_KEY: _commonStandingsModel?.data?[mainIndex]?.Wins,
        AppStrings.FIELD_TWO_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Losses,
        AppStrings.FIELD_THREE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Ties,
        AppStrings.FIELD_FOUR_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Percentage,
        AppStrings.FIELD_FIVE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.NetPoints
      });
    }

    //ADD NBA RECORDS
    else if (standingsType == LeagueType.NBA.name) {
      _teamStandingsResponse["data"][subIndex]["conference_data"].add({
        "team_rank": _commonStandingsModel?.data?[mainIndex]?.ConferenceRank,
        "team_name": _commonStandingsModel?.data?[mainIndex]?.Name,
        "division_name": _commonStandingsModel?.data?[mainIndex]?.Division,
        AppStrings.FIELD_ONE_KEY: _commonStandingsModel?.data?[mainIndex]?.Wins,
        AppStrings.FIELD_TWO_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Losses,
        AppStrings.FIELD_THREE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.GamesBack,
        AppStrings.FIELD_FOUR_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Percentage,
        AppStrings.FIELD_FIVE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.StreakDescription
      });
    }

    //ADD MLB RECORDS
    else if (standingsType == LeagueType.MLB.name) {
      _teamStandingsResponse["data"][subIndex]["conference_data"].add({
        "team_rank": _commonStandingsModel?.data?[mainIndex]?.ConferenceRank,
        "team_name": _commonStandingsModel?.data?[mainIndex]?.Name,
        "division_name": _commonStandingsModel?.data?[mainIndex]?.Division,
        AppStrings.FIELD_ONE_KEY: _commonStandingsModel?.data?[mainIndex]?.Wins,
        AppStrings.FIELD_TWO_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Losses,
        AppStrings.FIELD_THREE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.GamesBehind,
        AppStrings.FIELD_FOUR_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Percentage,
        AppStrings.FIELD_FIVE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Streak
      });
    }

    //ADD MLS RECORDS
    else if (standingsType == LeagueType.MLS.name) {
      _teamStandingsResponse["data"][subIndex]["conference_data"].add({
        "team_rank": _commonStandingsModel?.data?[mainIndex]?.ConferenceRank,
        "team_name": _commonStandingsModel?.data?[mainIndex]?.Name,
        "division_name": "",
        AppStrings.FIELD_ONE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Games,
        AppStrings.FIELD_TWO_KEY: _commonStandingsModel?.data?[mainIndex]?.Wins,
        AppStrings.FIELD_THREE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Losses,
        AppStrings.FIELD_FOUR_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Draws,
        AppStrings.FIELD_FIVE_KEY:
            _commonStandingsModel?.data?[mainIndex]?.Points
      });
    }
  }

  void _sortTeamStandingsData({String? standingsType}) {
    _teamStandingsModel = null;
    _teamStandingsModel = TeamStandingsModel.fromJson(_teamStandingsResponse);

    for (int z = 0; z < (_teamStandingsModel?.data?.length ?? 0); z++) {
      // _teamStandingsModel?.data?[z]?.conferenceData?.sort()

      //Firstly remove first object and save it in temp object because it gives issue in sorting
      _firstConferenceObject =
          _teamStandingsModel!.data![z]!.conferenceData?[0];
      _teamStandingsModel!.data![z]!.conferenceData?.removeAt(0);

      if (standingsType == LeagueType.NBA.name || standingsType == LeagueType.NFL.name) {
        //  print("filed:${_teamStandingsModel?.data?[0]?.conferenceData?[0]?.fieldFour}");
        _teamStandingsModel!.data![z]!.conferenceData!.sort((a, b) =>
            double.parse(b?.fieldFour ?? "0.0")
                .compareTo(double.parse(a?.fieldFour ?? "0.0")));
      } else {
        _teamStandingsModel!.data![z]!.conferenceData!.sort((a, b) =>
            int.parse(a?.teamRank ?? "0")
                .compareTo(int.parse(b?.teamRank ?? "0")));
      }

      //Now after sorting insert first object
      _teamStandingsModel!.data![z]!.conferenceData
          ?.insert(0, _firstConferenceObject);
    }

    //log("Team Sort Data:${_teamStandingsModel?.toJson()}");

    _teamStandingsProvider?.setTeamStandingsData(
        teamStandingsModel: _teamStandingsModel);
  }

// //This will filter standings conference division
// void _filterStandingsDivisionData() {
//   try {
//     for (int j = 0; j < (_commonStandingsModel?.data?.length ?? 0); j++) {
//       if (!(_divisionsList
//           .contains(_commonStandingsModel?.data?[j]?.Division))) {
//
//         //Add Unique Division in List
//         _divisionsList.add(_commonStandingsModel?.data?[j]?.Division);
//
//
//         for (int k = 0; k < (_teamStandingsResponse["data"]?.length ?? 0); k++) {
//           //It sets unique division in that particular conference
//           if (_commonStandingsModel?.data?[j]?.Conference ==
//               _teamStandingsResponse["data"][k]["conference_name"]) {
//             _teamStandingsResponse["data"][k]["conference_data"].add({
//               "division_name": _commonStandingsModel?.data?[j]?.Division,
//               "division_data": [{
//                 "team_rank":"Rank",
//                 "team_name":"Teams",
//                 AppStrings.FIELD_ONE_KEY:"GP",
//                 AppStrings.FIELD_TWO_KEY:"W",
//                 AppStrings.FIELD_THREE_KEY:"L",
//                 AppStrings.FIELD_FOUR_KEY:"OTS",
//                 AppStrings.FIELD_FIVE_KEY:"P"
//               }]
//             });
//             break;
//           }
//         }
//
//         // _conferenceList.add(_commonStandingsModel?.data?[i]?.Conference);
//         // _teamStandingsResponse["data"].add({
//         //   "conference_name":_commonStandingsModel?.data?[i]?.Conference,
//         //   "conference_data":[]
//         // });
//       }
//     }
//
//     log("Division Team Standings Response:${_teamStandingsResponse}");
//   } catch (e) {
//     print("Error:${e}");
//   }
// }
}

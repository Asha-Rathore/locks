import 'dart:developer';
import 'dart:ui';

import 'package:locks_hybrid/leagues/blocs/leagues_bloc.dart';
import 'package:locks_hybrid/leagues/blocs/teams_bloc.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';

class LeaguesService {
  static LeaguesService? _leaguesService;
  static LeaguesBloc? _leaguesBloc;
  static TeamsBloc? _teamsBloc;
  static LeaguesProvider? _leaguesProvider;
  static TeamsProvider? _teamsProvider;

  LeaguesProvider? get getLeaguesProvider => _leaguesProvider;

  TeamsProvider? get getTeamsProvider => _teamsProvider;

  LeaguesService._createInstance();

  factory LeaguesService() {
    // factory with constructor, return some value
    if (_leaguesService == null) {
      _leaguesService = LeaguesService
          ._createInstance(); // This is executed only once, singleton object
      _initializeLeaguesTeamsBloc();
    }
    return _leaguesService!;
  }

  //initializeLeaguesBloc
  static void _initializeLeaguesTeamsBloc() {
    _leaguesBloc ??= LeaguesBloc();
    _teamsBloc ??= TeamsBloc();
    _leaguesProvider = Provider.of<LeaguesProvider>(
        StaticData.navigatorKey.currentContext!,
        listen: false);
    _teamsProvider = Provider.of<TeamsProvider>(
        StaticData.navigatorKey.currentContext!,
        listen: false);
  }

  //Call Leagues Api Method
  Future callLeaguesApiMethod() async {
    //If there is no league data then call league api
    await _leaguesBloc?.leaguesBlocMethod(
        context: StaticData.navigatorKey.currentContext!,
        apiTimeStamp: Constants.getApiTimesTamp());
    // if ((_leaguesProvider?.getLeaguesModel?.data?.length ?? 0) == 0) {
    //   await _leaguesBloc?.leaguesBlocMethod(
    //       context: StaticData.navigatorKey.currentContext!,
    //       apiTimeStamp: Constants.getApiTimesTamp());
    // }

    //If there is leagues data available and teams data not available call this
    if ((_leaguesProvider?.getLeaguesModel?.data?.length ?? 0) > 0 &&
        (_teamsProvider?.getTeamsModel?.teams?.length ?? 0) == 0) {
      await setSingleLeagueData(
          singleLeagueData: _leaguesProvider?.getLeaguesModel?.data![0]);
      //_leaguesModelData?.strLeague
    }
  }

  Future setSingleLeagueData(
      {LeaguesModelData? singleLeagueData,
      VoidCallback? setProgressBar,
      VoidCallback? onFailure,
      VoidCallback? onSuccess,
      bool? isToast}) async{
    await callTeamsApiMethod(
        leagueAbbreviation: singleLeagueData?.strLeague,
        setProgressBar: setProgressBar,
        onFailure: onFailure,
        onSuccess: onSuccess,
        isToast: isToast);
    _leaguesProvider?.setSingleLeaguesData(singleLeagueData: singleLeagueData);
  }

  Future callTeamsApiMethod(
      {String? leagueAbbreviation,
      VoidCallback? setProgressBar,
      VoidCallback? onFailure,
      VoidCallback? onSuccess,
      bool? isToast}) async{
    await _teamsBloc?.teamsBlocMethod(
        context: StaticData.navigatorKey.currentContext!,
        leagueAbbreviation: leagueAbbreviation,
        apiTimeStamp: Constants.getApiTimesTamp(),
        isToast: isToast,
        setProgressBar: setProgressBar,
        onFailure: onFailure,
        onSuccess: onSuccess);
  }




  void clearLeaguesServiceData(){

    _leaguesBloc?.clearData();
    _teamsBloc?.clearData();


    callLeaguesApiMethod();
  }

}

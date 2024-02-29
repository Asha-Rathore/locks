import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/events/blocs/league_latest_result_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/league_live_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/league_upcoming_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/season_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/team_latest_result_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/team_upcoming_events_bloc.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_events_container.dart';
import 'package:locks_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  String? eventType, id, seasonYear;
  final bool? showButton;

  EventListScreen({this.eventType, this.id, this.seasonYear, this.showButton});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  dynamic _eventsProvider;
  bool? _isWaiting = true;
  EventsModel? _eventsModel;
  String? _sportsName;
  LeagueUpcomingEventsBloc _leagueUpcomingEventsBloc =
      LeagueUpcomingEventsBloc();
  LeagueLatestResultEventsBloc _leagueLatestResultEventsBloc =
      LeagueLatestResultEventsBloc();
  TeamUpcomingEventsBloc _teamUpcomingEventsBloc = TeamUpcomingEventsBloc();
  TeamLatestResultEventsBloc _teamLatestResultEventsBloc =
      TeamLatestResultEventsBloc();
  SeasonEventsBloc _seasonEventsBloc = SeasonEventsBloc();
  LeagueLiveEventsBloc _leagueLiveEventsBloc = LeagueLiveEventsBloc();
  Timer? _liveEventTimer;
  LeaguesProvider? _leaguesProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Event Type:${widget.eventType}");
    print("Event Id:${widget.id}");
    print("Season date:${widget.seasonYear}");

    _initializeLeagueProvider();
    _callLiveLeagueSeasonEventsApiMethod();
    _initialzeLiveEventsTimer();
  }

  @override
  Widget build(BuildContext context) {
    _initializeEventsProvider();

    return CustomAppBackground(
      title: AppStrings.EVENTS_TITLE_LIST[widget.eventType],
      child: _eventsWaitingListWidget(),
    );
  }

  Widget _eventsWaitingListWidget() {
    return _isWaiting == true
        ? _eventsShimmerListWidget()
        : _eventRefreshIndicatorWidget();
  }

  Widget _eventRefreshIndicatorWidget() {
    return CustomRefreshIndicatorWidget(
        onRefresh: () async {
          await _apiForRefreshIndicator();
        },
        child: (_eventsModel?.events?.length ?? 0) > 0
            ? _eventsListWidget(eventObject: _eventsModel?.events)
            : Container(
                width: 1.sw,
                height: 1.sh,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 0.3.sh),
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: CustomErrorWidget(
                    errorImagePath: AssetPath.EVENT_ICON,
                    errorText: AppStrings.EVENTS_ERROR_LIST[widget.eventType],
                    imageColor: AppColors.THEME_COLOR_WHITE,
                    imageSize: 60.h,
                  ),
                ),
              ));
  }

  Widget _eventsListWidget({List<EventsModelEvents?>? eventObject}) {
    return ListView.builder(
      itemCount: eventObject?.length ?? 0,
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemBuilder: ((context, index) {
        return _eventWidget(eventData: eventObject?[index]);
      }),
    );
  }

  Widget _eventWidget({EventsModelEvents? eventData}) {
    return CustomEventsContainer(
      showBoxShadow: false,
      showButton: widget.showButton == true ? true : false,
      showScore: Constants.showScore(
          homeScore: eventData?.intHomeScore,
          awayScore: eventData?.intAwayScore),
      eventDay: Constants.getEventDay(eventTimeStamp: eventData?.strTimestamp),
      eventDate:
          Constants.getEventDate(eventTimeStamp: eventData?.strTimestamp),
      eventStadiumPlace: Constants.getEventLocation(
          eventVenue: eventData?.strVenue,
          eventCity: eventData?.strCity,
          eventCountry: eventData?.strCountry),
      firstTeamName: eventData?.strHomeTeam,
      secondTeamName: eventData?.strAwayTeam,
      eventTime:
          Constants.getEventTime(eventTimeStamp: eventData?.strTimestamp),
      gameTitle: _sportsName,
      firstTeamScore: eventData?.intHomeScore,
      secondTeamScore: eventData?.intAwayScore,
      firstTeamLogo: Constants.getTeamImage(teamName: eventData?.strHomeTeam),
      secondTeamLogo: Constants.getTeamImage(teamName: eventData?.strAwayTeam),
      shimmerEnable: false,
      onFirstTeamTap: () {
        _teamNavigation(
            teamId: eventData?.idHomeTeam, teamName: eventData?.strHomeTeam);
      },
      onSecondTeamTap: () {
        _teamNavigation(
            teamId: eventData?.idAwayTeam, teamName: eventData?.strAwayTeam);
        // AppNavigation.navigateTo(
        //   context,
        //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
        //   arguments: TeamsDetailArguments(
        //     teamId: latestEventData?.idAwayTeam,
        //     teamName: latestEventData?.strAwayTeam,
        //   ),
        // );
      },
    );
  }

  Widget _eventsShimmerListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CustomEventsContainer(
          showBoxShadow: false,
          showScore: true,
          showButton: widget.showButton == true ? true : false,
          eventDay: AppStrings.SATURDAY,
          eventDate: AppStrings.TEMP_JULY_DATE,
          eventStadiumPlace: AppStrings.LOREM_IPSUM_STADIUM,
          firstTeamName: AppStrings.INTER_MIAMI,
          secondTeamName: AppStrings.CHARLOTTE_FC,
          eventTime: AppStrings.TEMP_TIME,
          gameTitle: AppStrings.SOCCER,
          shimmerEnable: true,
          firstTeamScore: AppStrings.FIRST_TEAM_SCORE_TEXT,
          secondTeamScore: AppStrings.SECOND_TEAM_SCORE_TEXT,
        );
      }),
    );
  }

  void _teamNavigation({String? teamId, String? teamName}) {
    if (widget.eventType == EventType.team_upcoming.name ||
        widget.eventType == EventType.team_latest_result.name) {
      AppNavigation.navigatorPop(context);
      AppNavigation.navigateReplacementNamed(
        context,
        AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
        arguments: TeamsDetailArguments(
          teamId: teamId,
          teamName: teamName,
        ),
      );
    } else {
      AppNavigation.navigateTo(
        context,
        AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
        arguments: TeamsDetailArguments(
          teamId: teamId,
          teamName: teamName,
        ),
      );
    }
  }

  void _initializeLeagueProvider() {
    _leaguesProvider = Provider.of<LeaguesProvider>(context, listen: false);
  }

  void _initializeEventsProvider() {
    log("season data");

    _sportsName = Provider.of<LeaguesProvider>(context, listen: false)
        .getSingleLeagueData
        ?.strLeagueSport;

    ///For League Upcoming Events
    if (widget.eventType == EventType.league_upcoming.name) {
      widget.id = _leaguesProvider?.getSingleLeagueData?.idLeague?.toString();
      _eventsProvider =
          Provider.of<LeagueUpcomingEventsProvider>(context, listen: true);
    }

    ///For Leagues Latest Results Events
    else if (widget.eventType == EventType.league_latest_result.name) {
      _eventsProvider =
          Provider.of<LeagueLatestResultEventsProvider>(context, listen: true);
    }

    ///For Team Upcoming Events
    else if (widget.eventType == EventType.team_upcoming.name) {
      _eventsProvider =
          Provider.of<TeamUpcomingEventsProvider>(context, listen: true);
    }

    ///For Team Latest Results Events
    else if (widget.eventType == EventType.team_latest_result.name) {
      _eventsProvider =
          Provider.of<TeamLatestResultEventsProvider>(context, listen: true);
    }

    ///For Season Events
    else if (widget.eventType == EventType.season_all.name) {
      _eventsProvider =
          Provider.of<SeasonEventsProvider>(context, listen: true);
    }

    ///For League Live Events
    else if (widget.eventType == EventType.league_live.name) {
      widget.id = _leaguesProvider?.getSingleLeagueData?.idLeague?.toString();
      _eventsProvider =
          Provider.of<LeagueLiveEventsProvider>(context, listen: true);
    }

    _isWaiting = _eventsProvider?.getWaitingStatus;
    _eventsModel = _eventsProvider?.getEventsModel;

    //_setEventsData(isWaiting:_isWaiting,eventsModel: _eventsModel);
  }

  ///call Events Api At RefreshIndcator
  Future<void> _apiForRefreshIndicator() async {
    ///For League Upcoming Events
    if (widget.eventType == EventType.league_upcoming.name) {
      _leagueUpcomingEventsBloc.initializeLeagueUpcomingEventsProvider(
          context: context);
      await _leagueUpcomingEventsBloc.leagueUpComingEventsBlocMethod(
          context: context,
          leagueId: widget.id,
          apiTimeStamp: Constants.getApiTimesTamp());
    }

    ///For Leagues Latest Results Events
    else if (widget.eventType == EventType.league_latest_result.name) {
      _leagueLatestResultEventsBloc.initializeLeagueLatestResultEventsProvider(
          context: context);
      await _leagueLatestResultEventsBloc.leagueLatestResultEventsBlocMethod(
          context: context,
          leagueId: widget.id,
          apiTimeStamp: Constants.getApiTimesTamp());
    }

    ///For Team Upcoming Events
    else if (widget.eventType == EventType.team_upcoming.name) {
      _teamUpcomingEventsBloc.initializeTeamUpcomingEventsProvider(
          context: context);
      await _teamUpcomingEventsBloc.teamUpComingEventsBlocMethod(
          context: context,
          teamId: widget.id,
          apiTimeStamp: Constants.getApiTimesTamp());
    }

    ///For Team Latest Results Events
    else if (widget.eventType == EventType.team_latest_result.name) {
      _teamLatestResultEventsBloc.initializeTeamLatestResultsEventsProvider(
          context: context);
      await _teamLatestResultEventsBloc.teamLatestResultEventsBlocMethod(
          context: context,
          teamId: widget.id,
          apiTimeStamp: Constants.getApiTimesTamp());
    }

    ///For Season Events
    else if (widget.eventType == EventType.season_all.name) {
      _seasonEventsBloc.seasonEventsBlocMethod(
          context: context,
          seasonId: widget.id,
          seasonYear: widget.seasonYear,
          apiTimeStamp: Constants.getApiTimesTamp());
    }

    ///For League Live Events
    else if (widget.eventType == EventType.league_live.name) {
      _callLiveEventsApiMethod();
    }
  }

  //For Season Events OR For Live Events
  void _callLiveLeagueSeasonEventsApiMethod() {
    if (widget.eventType == EventType.season_all.name) {
      _seasonEventsBloc.initializeSeasonEventsProvider(context: context);
      _seasonEventsBloc.clearData(context: context);
      _seasonEventsBloc.seasonEventsBlocMethod(
          context: context,
          seasonId: widget.id,
          seasonYear: widget.seasonYear,
          apiTimeStamp: Constants.getApiTimesTamp());
    } else if (widget.eventType == EventType.league_live.name) {
      _leagueLiveEventsBloc.initializeLeagueLiveEventsProvider(
          context: context);
      //_callLiveEventsApiMethod();
    }
  }

  Future<void> _callLiveEventsApiMethod() async {
    await _leagueLiveEventsBloc.leagueLiveEventsBlocMethod(
        context: context,
        leagueId: widget.id,
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  void _initialzeLiveEventsTimer() {
    if (widget.eventType == EventType.league_live.name) {
      _liveEventTimer = Timer.periodic(
        const Duration(seconds: 130),
        (timer) {
          // Update user about remaining time
          _callLiveEventsApiMethod();
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _liveEventTimer?.cancel();
    super.dispose();
  }
}

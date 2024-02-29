import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/events/blocs/league_latest_result_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/league_upcoming_events_bloc.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/events/routing_arguments/events_routing_arguments.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_detail_bloc.dart';
import 'package:locks_hybrid/leagues/blocs/seasons_bloc.dart';
import 'package:locks_hybrid/leagues/blocs/teams_bloc.dart';
import 'package:locks_hybrid/leagues/models/leagues_detail_model.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/seasons_model.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/leagues/widgets/custom_leagues_detail_widget.dart';
import 'package:locks_hybrid/leagues/widgets/custom_season_widget.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_padding.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_events_container.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:locks_hybrid/widgets/custom_teams_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_text.dart';

class LeaguesDetailScreen extends StatefulWidget {
  @override
  State<LeaguesDetailScreen> createState() => _LeaguesDetailScreenState();
}

class _LeaguesDetailScreenState extends State<LeaguesDetailScreen> {
  LeaguesModelData? _leaguesModelData;
  int? _leagueId;
  String? _leagueName, _leagueAbbreviation, _leagueImagePath;

  LeaguesDetailBloc _leaguesDetailBloc = LeaguesDetailBloc();
  SeasonsBloc _seasonsBloc = SeasonsBloc();
  LeagueUpcomingEventsBloc _leagueUpcomingEventsBloc =
      LeagueUpcomingEventsBloc();
  LeagueLatestResultEventsBloc _leagueLatestResultEventsBloc =
      LeagueLatestResultEventsBloc();

  double _errorPaddingBottom = 10.0.h;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeLeagueProvider();
    _callLeaguesDetailApiMethod();
    _callLeagueUpComingEventsApiMethod();
    _callLeagueLatestResultEventsApiMethod();
    _callSeasonApiMethod();
    //_callTeamsApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: _leagueName,
      child: CustomRefreshIndicatorWidget(
        onRefresh: () async {
          /// call league detail api method
          await _callLeaguesDetailApiMethod();

          /// call league upcoming event api method
          await _leagueUpcomingEventsBloc.leagueUpComingEventsBlocMethod(
              context: context,
              leagueId: _leagueId?.toString(),
              apiTimeStamp: Constants.getApiTimesTamp());

          /// call league latest event api method

          await _leagueLatestResultEventsBloc
              .leagueLatestResultEventsBlocMethod(
                  context: context,
                  leagueId: _leagueId?.toString(),
                  apiTimeStamp: Constants.getApiTimesTamp());

          /// call league season api method
          await _callSeasonApiMethod();
        },
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _leaguesStreamBuilderWidget(),
                SizedBox(height: 10.h),
                _divider(),
                _leagueUpComingEventsWaitingListWidget(),
                _leagueLatestResultEventsWaitingListWidget(),
                SizedBox(height: 15.h),
                _titleViewAll(text: AppStrings.SEASONS),
                SizedBox(height: 15.h),
                _seasonsStreamBuilderWidget(),
                _teamsWaitingListWidget(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///------------------ Leagues Details Start ---------------------///
  Widget _leaguesStreamBuilderWidget() {
    return StreamBuilder(
      stream: _leaguesDetailBloc.getLeaguesDetail(),
      builder: (BuildContext context,
          AsyncSnapshot<LeaguesDetailModel?>? leaguesDetailSnapshot) {
        return leaguesDetailSnapshot?.connectionState == ConnectionState.waiting
            ? _leaguesDetailShimmerWidget()
            : (leaguesDetailSnapshot?.data?.leagues?.length ?? 0) > 0
                ? _leaguesDetailWidget(
                    leaguesDetailData: leaguesDetailSnapshot?.data?.leagues)
                : Padding(
                    padding: EdgeInsets.only(top: 20.h,bottom: _errorPaddingBottom),
                    child: Center(
                      child: CustomErrorWidget(
                        errorImagePath: AssetPath.LEAGUES_ICON,
                        errorText: AppStrings.NO_LEAGUE_DETAILS_FOUND_ERROR,
                        imageColor: AppColors.THEME_COLOR_WHITE,
                      ),
                    ),
                  );
      },
    );
  }

  Widget _leaguesDetailWidget(
      {List<LeaguesDetailModelLeagues?>? leaguesDetailData}) {
    return CustomLeagueTeamDetailWidget(
      leagueImagePath: Constants.getImage(imagePath: _leagueImagePath),
      location: leaguesDetailData?[0]?.strCountry,
      season: leaguesDetailData?[0]?.strCurrentSeason,
      leagueDescription: leaguesDetailData?[0]?.strDescriptionEN,
      shimmerEnable: false,
      onTap: () {
        Constants.imageViewMethod(
            context: context,
            imagePath: Constants.getImage(imagePath: _leagueImagePath));
      },
    );
  }

  Widget _leaguesDetailShimmerWidget() {
    return CustomLeagueTeamDetailWidget(
        leagueImagePath: Constants.getImage(imagePath: _leagueImagePath),
        leagueDescription: AppStrings.DESCRIPTION_LOREM_IPSUM,
        shimmerEnable: true);
  }

  ///------------------ Leagues Details End ---------------------///

  Widget _divider() {
    return CustomPadding(
      child: const Divider(
        color: AppColors.THEME_COLOR_WHITE,
        thickness: 0.3,
      ),
    );
  }

  ///------------------ League UpComing Events Start ---------------------///

  Widget _leagueUpComingEventsWaitingListWidget() {
    return Consumer<LeagueUpcomingEventsProvider>(
        builder: (context, upComingEventsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 15.h),
          _titleViewAll(
            text: AppStrings.UPCOMING_EVENTS,
            showisView: Constants.checkListLength(
                totalLength:
                    upComingEventsConsumerData.getEventsModel?.events?.length,
                showLength: Constants.EVENTS_LENGTH),
            onTap: () {
              AppNavigation.navigateTo(
                  context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
                  arguments: EventsRoutingArgument(
                    eventType: EventType.league_upcoming.name,
                    id: _leagueId?.toString()
                  ));
            },
          ),
          SizedBox(height: 10.h),
          upComingEventsConsumerData.getWaitingStatus == true
              ? _leagueUpcomingEventsShimmerListWidget()
              : (upComingEventsConsumerData.getEventsModel?.events?.length ??
                          0) >
                      0
                  ? _leagueUpComingEventsListWidget(
                      upComingEventObject:
                          upComingEventsConsumerData.getEventsModel?.events)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorPaddingBottom),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.EVENT_ICON,
                          errorText: AppStrings.NO_UPCOMING_EVENTS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 60.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _leagueUpComingEventsListWidget(
      {List<EventsModelEvents?>? upComingEventObject}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Constants.checkListLength(
              totalLength: upComingEventObject?.length,
              showLength: Constants.EVENTS_LENGTH)
          ? Constants.EVENTS_LENGTH
          : (upComingEventObject?.length ?? 0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return _leagueUpComingEventWidget(
            upComingEventData: upComingEventObject?[index]);
      }),
    );
  }

  Widget _leagueUpComingEventWidget({EventsModelEvents? upComingEventData}) {
    return CustomEventsContainer(
      showScore: Constants.showScore(
          homeScore: upComingEventData?.intHomeScore,
          awayScore: upComingEventData?.intAwayScore),
      eventDay: Constants.getEventDay(
          eventTimeStamp: upComingEventData?.strTimestamp),
      eventDate: Constants.getEventDate(
          eventTimeStamp: upComingEventData?.strTimestamp),
      eventStadiumPlace: Constants.getEventLocation(
          eventVenue: upComingEventData?.strVenue,
          eventCity: upComingEventData?.strCity,
          eventCountry: upComingEventData?.strCountry),
      firstTeamName: upComingEventData?.strHomeTeam,
      secondTeamName: upComingEventData?.strAwayTeam,
      eventTime: Constants.getEventTime(
          eventTimeStamp: upComingEventData?.strTimestamp),
      gameTitle: upComingEventData?.strSport,
      firstTeamLogo:
          Constants.getTeamImage(teamName: upComingEventData?.strHomeTeam),
      secondTeamLogo:
          Constants.getTeamImage(teamName: upComingEventData?.strAwayTeam),
      firstTeamScore: upComingEventData?.intHomeScore,
      secondTeamScore: upComingEventData?.intAwayScore,
      shimmerEnable: false,
      onFirstTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: upComingEventData?.idHomeTeam,
            teamName: upComingEventData?.strHomeTeam,
          ),
        );
      },
      onSecondTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: upComingEventData?.idAwayTeam,
            teamName: upComingEventData?.strAwayTeam,
          ),
        );
      },
    );
  }

  Widget _leagueUpcomingEventsShimmerListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CustomEventsContainer(
          showScore: false,
          eventDay: AppStrings.SATURDAY,
          eventDate: AppStrings.TEMP_JULY_DATE,
          eventStadiumPlace: AppStrings.LOREM_IPSUM_STADIUM,
          firstTeamName: AppStrings.INTER_MIAMI,
          secondTeamName: AppStrings.CHARLOTTE_FC,
          eventTime: AppStrings.TEMP_TIME,
          gameTitle: AppStrings.SOCCER,
          shimmerEnable: true,
        );
      }),
    );
  }

  ///------------------ League UpComing Events End ---------------------///

  ///------------------ League Latest Events Start ---------------------///

  Widget _leagueLatestResultEventsWaitingListWidget() {
    return Consumer<LeagueLatestResultEventsProvider>(
        builder: (context, latestEventsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 15.h),
          _titleViewAll(
            text: AppStrings.LATEST_RESULTS,
            showisView: Constants.checkListLength(
                totalLength:
                    latestEventsConsumerData.getEventsModel?.events?.length,
                showLength: Constants.EVENTS_LENGTH),
            onTap: () {
              AppNavigation.navigateTo(
                  context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
                  arguments: EventsRoutingArgument(
                      eventType: EventType.league_latest_result.name,
                      id: _leagueId?.toString()
                  ));
            },
          ),
          SizedBox(height: 10.h),
          latestEventsConsumerData.getWaitingStatus == true
              ? _leagueLatestResultEventShimmerListWidget()
              : (latestEventsConsumerData.getEventsModel?.events?.length ?? 0) >
                      0
                  ? _leagueLatestResultEventsListWidget(
                      latestEventObject:
                          latestEventsConsumerData.getEventsModel?.events)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorPaddingBottom),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.EVENT_ICON,
                          errorText: AppStrings.NO_LATEST_RESULTS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 60.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _leagueLatestResultEventsListWidget(
      {List<EventsModelEvents?>? latestEventObject}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Constants.checkListLength(
              totalLength: latestEventObject?.length,
              showLength: Constants.EVENTS_LENGTH)
          ? Constants.EVENTS_LENGTH
          : (latestEventObject?.length ?? 0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return _leagueLatestResultEventWidget(
            latestEventData: latestEventObject?[index]);
      }),
    );
  }

  Widget _leagueLatestResultEventWidget({EventsModelEvents? latestEventData}) {
    return CustomEventsContainer(
      showScore: Constants.showScore(
          homeScore: latestEventData?.intHomeScore,
          awayScore: latestEventData?.intAwayScore),
      eventDay:
          Constants.getEventDay(eventTimeStamp: latestEventData?.strTimestamp),
      eventDate:
          Constants.getEventDate(eventTimeStamp: latestEventData?.strTimestamp),
      eventStadiumPlace: Constants.getEventLocation(
          eventVenue: latestEventData?.strVenue,
          eventCity: latestEventData?.strCity,
          eventCountry: latestEventData?.strCountry),
      firstTeamName: latestEventData?.strHomeTeam,
      secondTeamName: latestEventData?.strAwayTeam,
      eventTime:
          Constants.getEventTime(eventTimeStamp: latestEventData?.strTimestamp),
      gameTitle: latestEventData?.strSport,
      firstTeamScore: latestEventData?.intHomeScore,
      secondTeamScore: latestEventData?.intAwayScore,
      firstTeamLogo:
          Constants.getTeamImage(teamName: latestEventData?.strHomeTeam),
      secondTeamLogo:
          Constants.getTeamImage(teamName: latestEventData?.strAwayTeam),
      shimmerEnable: false,
      onFirstTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: latestEventData?.idHomeTeam,
            teamName: latestEventData?.strHomeTeam,
          ),
        );
      },
      onSecondTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: latestEventData?.idAwayTeam,
            teamName: latestEventData?.strAwayTeam,
          ),
        );
      },
    );
  }

  Widget _leagueLatestResultEventShimmerListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CustomEventsContainer(
          showScore: true,
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

  ///------------------ League Latest Events End ---------------------///

  ///------------------ Seasons Start ---------------------///

  Widget _seasonsStreamBuilderWidget() {
    return StreamBuilder(
      stream: _seasonsBloc.getSeasons(),
      builder: (BuildContext context,
          AsyncSnapshot<SeasonsModel?>? seasonsSnapshot) {
        return seasonsSnapshot?.connectionState == ConnectionState.waiting
            ? _seasonsListShimmerWidget()
            : (seasonsSnapshot?.data?.seasons?.length ?? 0) > 0
                ? _seasonsListWidget(
                    seasonsObject: seasonsSnapshot?.data?.seasons)
                : Center(
                    child: CustomErrorWidget(
                      errorImagePath: AssetPath.SEASONS_ICON,
                      errorText: AppStrings.NO_SEASONS_FOUND_ERROR,
                      imageColor: AppColors.THEME_COLOR_WHITE,
                      imageSize: 60.h,
                    ),
                  );
      },
    );
  }

  Widget _seasonsListWidget({List<SeasonsModelSeasons?>? seasonsObject}) {
    return Container(
      height: 64.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: seasonsObject?.length ?? 0,
        padding: EdgeInsets.symmetric(
            horizontal: AppPadding.DEFAULT_HORIZONTAL_PADDING.w),
        itemBuilder: ((context, index) {
          return _seasonsWidget(seasonsData: seasonsObject?[index]);
        }),
      ),
    );
  }

  Widget _seasonsWidget({SeasonsModelSeasons? seasonsData}) {
    return CustomSeasonWidget(
      imagePath: Constants.getImage(imagePath: _leagueImagePath),
      seasonText: seasonsData?.strSeason,
      shimmerEnable: false,
      onTap: () {
        AppNavigation.navigateTo(context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
            arguments: EventsRoutingArgument(
                eventType: EventType.season_all.name,
                id: _leagueId?.toString(),
                seasonYear: seasonsData?.strSeason));
      },
    );
  }

  Widget _seasonsListShimmerWidget() {
    return Container(
      height: 64.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        padding: EdgeInsets.symmetric(
            horizontal: AppPadding.DEFAULT_HORIZONTAL_PADDING.w),
        itemBuilder: ((context, index) {
          return CustomSeasonWidget(
            seasonText: AppStrings.SEASON_YEAR_TEXT,
            shimmerEnable: true,
          );
        }),
      ),
    );
  }

  ///------------------ Seasons End ---------------------///

  ///------------------ Teams Start ---------------------///

  Widget _teamsWaitingListWidget() {
    return Consumer<TeamsProvider>(
        builder: (context, teamsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 25.h),
          _titleViewAll(
            text: AppStrings.TEAMS,
            showisView: Constants.checkListLength(
                totalLength: teamsConsumerData.getTeamsModel?.teams?.length,
                showLength: Constants.TEAMS_SHOW_LENGTH),
            onTap: () {
              AppNavigation.navigateTo(
                context,
                AppRouteName.TEAMS_SCREEN_ROUTE,
              );
            },
          ),
          SizedBox(height: 10.h),
          teamsConsumerData.getWaitingStatus == true
              ? _teamsGridViewShimmerWidget()
              : (teamsConsumerData.getTeamsModel?.teams?.length ?? 0) > 0
                  ? _teamsGridViewWidget(
                      teamsObject: teamsConsumerData.getTeamsModel?.teams)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorPaddingBottom),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.TEAMS_ICON,
                          errorText: AppStrings.NO_TEAMS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 60.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _teamsGridViewWidget({List<TeamsModelTeams?>? teamsObject}) {
    return CustomPadding(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: Constants.checkListLength(
                    totalLength: teamsObject?.length,
                    showLength: Constants.TEAMS_SHOW_LENGTH)
                ? Constants.TEAMS_SHOW_LENGTH
                : (teamsObject?.length ?? 0),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 0.5.sw,
                crossAxisSpacing: 14.w,
                childAspectRatio: 1.1,
                mainAxisSpacing: 15.h),
            itemBuilder: (BuildContext ctx, index) {
              return _teamsWidget(teamsData: teamsObject?[index]);
            }));
  }

  Widget _teamsWidget({TeamsModelTeams? teamsData}) {
    return CustomTeamsContainer(
      imagePath: teamsData?.strTeamBadge,
      title: teamsData?.strTeam,
      imageBoxFit: BoxFit.contain,
      shimmerEnable: false,
      onTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: teamsData?.idTeam,
            teamName: teamsData?.strTeam,
          ),
        );
      },
    );
  }

  Widget _teamsGridViewShimmerWidget() {
    return CustomPadding(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 0.5.sw,
                crossAxisSpacing: 14.w,
                childAspectRatio: 1.1,
                mainAxisSpacing: 15.h),
            itemBuilder: (BuildContext ctx, index) {
              return CustomTeamsContainer(
                title: AppStrings.ATLANTA_UNITED,
                shimmerEnable: true,
              );
            }));
  }

  ///------------------ Teams End ---------------------///

  Widget _titleViewAll(
      {String? text, Function()? onTap, bool? showisView = false}) {
    return CustomPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            fontColor: AppColors.THEME_COLOR_WHITE,
            fontStyle: FontStyle.italic,
            fontSize: 18.sp,
            fontFamily: AppFonts.Poppins_Medium,
          ),
          showisView == true
              ? GestureDetector(
                  onTap: onTap,
                  child: CustomText(
                    text: AppStrings.VIEW_ALL,
                    fontSize: 14.sp,
                    fontFamily: AppFonts.Poppins_Regular,
                    underlined: true,
                    fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void _initializeLeagueProvider() {
    _leaguesModelData = Provider.of<LeaguesProvider>(context, listen: false)
        .getSingleLeagueData;
    if (_leaguesModelData != null) {
      _leagueId = _leaguesModelData?.idLeague;
      _leagueName = _leaguesModelData?.strLeagueName;
      _leagueAbbreviation = _leaguesModelData?.strLeague;
      _leagueImagePath = _leaguesModelData?.strLeagueImage;

      print("Leagues Id:$_leagueId");
    }
  }

  //It will call leagues detail Api
  Future<void> _callLeaguesDetailApiMethod() async {
    await _leaguesDetailBloc.leaguesDetailBlocMethod(leagueId: _leagueId);
  }

  //It will call League UpComing Events Api
  void _callLeagueUpComingEventsApiMethod() {
    _leagueUpcomingEventsBloc.initializeLeagueUpcomingEventsProvider(
        context: context);
    _leagueUpcomingEventsBloc.clearData(context: context);
    _leagueUpcomingEventsBloc.leagueUpComingEventsBlocMethod(
        context: context,
        leagueId: _leagueId?.toString(),
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call League Latest Events Api
  void _callLeagueLatestResultEventsApiMethod() {
    _leagueLatestResultEventsBloc.initializeLeagueLatestResultEventsProvider(
        context: context);
    _leagueLatestResultEventsBloc.clearData(context: context);
    _leagueLatestResultEventsBloc.leagueLatestResultEventsBlocMethod(
        context: context,
        leagueId: _leagueId?.toString(),
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call season Api
  Future<void> _callSeasonApiMethod() async {
    await _seasonsBloc.seasonsBlocMethod(leagueId: _leagueId);
  }

  //It will call teams Api
  // void _callTeamsApiMethod() {
  //   //_teamsBloc.initializeTeamsProvider(context: context);
  //   //_teamsBloc.clearData(context: context);
  //   _teamsBloc.teamsBlocMethod(
  //       context: context,
  //       leagueAbbreviation: _leagueAbbreviation,
  //       apiTimeStamp: Constants.getApiTimesTamp());
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _leaguesDetailBloc.cancelStream();
    _seasonsBloc.cancelStream();
    super.dispose();
  }
}

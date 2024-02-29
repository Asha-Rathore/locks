import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/events/blocs/team_latest_result_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/team_upcoming_events_bloc.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/events/routing_arguments/events_routing_arguments.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/widgets/custom_leagues_detail_widget.dart';
import 'package:locks_hybrid/team_members/routing_arguments/team_members_routing_arguments.dart';
import 'package:locks_hybrid/teams/blocs/team_members_bloc.dart';
import 'package:locks_hybrid/teams/blocs/teams_detail_bloc.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/teams/provider/team_members_provider.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
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
import '../../widgets/custom_image_widget.dart';
import '../../widgets/custom_text.dart';

class TeamsDetailScreen extends StatefulWidget {
  final String? teamId;
  final String? teamName;

  TeamsDetailScreen({this.teamId, this.teamName});

  @override
  State<TeamsDetailScreen> createState() => _TeamsDetailScreenState();
}

class _TeamsDetailScreenState extends State<TeamsDetailScreen> {
  TeamsDetailBloc _teamsDetailBloc = TeamsDetailBloc();
  TeamUpcomingEventsBloc _teamUpcomingEventsBloc = TeamUpcomingEventsBloc();
  TeamMembersBloc _teamMembersBloc = TeamMembersBloc();
  TeamLatestResultEventsBloc _teamLatestResultEventsBloc =
      TeamLatestResultEventsBloc();

  double _errorVerticalPadding = 10.0.h;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Team Id:${widget.teamId}");
    _callTeamsDetailApiMethod();
    _callTeamUpComingEventsApiMethod();
    _callTeamLatestResultEventsApiMethod();
    _callTeamMembersApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: widget.teamName,
      child: CustomRefreshIndicatorWidget(
        onRefresh: () async {
          //call team details method
          await _callTeamsDetailApiMethod();

          //call team upcoming events method
          _teamUpcomingEventsBloc.teamUpComingEventsBlocMethod(
              context: context,
              teamId: widget.teamId,
              apiTimeStamp: Constants.getApiTimesTamp());

          //call team latest result events method
          _teamLatestResultEventsBloc.teamLatestResultEventsBlocMethod(
              context: context,
              teamId: widget.teamId,
              apiTimeStamp: Constants.getApiTimesTamp());

          //call team members api method
          _teamMembersBloc.teamMembersBlocMethod(
              context: context,
              teamId: widget.teamId,
              apiTimeStamp: Constants.getApiTimesTamp());
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              _teamsStreamBuilderWidget(),
              SizedBox(height: 10.h),
              _divider(),
              _teamUpComingEventsWaitingListWidget(),
              _teamLatestResultEventsWaitingListWidget(),
              _teamMembersWaitingListWidget(),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  ///------------------ Teams Details Start ---------------------///
  Widget _teamsStreamBuilderWidget() {
    return StreamBuilder(
      stream: _teamsDetailBloc.getTeamsDetail(),
      builder: (BuildContext context,
          AsyncSnapshot<TeamsModelTeams?>? teamsDetailSnapshot) {
        return teamsDetailSnapshot?.connectionState == ConnectionState.waiting
            ? _teamsDetailShimmerWidget()
            : teamsDetailSnapshot?.data != null
                ? _teamsDetailWidget(teamsDetailData: teamsDetailSnapshot?.data)
                : Padding(
                    padding: EdgeInsets.only(top: 30.h,bottom: 10.h),
                    child: Center(
                      child: CustomErrorWidget(
                        errorImagePath: AssetPath.TEAMS_ICON,
                        errorText: AppStrings.NO_TEAM_DETAILS_FOUND_ERROR,
                        imageColor: AppColors.THEME_COLOR_WHITE,
                      ),
                    ),
                  );
      },
    );
  }

  Widget _teamsDetailWidget({TeamsModelTeams? teamsDetailData}) {
    return CustomLeagueTeamDetailWidget(
      leagueImagePath: teamsDetailData?.strTeamFanart1,
      leagueDescription: teamsDetailData?.strDescriptionEN,
      shimmerEnable: false,
      countryFlag:
          Constants.getCountryImage(countryName: teamsDetailData?.strCountry),
      onTap: () {
        Constants.imageViewMethod(
            context: context, imagePath: teamsDetailData?.strTeamFanart1);
      },
    );
  }

  Widget _teamsDetailShimmerWidget() {
    return CustomLeagueTeamDetailWidget(
        leagueImagePath: null,
        leagueDescription: AppStrings.DESCRIPTION_LOREM_IPSUM,
        shimmerEnable: true);
  }

  ///------------------ Teams Details End ---------------------///

  Widget _divider() {
    return CustomPadding(
      child: const Divider(
        color: AppColors.THEME_COLOR_WHITE,
        thickness: 0.3,
      ),
    );
  }

  ///------------------ Teams UpComing Events Start ---------------------///

  Widget _teamUpComingEventsWaitingListWidget() {
    return Consumer<TeamUpcomingEventsProvider>(
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
                      eventType: EventType.team_upcoming.name,
                      id: widget.teamId));
            },
          ),
          SizedBox(height: 10.h),
          upComingEventsConsumerData.getWaitingStatus == true
              ? _teamUpcomingEventsShimmerListWidget()
              : (upComingEventsConsumerData.getEventsModel?.events?.length ??
                          0) >
                      0
                  ? _teamUpComingEventsListWidget(
                      upComingEventObject:
                          upComingEventsConsumerData.getEventsModel?.events)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorVerticalPadding),
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

  Widget _teamUpComingEventsListWidget(
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
        return _teamUpComingEventWidget(
            upComingEventData: upComingEventObject?[index]);
      }),
    );
  }

  Widget _teamUpComingEventWidget({EventsModelEvents? upComingEventData}) {
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
        AppNavigation.navigateReplacementNamed(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: upComingEventData?.idHomeTeam,
            teamName: upComingEventData?.strHomeTeam,
          ),
        );
      },
      onSecondTeamTap: () {
        AppNavigation.navigateReplacementNamed(
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

  Widget _teamUpcomingEventsShimmerListWidget() {
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

  ///------------------ Teams UpComing Events End ---------------------///

  ///------------------ Team Latest Events Start ---------------------///

  Widget _teamLatestResultEventsWaitingListWidget() {
    return Consumer<TeamLatestResultEventsProvider>(
        builder: (context, latestEventsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 10.h),
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
                      eventType: EventType.team_latest_result.name,
                      id: widget.teamId));
            },
          ),
          SizedBox(height: 10.h),
          latestEventsConsumerData.getWaitingStatus == true
              ? _teamLatestResultEventShimmerListWidget()
              : (latestEventsConsumerData.getEventsModel?.events?.length ?? 0) >
                      0
                  ? _teamLatestResultEventsListWidget(
                      latestEventObject:
                          latestEventsConsumerData.getEventsModel?.events)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorVerticalPadding),
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

  Widget _teamLatestResultEventsListWidget(
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
        return _teamLatestResultEventWidget(
            latestEventData: latestEventObject?[index]);
      }),
    );
  }

  Widget _teamLatestResultEventWidget({EventsModelEvents? latestEventData}) {
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
        AppNavigation.navigateReplacementNamed(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: latestEventData?.idHomeTeam,
            teamName: latestEventData?.strHomeTeam,
          ),
        );
      },
      onSecondTeamTap: () {
        AppNavigation.navigateReplacementNamed(
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

  Widget _teamLatestResultEventShimmerListWidget() {
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

  ///------------------ Team Latest Events End ---------------------///

  ///------------------ Teams Members Start ---------------------///

  Widget _teamMembersWaitingListWidget() {
    return Consumer<TeamMembersProvider>(
        builder: (context, teamMembersConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 10.h),
          _titleViewAll(
            text: AppStrings.TEAM_MEMBERS,
            showisView: Constants.checkListLength(
                totalLength:
                    teamMembersConsumerData.getTeamMembersModel?.player?.length,
                showLength: Constants.TEAM_MEMBERS_SHOW_LENGTH),
            onTap: () {
              AppNavigation.navigateTo(
                context,
                AppRouteName.TEAM_MEMBERS_SCREEN_ROUTE,
              );
            },
          ),
          SizedBox(height: 10.h),
          teamMembersConsumerData.getWaitingStatus == true
              ? _teamMembersGridViewShimmerWidget()
              : (teamMembersConsumerData.getTeamMembersModel?.player?.length ??
                          0) >
                      0
                  ? _teamMembersGridViewWidget(
                      teamMembersObject:
                          teamMembersConsumerData.getTeamMembersModel?.player)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: _errorVerticalPadding),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.TEAM_MEMBERS_ICON,
                          errorText: AppStrings.NO_TEAM_MEMBERS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 60.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _teamMembersGridViewWidget(
      {List<TeamMembersModelPlayer?>? teamMembersObject}) {
    return CustomPadding(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: Constants.checkListLength(
                    totalLength: teamMembersObject?.length,
                    showLength: Constants.TEAM_MEMBERS_SHOW_LENGTH)
                ? Constants.TEAM_MEMBERS_SHOW_LENGTH
                : (teamMembersObject?.length ?? 0),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 0.5.sw,
                crossAxisSpacing: 14.w,
                childAspectRatio: 1.1,
                mainAxisSpacing: 15.h),
            itemBuilder: (BuildContext ctx, index) {
              return _teamMembersWidget(
                  teamMembersData: teamMembersObject?[index]);
            }));
  }

  Widget _teamMembersWidget({TeamMembersModelPlayer? teamMembersData}) {
    return CustomTeamsContainer(
      imagePath: teamMembersData?.strCutout,
      title: teamMembersData?.strPlayer,
      shimmerEnable: false,
      imageBoxFit: BoxFit.contain,
      onTap: (){
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_MEMBER_DETAIL_SCREEN_ROUTE,
          arguments: TeamMemberRoutingArguments(
              teamMembersModelPlayer: teamMembersData
          ),
        );
      },
    );
  }

  Widget _teamMembersGridViewShimmerWidget() {
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

  ///------------------ Teams Members End ---------------------///

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

  //It will call teams detail Api
  Future<void> _callTeamsDetailApiMethod() async {
    await _teamsDetailBloc.teamsDetailBlocMethod(teamId: widget.teamId);
  }

  //It will call Team UpComing Events Api
  void _callTeamUpComingEventsApiMethod() {
    _teamUpcomingEventsBloc.initializeTeamUpcomingEventsProvider(
        context: context);
    _teamUpcomingEventsBloc.clearData(context: context);
    _teamUpcomingEventsBloc.teamUpComingEventsBlocMethod(
        context: context,
        teamId: widget.teamId,
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call Team Latest Events Api
  void _callTeamLatestResultEventsApiMethod() {
    _teamLatestResultEventsBloc.initializeTeamLatestResultsEventsProvider(
        context: context);
    _teamLatestResultEventsBloc.clearData(context: context);
    _teamLatestResultEventsBloc.teamLatestResultEventsBlocMethod(
        context: context,
        teamId: widget.teamId,
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call Team Members Api
  void _callTeamMembersApiMethod() {
    print("Team Id:${widget.teamId}");
    _teamMembersBloc.initializeTeamMembersProvider(context: context);
    _teamMembersBloc.clearData(context: context);
    _teamMembersBloc.teamMembersBlocMethod(
        context: context,
        teamId: widget.teamId,
        apiTimeStamp: Constants.getApiTimesTamp());
  }
}

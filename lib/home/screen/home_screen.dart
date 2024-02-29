import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/events/blocs/league_live_events_bloc.dart';
import 'package:locks_hybrid/events/blocs/league_upcoming_events_bloc.dart';
import 'package:locks_hybrid/events/models/events_model.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/events/routing_arguments/events_routing_arguments.dart';
import 'package:locks_hybrid/home/blocs/news_bloc.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/home/provider/news_provider.dart';
import 'package:locks_hybrid/latest_news/routing_arguments/latest_news_detail_arguments.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_events_container.dart';
import 'package:locks_hybrid/widgets/custom_filter_bottom_sheet.dart';
import 'package:locks_hybrid/widgets/custom_filter_icon.dart';
import 'package:locks_hybrid/widgets/custom_news_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:locks_hybrid/widgets/custom_search_bar.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchTextController = TextEditingController();

  LeaguesProvider? _leaguesProvider;
  LeaguesModelData? _leaguesModelData;
  int? _leaguesId;
  String? _leagueSport, _leagueAbbreviation;

  NewsBloc _newsBloc = NewsBloc();

  LeagueUpcomingEventsBloc _leagueUpcomingEventsBloc =
      LeagueUpcomingEventsBloc();

  LeagueLiveEventsBloc _leagueLiveEventsBloc = LeagueLiveEventsBloc();

  Timer? _liveEventTimer;

  double errorBottomPadding = 10.0;
  bool? _errorLeagueData;
  bool _apiCalledOnce = false;

  @override
  Widget build(BuildContext context) {
    _getSingleLeagueData();
    return Column(
      children: [
        SizedBox(height: 10.h),
        _searchBarAndFilter(context),
        SizedBox(height: 20.h),
        Expanded(
          child: _errorLeagueData != null
              ? CustomRefreshIndicatorWidget(
                  onRefresh: () async {
                    await _onRefreshIndicatorMethod();
                  },
                  child: Container(
                    width: 1.sw,
                    height: 1.sh,
                    child: _mainHomeWidget(),
                  ),
                )
              : _mainHomeWidget(),
        ),
      ],
    );
  }

  Widget _mainHomeWidget() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        children: [
          _newsWaitingListWidget(),
          _leagueLiveEventsWaitingListWidget(),
          _leagueUpComingEventsWaitingListWidget(),
          // _titleViewAll(
          //   text: AppStrings.TEAMS_STANDINGS,
          //   showisView: true,
          //   onTap: () {
          //     AppNavigation.navigateTo(
          //         context, AppRouteName.TEAM_STANDINGS_SCREEN_ROUTE);
          //   },
          // ),
          SizedBox(height: 20.h),
          //_teamStandings()
        ],
      ),
    );
  }

  Widget _searchBarAndFilter(context) {
    return CustomPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomSearchBar(
              controller: _searchTextController,
              onchange: (String? searchText) {
                print("News Text:${searchText}");

                _newsBloc.searchNewsMethod(searchText: searchText);
              },
            ),
          ),
          SizedBox(width: 10.w),
          CustomFilterIcon(
            onTap: () {
              Constants.unFocusKeyboardMethod(context: context);
              Utils.showCustomBottomSheet(
                  context: context,
                  filterBottomSheet: CustomFilterBottomSheet(
                    onShowResultTap: (bool result) {
                      _apiCalledOnce = false;
                    },
                  ));
            },
          )
        ],
      ),
    );
  }

  ///------------------ News Start ---------------------///

  Widget _newsWaitingListWidget() {
    return Consumer<NewsProvider>(builder: (context, newsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 10.h),
          _titleViewAll(
            text: AppStrings.LATEST_NEWS,
            // showisView: Constants.checkListLength(
            //     totalLength:
            //         newsConsumerData.getMainNewsModel?.articles?.length,
            //     showLength: Constants.NEWS_LENGTH),
            showisView: true,
            onTap: () {
              AppNavigation.navigateTo(
                  context, AppRouteName.LATEST_NEWS_SCREEN_ROUTE);
            },
          ),
          SizedBox(height: 15.h),
          newsConsumerData.getWaitingStatus == true
              ? _newsShimmerListWidget()
              : (newsConsumerData.getMainNewsModel?.articles?.length ?? 0) > 0
                  ? _newsListWidget(
                      newsObject: newsConsumerData.getMainNewsModel?.articles)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: errorBottomPadding),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.NEWS_ICON,
                          errorText: AppStrings.NO_NEWS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 55.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _newsListWidget({List<NewsModelArticles?>? newsObject}) {
    return ListView.builder(
      itemCount: Constants.checkListLength(
              totalLength: newsObject?.length,
              showLength: Constants.NEWS_LENGTH)
          ? Constants.NEWS_LENGTH
          : (newsObject?.length ?? 0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return _newsWidget(newsData: newsObject?[index]);
      }),
    );
  }

  Widget _newsWidget({NewsModelArticles? newsData}) {
    return CustomNewsWidget(
      isHome: true,
      newsImages: newsData?.images,
      title: newsData?.headline,
      timeAgo: Constants.timeAgoMethod(date: newsData?.lastModified),
      description: newsData?.description,
      shimmerEnable: false,
      onTap: () {
        print("news");
        AppNavigation.navigateTo(
            context, AppRouteName.LATEST_NEWS_DETAIL_SCREEN_ROUTE,
            arguments: LatestNewsDetailsArguments(newsModelArticles: newsData));

        // AppNavigation.navigateTo(
        //     context, AppRouteName.LATEST_NEWS_DETAIL_SCREEN_ROUTE,
        //     arguments: LatestNewsRoutingArgument(
        //       date: AppStrings.viewAllLatestNewsList['LatestNews'][index]
        //           ['date'],
        //       time: AppStrings.viewAllLatestNewsList['LatestNews'][index]
        //           ['time'],
        //       image: AppStrings.latestNewsList['LatestNews'][index]
        //           ['image'],
        //     ));
      },
    );
  }

  Widget _newsShimmerListWidget() {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CustomNewsWidget(
          isHome: true,
          image: null,
          title: AppStrings.LOREM_IPSUM,
          timeAgo: AppStrings.TWO_HOURS_AGO,
          description: AppStrings.DESCRIPTION_LOREM_IPSUM,
          shimmerEnable: true,
        );
      }),
    );
  }

  ///------------------ News End ---------------------///

  ///------------------ League Live Events Start ---------------------///

  Widget _leagueLiveEventsWaitingListWidget() {
    return Consumer<LeagueLiveEventsProvider>(
        builder: (context, liveEventsConsumerData, child) {
      return Column(
        children: [
          SizedBox(height: 10.h),
          _titleViewAll(
            text: AppStrings.LIVE_EVENTS,
            showisView: Constants.checkListLength(
                totalLength:
                    liveEventsConsumerData.getEventsModel?.events?.length,
                showLength: Constants.HOME_LIVE_EVENTS_LENGTH),
            onTap: () {
              AppNavigation.navigateTo(
                  context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
                  arguments: EventsRoutingArgument(
                      eventType: EventType.league_live.name,
                      id: _leaguesId?.toString(),
                      showButton: true));
            },
          ),
          SizedBox(height: 5.h),
          liveEventsConsumerData.getWaitingStatus == true
              ? _leagueLiveEventsShimmerListWidget()
              : (liveEventsConsumerData.getEventsModel?.events?.length ?? 0) > 0
                  ? _leagueLiveEventsListWidget(
                      liveEventObject:
                          liveEventsConsumerData.getEventsModel?.events)
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: errorBottomPadding),
                        child: CustomErrorWidget(
                          errorImagePath: AssetPath.EVENT_ICON,
                          errorText: AppStrings.NO_lIVE_EVENTS_FOUND_ERROR,
                          imageColor: AppColors.THEME_COLOR_WHITE,
                          imageSize: 60.h,
                        ),
                      ),
                    ),
        ],
      );
    });
  }

  Widget _leagueLiveEventsListWidget(
      {List<EventsModelEvents?>? liveEventObject}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Constants.checkListLength(
              totalLength: liveEventObject?.length,
              showLength: Constants.HOME_LIVE_EVENTS_LENGTH)
          ? Constants.HOME_LIVE_EVENTS_LENGTH
          : (liveEventObject?.length ?? 0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return _leagueLiveEventWidget(liveEventData: liveEventObject?[index]);
      }),
    );
  }

  Widget _leagueLiveEventWidget({EventsModelEvents? liveEventData}) {
    return CustomEventsContainer(
      showScore: Constants.showScore(
          homeScore: liveEventData?.intHomeScore,
          awayScore: liveEventData?.intAwayScore),
      // showScore: false,
      showButton: true,
      eventDay:
          Constants.getEventDay(eventTimeStamp: liveEventData?.strTimestamp),
      eventDate:
          Constants.getEventDate(eventTimeStamp: liveEventData?.strTimestamp),
      eventStadiumPlace: Constants.getEventLocation(
          eventVenue: liveEventData?.strVenue,
          eventCity: liveEventData?.strCity,
          eventCountry: liveEventData?.strCountry),
      firstTeamName: liveEventData?.strHomeTeam,
      secondTeamName: liveEventData?.strAwayTeam,
      eventTime:
          Constants.getEventTime(eventTimeStamp: liveEventData?.strTimestamp),
      gameTitle: _leagueSport,
      firstTeamScore: liveEventData?.intHomeScore,
      secondTeamScore: liveEventData?.intAwayScore,
      firstTeamLogo:
          Constants.getTeamImage(teamName: liveEventData?.strHomeTeam),
      secondTeamLogo:
          Constants.getTeamImage(teamName: liveEventData?.strAwayTeam),
      shimmerEnable: false,
      onFirstTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: liveEventData?.idHomeTeam,
            teamName: liveEventData?.strHomeTeam,
          ),
        );
      },
      onSecondTeamTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
          arguments: TeamsDetailArguments(
            teamId: liveEventData?.idAwayTeam,
            teamName: liveEventData?.strAwayTeam,
          ),
        );
      },
    );
  }

  Widget _leagueLiveEventsShimmerListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CustomEventsContainer(
          showScore: false,
          showButton: true,
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

  ///------------------ League Live Events End ---------------------///

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
                      id: _leaguesId?.toString(),
                      showButton: true));
            },
          ),
          SizedBox(height: 5.h),
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
                        padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
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
      //showScore: false,
      showButton: true,
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
      gameTitle: _leagueSport,
      firstTeamScore: upComingEventData?.intHomeScore,
      secondTeamScore: upComingEventData?.intAwayScore,
      firstTeamLogo:
          Constants.getTeamImage(teamName: upComingEventData?.strHomeTeam),
      secondTeamLogo:
          Constants.getTeamImage(teamName: upComingEventData?.strAwayTeam),
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
          showButton: true,
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
  //
  // Widget _teamStandings() {
  //   return const CustomTeamStandingsContainer(
  //     league: "${AppStrings.LOREM_IPSUM} League",
  //     teamLength: 4,
  //   );
  // }

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

  void _getSingleLeagueData() {
    _leaguesProvider = Provider.of<LeaguesProvider>(context, listen: true);
    _leaguesModelData = _leaguesProvider?.getSingleLeagueData;
    _errorLeagueData = _leaguesProvider?.getErrorLeagueData;

    //we use error league data because to control when there is error it shows no data found
    //If League has different Ids then call the apis
    //Api Called Once used to call api once
    if (_apiCalledOnce == false) {
      if (_leaguesId != _leaguesModelData?.idLeague &&
          _errorLeagueData == false) {
        // _leaguesId = _leaguesModelData?.idLeague;
        // _leagueSport = _leaguesModelData?.strLeagueSport;
        // _leagueAbbreviation = _leaguesModelData?.strLeagueAbbreviation;

        _setLeaguesDataMethod(
            leaguesId: _leaguesModelData?.idLeague,
            leaguesSport: _leaguesModelData?.strLeagueSport,
            leaguesAbbreviation: _leaguesModelData?.strLeagueAbbreviation);

        log("New League Data");
        _callhomeApis();
        _apiCalledOnce = true;
      } else if (_leaguesId == null && _errorLeagueData == true) {
        // _leaguesId = _leaguesModelData?.idLeague;
        // _leagueSport = _leaguesModelData?.strLeagueSport;
        // _leagueAbbreviation = _leaguesModelData?.strLeagueAbbreviation;

        log("New Error League Data");
        _callhomeApis();
        _apiCalledOnce = true;
      }
    }
  }

  void _callhomeApis() {
    _callNewsApiMethod();
    _callLeagueLiveEventsApiMethod();
    _callLeagueUpComingEventsApiMethod();
    _initialzeLiveEventsTimer();
  }

  //It will call News Api
  Future<void> _callNewsApiMethod() async {
    _newsBloc.initializeNewsProvider(context: context);
    _newsBloc.clearData(context: context);
    await _newsBloc.newsBlocMethod(
        context: context,
        endPoint: NetworkStrings.NEWS_ENDPOINTS_LIST[_leagueAbbreviation],
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call League Live Events Api
  void _callLeagueLiveEventsApiMethod() async {
    print("Call League Event Live Api Method");

    _leagueLiveEventsBloc.initializeLeagueLiveEventsProvider(context: context);
    _leagueLiveEventsBloc.clearData(context: context);
    await _callLeagueLiveEventsCommonApiMethod();
  }

  Future<void> _callLeagueLiveEventsCommonApiMethod() async {
    await _leagueLiveEventsBloc.leagueLiveEventsBlocMethod(
        context: context,
        leagueId: _leaguesId?.toString(),
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call League UpComing Events Api
  Future<void> _callLeagueUpComingEventsApiMethod() async {
    print("Call League Event Upcoming Api Method");

    _leagueUpcomingEventsBloc.initializeLeagueUpcomingEventsProvider(
        context: context);
    _leagueUpcomingEventsBloc.clearData(context: context);
    await _leagueUpcomingEventsBloc.leagueUpComingEventsBlocMethod(
        context: context,
        leagueId: _leaguesId?.toString(),
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  void _initialzeLiveEventsTimer() {
    _liveEventTimer?.cancel();
    _liveEventTimer = Timer.periodic(
      const Duration(seconds: 130),
      (timer) {
        // Update user about remaining time
        _callLeagueLiveEventsCommonApiMethod();
      },
    );
  }

  Future<void> _onRefreshIndicatorMethod() async {
    //If there is error in league data then first call league api
    if (_errorLeagueData == true) {
      await LeaguesService().callLeaguesApiMethod();
      _leaguesModelData = _leaguesProvider?.getSingleLeagueData;
      _errorLeagueData = _leaguesProvider?.getErrorLeagueData;

      _setLeaguesDataMethod(
          leaguesId: _leaguesModelData?.idLeague,
          leaguesSport: _leaguesModelData?.strLeagueSport,
          leaguesAbbreviation: _leaguesModelData?.strLeagueAbbreviation);

      print("Leagues Id:${_leaguesId}");
    }

    await _callNewsApiMethod();
    await _callLeagueLiveEventsCommonApiMethod();
    await _callLeagueUpComingEventsApiMethod();
  }

  void _setLeaguesDataMethod(
      {int? leaguesId, String? leaguesSport, String? leaguesAbbreviation}) {
    _leaguesId = leaguesId;
    _leagueSport = leaguesSport;
    _leagueAbbreviation = leaguesAbbreviation;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _liveEventTimer?.cancel();
    _newsBloc.setSearchTextNull();
    super.dispose();
  }
}

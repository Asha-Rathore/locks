import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/leagues/blocs/seasons_bloc.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/seasons_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/team_standings/blocs/sample_data.dart';
import 'package:locks_hybrid/team_standings/blocs/team_standings_bloc.dart';
import 'package:locks_hybrid/team_standings/blocs/team_standings_service.dart';
import 'package:locks_hybrid/team_standings/models/Team_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/provider/team_standings_provider.dart';
import 'package:locks_hybrid/team_standings/widgets/custom_conference_label_widget.dart';
import 'package:locks_hybrid/team_standings/widgets/custom_team_standings_widget.dart';
import 'package:locks_hybrid/team_standings/widgets/custom_year_filter_widget.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/utils.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class TeamStandingsScreen extends StatefulWidget {
  @override
  State<TeamStandingsScreen> createState() => _TeamStandingsScreenState();
}

class _TeamStandingsScreenState extends State<TeamStandingsScreen> {
  TeamStandingsService? _teamStandingsService;

  double _containerWidth = ((1.0.sw) / 2) - 25.w;

  TeamStandingsProvider? _teamStandingsProvider;
  TeamStandingsBloc _teamStandingsBloc = TeamStandingsBloc();
  SeasonsBloc _seasonsBloc = SeasonsBloc();

  int _conferenceSelectedId = 0;

  LeaguesProvider? _leaguesProvider;
  LeaguesModelData? _leaguesModelData;
  int? _leagueId;
  String? _leagueAbbreviation;
  SeasonsModel? _seasonsModel;
  String? _seasonYear;
  bool? _errorLeagueData;
  bool _apiCalledOnce = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_setData();
  }

  @override
  Widget build(BuildContext context) {
    _getSingleLeagueData();
    return CustomAppBackground(
        title: "${_leagueAbbreviation ?? ""} " + AppStrings.STANDINGS,
        actionWidget: _filterSeasonYearWidget(),
        child: _teamStandingsProvider?.getWaitingStatus == true
            ? Center(
                child: AppDialogs.circularProgressWidget(),
              )
            : (_teamStandingsProvider?.getTeamStandingsModel?.data?.length ??
                        0) >
                    0
                ? _mainStandingsWidget(
                    teamStandingsModel:
                        _teamStandingsProvider?.getTeamStandingsModel)
                : Center(
                    child: CustomErrorWidget(
                      errorImagePath: AssetPath.STANDINGS_ICON,
                      errorText: AppStrings.NO_TEAM_STANDINGS_FOUND_ERROR,
                      imageColor: AppColors.THEME_COLOR_WHITE,
                      imageSize: 60.h,
                    ),
                  ));
  }

  Widget _filterSeasonYearWidget() {
    return Visibility(
      visible: (_seasonsModel?.seasons?.length ?? 0) > 0 ? true : false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: GestureDetector(
            onTap: () {
              Utils.showCustomBottomSheet(
                  context: context,
                  filterBottomSheet: CustomYearFilterBottomSheet(
                    seasonsModel: _seasonsModel,
                    seasonYear: _seasonYear,
                    onSeasonYearChanged: (String? seasonYear) {
                      print("Season Year:${seasonYear}");
                      AppNavigation.navigatorPop(context);
                      if (_seasonYear != seasonYear) {
                        _seasonYear = seasonYear;
                        _conferenceSelectedId = 0;
                        _teamStandingsBloc.clearDataRebuild();
                        _callTeamStandingsApiMethod();
                      }
                    },
                  ));
            },
            child: CustomText(
              text: AppStrings.FILTER_TEXT,
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainStandingsWidget({TeamStandingsModel? teamStandingsModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0.h),
        _conferenceLabelListWidget(
            teamStandingsObject: teamStandingsModel?.data),
        SizedBox(height: 5.h),
        Expanded(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20.h),
              child: _teamStandingsWidgets(
                  teamStandingsObject: teamStandingsModel?.data)),
        ),
      ],
    );
  }

  Widget _conferenceLabelListWidget(
      {List<TeamStandingsModelData?>? teamStandingsObject}) {
    return Container(
      height: 60.h,
      //color: Colors.green,
      child: ListView.builder(
        itemCount: teamStandingsObject?.length ?? 0,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return _conferenceLabelsWidget(
              labelData: teamStandingsObject?[index]);
        }),
      ),
    );
  }

  Widget _conferenceLabelsWidget({TeamStandingsModelData? labelData}) {
    return Container(
        child: CustomConferenceLabelWidget(
      conferenceSelectedId: _conferenceSelectedId,
      conferenceId: labelData?.conferenceId,
      containerWidth: _containerWidth,
      labelName: labelData?.conferenceName,
      onTap: () {
        setState(() {
          _conferenceSelectedId = labelData?.conferenceId ?? 0;
        });
      },
    ));
  }

  Widget _teamStandingsWidgets(
      {List<TeamStandingsModelData?>? teamStandingsObject}) {
    return CustomTeamStandingsWidget(
      teamStandingsData:
          teamStandingsObject?[_conferenceSelectedId]?.conferenceData,
    );
  }

  void _setData() {
    // _teamStandingsService?.setTeamStandingsCommonModel(
    //     standingsType: LeagueType.NHL.name,
    //     standingsResponse: NHL_Standings_Response);

    // _teamStandingsService.setTeamStandingsCommonModel(
    //     standingsType: LeagueType.NFL.name,
    //     standingsResponse: NFL_Standings_Response);

    // _teamStandingsService.setTeamStandingsCommonModel(
    //     standingsType: LeagueType.NBA.name,
    //     standingsResponse: NBA_Standings_Response);

    // _teamStandingsService.setTeamStandingsCommonModel(
    //     standingsType: LeagueType.MLB.name,
    //     standingsResponse: MLB_Standings_Response);

    // _teamStandingsService.setTeamStandingsCommonModel(
    //     standingsType: LeagueType.MLS.name,
    //     standingsResponse: MLS_Standings_Response);
  }

  void _getSingleLeagueData() {
    _teamStandingsProvider =
        Provider.of<TeamStandingsProvider>(context, listen: true);
    _leaguesProvider = Provider.of<LeaguesProvider>(context, listen: true);
    _leaguesModelData = _leaguesProvider?.getSingleLeagueData;
    _errorLeagueData = _leaguesProvider?.getErrorLeagueData;

    if (_apiCalledOnce == false) {
      //If League has different Ids then call the apis
      if (_leagueId != _leaguesModelData?.idLeague &&
          _errorLeagueData == false) {
        _leagueId = _leaguesModelData?.idLeague;
        _leagueAbbreviation = _leaguesModelData?.strLeagueAbbreviation;
        print("League Abbreviation:${_leagueAbbreviation}");
        _apiCalledOnce = true;
        _callLeagueSeasonsApiMethod();
      } else if (_leagueId == null && _errorLeagueData == true) {
        print("League Abbreviation:${_leagueAbbreviation}");
        _apiCalledOnce = true;
        _callLeagueSeasonsApiMethod();
      }
    }
  }

  void _callLeagueSeasonsApiMethod() {
    _seasonsBloc.seasonsBlocMethod(
        leagueId: _leagueId,
        successSeasonData: (SeasonsModel? seasonsData) {
          if ((seasonsData?.seasons?.length ?? 0) > 0) {
            print("Seasons Data");
            _seasonsModel = seasonsData;
            _seasonYear = _seasonsModel?.seasons?[0]?.strSeason;
            _initializeTeamStandingsApiMethod();
          } else {
            _seasonsModel = null;
            _seasonYear = null;
            _initializeTeamStandingsApiMethod();
          }
        });
  }

  void _initializeTeamStandingsApiMethod() {
    // print("Season Year:${Constants.getSeasonData(seasonYear: seasonYear)}");
    _teamStandingsBloc.initializeTeamStandingsProvider(context: context);
    _callTeamStandingsApiMethod();
  }

  void _callTeamStandingsApiMethod() {
    _teamStandingsBloc.teamStandingsBlocMethod(
        context: context,
        standingsType: _leagueAbbreviation,
        seasonYear: Constants.getSeasonData(seasonYear: _seasonYear),
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _teamStandingsBloc.clearData();
    super.dispose();
  }
}

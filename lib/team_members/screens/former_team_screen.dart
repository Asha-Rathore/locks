import 'package:flutter/material.dart';
import 'package:locks_hybrid/team_members/blocs/former_team_bloc.dart';
import 'package:locks_hybrid/team_members/models/former_team_model.dart';
import 'package:locks_hybrid/team_members/widgets/custom_former_teams_widget.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';

class FormerTeamScreen extends StatefulWidget {
  String? playerId;

  FormerTeamScreen({this.playerId});

  @override
  State<FormerTeamScreen> createState() => _FormerTeamScreenState();
}

class _FormerTeamScreenState extends State<FormerTeamScreen> {
  FormerTeamBloc _formerTeamBloc = FormerTeamBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callFormerTeamApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    return _formerTeamStreamBuilderWidget();
  }

  Widget _formerTeamStreamBuilderWidget() {
    return StreamBuilder(
      stream: _formerTeamBloc.getFormerTeam(),
      builder: (BuildContext context,
          AsyncSnapshot<FormerTeamModel?>? formerTeamSnapshot) {
        return formerTeamSnapshot?.connectionState == ConnectionState.waiting
            ? _formerTeamShimmerListWidget()
            : (formerTeamSnapshot?.data?.formerteams?.length ?? 0) > 0
                ? _formerTeamListWidget(
                    formerTeamObject: formerTeamSnapshot?.data?.formerteams)
                : Center(
                    child: CustomErrorWidget(
                      errorImagePath: AssetPath.TEAMS_ICON,
                      errorText: AppStrings.NO_FORMER_TEAMS_FOUND_ERROR,
                      imageColor: AppColors.THEME_COLOR_WHITE,
                    ),
                  );
      },
    );
  }

  Widget _formerTeamListWidget(
      {List<FormerTeamModelFormerteams?>? formerTeamObject}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: formerTeamObject?.length ?? 0,
      itemBuilder: ((context, index) {
        return _formerTeamWidget(formerTeamData: formerTeamObject?[index]);
      }),
    );
  }

  Widget _formerTeamWidget({FormerTeamModelFormerteams? formerTeamData}) {
    return CustomFormerTeamsWidget(
      shimmerEnable: false,
      teamImagePath: formerTeamData?.strTeamBadge,
      sport: formerTeamData?.strSport,
      team: formerTeamData?.strFormerTeam,
      moveType: formerTeamData?.strMoveType,
      joinedDate: formerTeamData?.strJoined,
      departedDate: formerTeamData?.strDeparted,
    );
  }

  Widget _formerTeamShimmerListWidget(
      {List<FormerTeamModelFormerteams?>? formerTeamObject}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 2,
      itemBuilder: ((context, index) {
        return CustomFormerTeamsWidget(
          shimmerEnable: true,
          teamImagePath: null,
          sport: "Basketball",
          team: "Sacramento Kings",
          moveType: "Permanent",
          joinedDate: "2017",
          departedDate: "2020",
        );
      }),
    );
  }

  void _callFormerTeamApiMethod() {
    _formerTeamBloc.formerTeamBlocMethod(playerId: widget.playerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _formerTeamBloc.cancelStream();
    super.dispose();
  }
}

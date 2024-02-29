import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:provider/provider.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_route_name.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_teams_widget.dart';
import '../../widgets/custom_text.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  TeamsProvider? _teamsProvider;

  @override
  Widget build(BuildContext context) {
    _teamsProvider = Provider.of<TeamsProvider>(context, listen: true);
    return CustomAppBackground(
      title: AppStrings.TEAMS,
      child: _teamsWaitingListWidget(),
    );
  }

  Widget _teamsWaitingListWidget() {
    return _teamsProvider?.getWaitingStatus == true
        ? _teamsGridViewShimmerWidget()
        : (_teamsProvider?.getTeamsModel?.teams?.length ?? 0) > 0
            ? _teamsGridViewWidget(
                teamsObject: _teamsProvider?.getTeamsModel?.teams)
            : Center(
                child: CustomErrorWidget(
                  errorImagePath: AssetPath.TEAMS_ICON,
                  errorText: AppStrings.NO_TEAMS_FOUND_ERROR,
                  imageColor: AppColors.THEME_COLOR_WHITE,
                  imageSize: 65.h,
                ),
              );
  }

  Widget _teamsGridViewWidget({List<TeamsModelTeams?>? teamsObject}) {
    return CustomPadding(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            physics: BouncingScrollPhysics(),
            itemCount: teamsObject?.length ?? 0,
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
      onTap: (){
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
            padding: EdgeInsets.symmetric(vertical: 15.h),
            physics: BouncingScrollPhysics(),
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
}

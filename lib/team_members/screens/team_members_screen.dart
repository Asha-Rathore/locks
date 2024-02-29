import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/team_members/routing_arguments/team_members_routing_arguments.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/teams/provider/team_members_provider.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_teams_widget.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: AppStrings.TEAM_MEMBERS,
      child: _teamMembersWaitingListWidget(),
    );
  }

  Widget _teamMembersWaitingListWidget() {
    return Consumer<TeamMembersProvider>(
        builder: (context, teamMembersConsumerData, child) {
      return teamMembersConsumerData.getWaitingStatus == true
          ? _teamMembersGridViewShimmerWidget()
          : (teamMembersConsumerData.getTeamMembersModel?.player?.length ?? 0) >
                  0
              ? _teamMembersGridViewWidget(
                  teamMembersObject:
                      teamMembersConsumerData.getTeamMembersModel?.player)
              : Center(
                  child: CustomErrorWidget(
                    errorImagePath: AssetPath.TEAM_MEMBERS_ICON,
                    errorText: AppStrings.NO_TEAM_MEMBERS_FOUND_ERROR,
                    imageColor: AppColors.THEME_COLOR_WHITE,
                    imageSize: 60.h,
                  ),
                );
    });
  }

  Widget _teamMembersGridViewWidget(
      {List<TeamMembersModelPlayer?>? teamMembersObject}) {
    return CustomPadding(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            physics: BouncingScrollPhysics(),
            itemCount: teamMembersObject?.length ?? 0,
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

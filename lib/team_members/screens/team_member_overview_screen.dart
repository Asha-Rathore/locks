import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/team_members/blocs/honours_bloc.dart';
import 'package:locks_hybrid/team_members/blocs/milestones_bloc.dart';
import 'package:locks_hybrid/team_members/models/honours_model.dart';
import 'package:locks_hybrid/team_members/models/milestones_model.dart';
import 'package:locks_hybrid/team_members/provider/honours_provider.dart';
import 'package:locks_hybrid/team_members/provider/milestones_provider.dart';
import 'package:locks_hybrid/team_members/routing_arguments/honour_milestone_detail_routing_arguments.dart';
import 'package:locks_hybrid/team_members/widgets/custom_honour_milestone_widget.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_padding.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_progress_bar.dart';

class TeamMemberOverviewScreen extends StatefulWidget {
  final TeamMembersModelPlayer? teamMembersData;

  TeamMemberOverviewScreen({this.teamMembersData});

  @override
  State<TeamMemberOverviewScreen> createState() =>
      _TeamMemberOverviewScreenState();
}

class _TeamMemberOverviewScreenState extends State<TeamMemberOverviewScreen> {
  HonoursBloc _honoursBloc = HonoursBloc();
  MilestonesBloc _milestonesBloc = MilestonesBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callHonoursApiMethod();
    _callMilestonesApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _descriptionColumnWidget(),
          SizedBox(height: 10.h),
          _careerHonoursTextWidget(),
          SizedBox(height: 10.h),
          _careerHonoursWaitingListWidget(),
          SizedBox(height: 15.h),
          _careerMileStonesTextWidget(),
          SizedBox(height: 10.h),
          _careerMilestonesWaitingListWidget(),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _descriptionColumnWidget() {
    return CustomPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _descriptionTitle(),
          SizedBox(height: 9.h),
          _availableIn(),
          SizedBox(height: 8.h),
          _descriptionText(),
          SizedBox(height: 6.h),
          _divider(),
          _detailTextTitleWidget(
              title: AppStrings.BORN, text: "1996 (27 years old)"),
          _detailTextTitleWidget(
              title: AppStrings.BIRTH_PLACE,
              text: widget.teamMembersData?.strBirthLocation),
          _detailTextTitleWidget(
              title: AppStrings.PLAYER_POSITION,
              text: widget.teamMembersData?.strPosition),
          _detailTextTitleWidget(
              title: AppStrings.HEIGHT,
              text: widget.teamMembersData?.strHeight),
          _detailTextTitleWidget(
              title: AppStrings.WEIGHT,
              text: widget.teamMembersData?.strWeight),
          SizedBox(height: 10.h),
          _divider(),
        ],
      ),
    );
  }

  Widget _descriptionTitle() {
    return CustomText(
      text: AppStrings.DESCRIPTION,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.sp,
      textAlign: TextAlign.left,
    );
  }

  Widget _availableIn() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.5),
          child: CustomText(
            text: AppStrings.AVAILABLE_IN,
            fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
            fontFamily: AppFonts.Poppins_Medium,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(width: 10.w),
        _flagWidget(),
      ],
    );
  }

  Widget _flagWidget() {
    return Image.asset(
      Constants.getCountryImage(
              countryName: widget.teamMembersData?.strNationality) ??
          AssetPath.USA_FLAG,
      height: 12.0.h,
    );
  }

  Widget _descriptionText() {
    return CustomText(
      text: widget.teamMembersData?.strDescriptionEN,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Roboto_Regular,
      fontSize: 11.5.sp,
      textAlign: TextAlign.left,
      lineSpacing: 1.5,
    );
  }

  Widget _divider() {
    return Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: 0.3,
    );
  }

  Widget _detailTextTitleWidget({required String title, String? text}) {
    return Visibility(
      visible: text.checkNullEmptyText,
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
              fontFamily: AppFonts.Poppins_Medium,
              fontSize: 12.5.sp,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 6.w,
            ),
            Expanded(
              child: CustomText(
                text: text,
                fontColor: AppColors.THEME_COLOR_WHITE,
                fontFamily: AppFonts.Poppins_Medium,
                fontSize: 12.5.sp,
                textAlign: TextAlign.left,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _careerHonoursTextWidget() {
    return CustomPadding(
      child: CustomText(
        text: AppStrings.CAREER_HONOURS,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 16.sp,
        textAlign: TextAlign.left,
      ),
    );
  }

  ///------------------ Career Honours Start ---------------------///

  Widget _careerHonoursWaitingListWidget() {
    return Consumer<HonoursProvider>(
        builder: (context, honoursConsumerData, child) {
      return Column(
        children: [
          honoursConsumerData.getWaitingStatus == true
              ? _careerHonoursShimmerListViewWidget()
              : (honoursConsumerData.getHonoursModel?.honours?.length ?? 0) > 0
                  ? _careerHonoursListViewWidget(
                      honoursObject:
                          honoursConsumerData.getHonoursModel?.honours)
                  : Center(
                      child: CustomErrorWidget(
                        errorImagePath: AssetPath.HONOURS_ICON,
                        errorText: AppStrings.NO_CAREER_HONOURS_FOUND_ERROR,
                        imageColor: AppColors.THEME_COLOR_WHITE,
                        imageSize: 55.h,
                      ),
                    ),
        ],
      );
    });
  }

  Widget _careerHonoursListViewWidget(
      {List<HonoursModelHonours?>? honoursObject}) {
    return Container(
      height: 0.22.sh,
      child: ListView.builder(
          itemCount: honoursObject?.length ?? 0,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemBuilder: (BuildContext context, int index) {
            return _customCareerHonourWidget(honourData: honoursObject?[index]);
          }),
    );
  }

  Widget _customCareerHonourWidget({HonoursModelHonours? honourData}) {
    return CustomHonourMilestoneWidget(
      image: AssetPath.HONOUR2_ICON,
      imageType: MediaPathType.asset.name,
      honourMilestoneName: honourData?.strHonour,
      year: honourData?.strSeason,
      teamName: honourData?.strTeam,
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.HONOUR_MILESTONE_DETAIL_SCREEN_ROUTE,
            arguments: HonourMilestoneDetailRoutingArguments(
                type: HonourMilestoneType.honour.name,
                imagePath: AssetPath.HONOURS_ICON,
                playerName: honourData?.strPlayer,
                sport: honourData?.strSport,
                detail: honourData?.strHonour,
                teamName: honourData?.strTeam,
                date: honourData?.strSeason));
      },
      shimmerEnable: false,
    );
  }

  Widget _careerHonoursShimmerListViewWidget() {
    return Container(
      height: 0.22.sh,
      child: ListView.builder(
          itemCount: 2,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemBuilder: (BuildContext context, int index) {
            return CustomHonourMilestoneWidget(
              image: null,
              honourMilestoneName: AppStrings.MILESTONES,
              year: AppStrings.YEAR,
              teamName: AppStrings.TEAM_TEXT,
              shimmerEnable: true,
            );
          }),
    );
  }

  ///------------------ Career Honours End ---------------------///

  Widget _careerMileStonesTextWidget() {
    return CustomPadding(
      child: CustomText(
        text: AppStrings.CAREER_MILESTONES,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 16.sp,
        textAlign: TextAlign.left,
      ),
    );
  }

  ///------------------ Career Milestones Start ---------------------///

  Widget _careerMilestonesWaitingListWidget() {
    return Consumer<MilestonesProvider>(
        builder: (context, milestonesConsumerData, child) {
      return Column(
        children: [
          milestonesConsumerData.getWaitingStatus == true
              ? _careerMilestonesShimmerListViewWidget()
              : (milestonesConsumerData
                              .getMilestonesModel?.milestones?.length ??
                          0) >
                      0
                  ? _careerMilestoneListViewWidget(
                      milestonesObject:
                          milestonesConsumerData.getMilestonesModel?.milestones)
                  : Center(
                      child: CustomErrorWidget(
                        errorImagePath: AssetPath.MILESTONE_ICON,
                        errorText: AppStrings.NO_CAREER_MILESTONES_FOUND_ERROR,
                        imageColor: AppColors.THEME_COLOR_WHITE,
                        imageSize: 50.h,
                      ),
                    ),
        ],
      );
    });
  }

  Widget _careerMilestoneListViewWidget(
      {List<MilestonesModelMilestones?>? milestonesObject}) {
    return Container(
      height: 0.22.sh,
      child: ListView.builder(
          itemCount: milestonesObject?.length ?? 0,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemBuilder: (BuildContext context, int index) {
            return _customCareerMilestoneWidget(
                milestoneData: milestonesObject?[index]);
          }),
    );
  }

  Widget _customCareerMilestoneWidget(
      {MilestonesModelMilestones? milestoneData}) {
    return CustomHonourMilestoneWidget(
      image: milestoneData?.strMilestoneLogo,
      honourMilestoneName: milestoneData?.strMilestone,
      year: Constants.getMilestoneYear(
          milestoneDate: milestoneData?.dateMilestone),
      teamName: milestoneData?.strTeam,
      shimmerEnable: false,
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.HONOUR_MILESTONE_DETAIL_SCREEN_ROUTE,
            arguments: HonourMilestoneDetailRoutingArguments(
                type: HonourMilestoneType.milestone.name,
                imagePath: milestoneData?.strMilestoneLogo,
                playerName: milestoneData?.strPlayer,
                sport: milestoneData?.strSport,
                detail: milestoneData?.strMilestone,
                teamName: milestoneData?.strTeam,
                date: Constants.getMilestoneYear(
                    milestoneDate: milestoneData?.dateMilestone)));
      },
    );
  }

  Widget _careerMilestonesShimmerListViewWidget() {
    return Container(
      height: 0.22.sh,
      child: ListView.builder(
          itemCount: 2,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          itemBuilder: (BuildContext context, int index) {
            return CustomHonourMilestoneWidget(
              image: null,
              honourMilestoneName: AppStrings.MILESTONES,
              year: AppStrings.YEAR,
              teamName: AppStrings.TEAM_TEXT,
              shimmerEnable: true,
            );
          }),
    );
  }

  ///------------------ Career Milestones End ---------------------///

  //It will call Honours Api
  void _callHonoursApiMethod() {
    _honoursBloc.initializeHonoursProvider(context: context);
    _honoursBloc.clearData(context: context);
    _honoursBloc.honoursBlocMethod(
        context: context,
        playerId: widget.teamMembersData?.idPlayer,
        apiTimeStamp: Constants.getApiTimesTamp());
  }

  //It will call Milestones Api
  void _callMilestonesApiMethod() {
    _milestonesBloc.initializeMilestonesProvider(context: context);
    _milestonesBloc.clearData(context: context);
    _milestonesBloc.milestonesBlocMethod(
        context: context,
        playerId: widget.teamMembersData?.idPlayer,
        apiTimeStamp: Constants.getApiTimesTamp());
  }
}

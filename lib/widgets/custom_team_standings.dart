import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'custom_text.dart';

class CustomTeamStandingsContainer extends StatelessWidget {
  final String? league;
  final int? teamLength;
  const CustomTeamStandingsContainer({
    super.key,
    this.league,
    this.teamLength = 3,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_DARK_GREEN,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.THEME_COLOR_WHITE.withOpacity(0.16),
                offset: const Offset(
                  1.0,
                  1.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 18.h),
              _league(),
              SizedBox(height: 18.h),
              _table(),
              // _teamsText(),
              // _teamsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _table() {
    return Table(
      // defaultColumnWidth: FlexColumnWidth(200),
      columnWidths: const {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(4.5),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1),
            },
      children: [
        TableRow(
          children: [
            _teamsText(),
          ],
        ),
        TableRow(
          children: [
            _teamsList(),
          ],
        ),
      ],
    );
  }

  Widget _league() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AssetPath.LEAGUE_ICON,
          scale: 4,
        ),
        SizedBox(width: 10.w),
        CustomText(
          text: league,
          fontColor: AppColors.THEME_COLOR_WHITE,
          fontFamily: AppFonts.Poppins_SemiBold,
          fontSize: 14.sp,
        ),
      ],
    );
  }

  

  Widget _blackText(text, align) {
    return CustomText(
      text: text,
      fontColor: AppColors.PRIMARY_COLOR,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 16.sp,
      textAlign: align,
    );
  }

  Widget _teamsList() {
    return ListView.builder(
      itemCount: teamLength,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return _teams(
          count: "${index + 1}",
          showDivider: index == (teamLength! - 1) ? false : true,
          teamName: AppStrings.teamList['TeamList'][index]['name'],
          flag: AppStrings.teamList['TeamList'][index]['flag'],
          played: AppStrings.teamList['TeamList'][index]['played'],
          won: AppStrings.teamList['TeamList'][index]['won'],
          loss: AppStrings.teamList['TeamList'][index]['loss'],
          points: AppStrings.teamList['TeamList'][index]['points'],
        );
      }),
    );
  }

  Widget _teams(
      {String? count,
      String? teamName,
      bool? showDivider,
      String? flag,
      int? played,
      int? won,
      int? loss,
      int? points}) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 8.w),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    _whiteText(count, TextAlign.left),
                    SizedBox(width: 10.w),
                    Expanded(child: _whiteText(teamName, TextAlign.left)),
                  ],
                ),
              ),
              // Spacer(),
              Expanded(
                child: Image.asset(
                  flag!,
                  scale: 3,
                ),
              ),
              // SizedBox(width: 10.w),
              Expanded(child: _whiteText(played.toString(), TextAlign.center)),
              // SizedBox(width: 20.w),
              Expanded(child: _whiteText(won.toString(), TextAlign.center)),
              // SizedBox(width: 20.w),
              Expanded(child: _whiteText(loss.toString(), TextAlign.center)),
              // SizedBox(width: 20.w),
              Expanded(child: _whiteText(points.toString(), TextAlign.center)),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        showDivider! ? _divider() : SizedBox(height: 10.h),
      ],
    );
  }

  Widget _teamsText() {
    return Container(
      color: AppColors.THEME_COLOR_LIGHT_GREEN,
      child: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 8.w,  top: 15.h, bottom: 15.h),
        child: Row(
          children: [
            // Expanded(flex: , child: SizedBox(width: 2.w)),
            Expanded(flex: 5, child: _blackText(AppStrings.TEAMS, TextAlign.left)),
            // Spacer(),
            Expanded(child: SizedBox(width: 20.w)),
            Expanded(child: _blackText(AppStrings.P, TextAlign.center)),
            // SizedBox(width: 20.w),
            Expanded(child: _blackText(AppStrings.W, TextAlign.center)),
            // SizedBox(width: 20.w),
            Expanded(child: _blackText(AppStrings.L, TextAlign.center)),
            // SizedBox(width: 20.w),
            Expanded(child: _blackText(AppStrings.PT, TextAlign.center)),
          ],
        ),
      ),
    );
  }

  Widget _whiteText(text, align) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.sp,
      textAlign: align,
    );
  }

  Widget _divider() {
    return const Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: 0.3,
    );
  }
}

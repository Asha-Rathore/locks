import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/team_standings/models/Team_Standings_Model.dart';
import 'package:locks_hybrid/team_standings/widgets/custom_team_standing_row_widget.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomTeamStandingsWidget extends StatelessWidget {
  final List<TeamStandingsModelDataConferenceData?>? teamStandingsData;
  List<TableRow> _standingsRowWidget = [];

  CustomTeamStandingsWidget({this.teamStandingsData});

  @override
  Widget build(BuildContext context) {
    _setStandingsRowWidget();
    // return CustomPadding(
    //   child: Padding(
    //     padding: const EdgeInsets.only(bottom: 35.0),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: AppColors.THEME_COLOR_DARK_GREEN,
    //         borderRadius: BorderRadius.circular(10.r),
    //         boxShadow: [
    //           BoxShadow(
    //             color: AppColors.THEME_COLOR_WHITE.withOpacity(0.16),
    //             offset: const Offset(
    //               1.0,
    //               1.0,
    //             ),
    //             blurRadius: 10.0,
    //             spreadRadius: 0,
    //           ),
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           SizedBox(height: 18.h),
    //           _league(),
    //           SizedBox(height: 18.h),
    //           _table(),
    //           // _teamsText(),
    //           // _teamsList(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return CustomPadding(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.THEME_COLOR_DARK_GREEN,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r)),
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
            // SizedBox(height: 18.h),
            _table(),
            // _teamsText(),
            // _teamsList(),
          ],
        ),
      ),
    );
  }

  Widget _table() {
    return Table(
        // defaultColumnWidth: FlexColumnWidth(200),
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white, width: 0.7),
          verticalInside: BorderSide(

              style: BorderStyle.none),
        ),
        columnWidths: {
          0: FlexColumnWidth(0.95),
          1: FlexColumnWidth(4.0),
          2: FlexColumnWidth(1.1),
          3: FlexColumnWidth(1.1),
          4: FlexColumnWidth(1.1),
          5: FlexColumnWidth(1.1),
          6: FlexColumnWidth(1.1),
        },
        children: _standingsRowWidget);
  }

  void _setStandingsRowWidget() {
    for (int i = 0; i < (teamStandingsData?.length ?? 0); i++) {
      _standingsRowWidget.add(_tableRowWidget(
          rank: teamStandingsData?[i]?.teamRank,
          teamName: teamStandingsData?[i]?.teamName,
          fieldOne: teamStandingsData?[i]?.fieldOne,
          fieldTwo: teamStandingsData?[i]?.fieldTwo,
          fieldThree: teamStandingsData?[i]?.fieldThree,
          fieldFour: teamStandingsData?[i]?.fieldFour,
          fieldFive: teamStandingsData?[i]?.fieldFive,
          index: i));
    }
  }

  TableRow _tableRowWidget(
      {String? rank,
      String? teamName,
      String? fieldOne,
      String? fieldTwo,
      String? fieldThree,
      String? fieldFour,
      String? fieldFive,
      int? index}) {
    return TableRow(
      children: [
        _textWidget(
            text: index == 0 ? rank : index?.toString(),
            textAlign: TextAlign.left,
            index: index,
            paddingLeft: 5.w),
        _textWidget(
            text: teamName,
            textAlign: TextAlign.left,
            index: index,
            containerAlignment: Alignment.topLeft,
            maxLines: 2),
        _textWidget(text: fieldOne, index: index, maxLines: 2),
        _textWidget(text: fieldTwo, index: index),
        _textWidget(text: fieldThree, index: index),
        _textWidget(text: fieldFour, index: index),
        _textWidget(text: fieldFive, index: index, paddingRight: 1.w),
      ],
    );
  }

  Widget _textWidget(
      {int? index,
      String? text,
      TextAlign? textAlign,
      double? paddingLeft,
      double? paddingRight,
      Alignment? containerAlignment,
      int? maxLines}) {
    return Container(
      alignment: containerAlignment ?? Alignment.center,
      padding: EdgeInsets.only(
          top: 15.h,
          bottom: 15.h,
          left: paddingLeft ?? 0,
          right: paddingRight ?? 0),
      decoration: BoxDecoration(
          color: index == 0
              ? AppColors.THEME_COLOR_LIGHT_GREEN
              : AppColors.THEME_COLOR_TRANSPARENT,
          border: Border.all(
              color: index == 0
                  ? AppColors.THEME_COLOR_LIGHT_GREEN
                  : AppColors.THEME_COLOR_TRANSPARENT,width: 0.0)),
      child: CustomText(
        text: text,
        fontColor: index == 0
            ? AppColors.THEME_COLOR_BLACK
            : AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: index == 0 ? 13.sp : 12.sp,
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines ?? 1,
        textOverflow: TextOverflow.ellipsis,
        lineSpacing: 1.2,
      ),
    );
  }
}

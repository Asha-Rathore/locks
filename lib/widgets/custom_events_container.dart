import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_circular_profile.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_season_event_circular_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomEventsContainer extends StatelessWidget {
  final String? eventDay,
      eventDate,
      eventStadiumPlace,
      firstTeamName,
      secondTeamName,
      eventTime,
      gameTitle,
      firstTeamLogo,
      secondTeamLogo,
      firstTeamScore,
      secondTeamScore;
  final bool? shimmerEnable, showButton, showBoxShadow, showScore;
  final VoidCallback? onFirstTeamTap, onSecondTeamTap;

  const CustomEventsContainer(
      {this.shimmerEnable,
      this.eventDay,
      this.eventDate,
      this.eventStadiumPlace,
      this.firstTeamName,
      this.secondTeamName,
      this.eventTime,
      this.gameTitle,
      this.firstTeamLogo,
      this.secondTeamLogo,
      this.showButton,
      this.showBoxShadow = true,
      this.firstTeamScore,
      this.secondTeamScore,
      this.showScore = false,
      this.onFirstTeamTap,
      this.onSecondTeamTap});

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Container(
        height: showButton == true ? 180.h : 157.h,
        width: 1.sw,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: showButton == true ? 165.h : 157.h,
                          decoration: BoxDecoration(
                            color: AppColors.THEME_COLOR_DARK_GREEN,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: showBoxShadow!
                                ? [
                                    BoxShadow(
                                      color: AppColors.THEME_COLOR_WHITE
                                          .withOpacity(0.16),
                                      offset: const Offset(
                                        1.0,
                                        1.0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: 0,
                                    ),
                                  ]
                                : [],
                          ),
                          child: shimmerEnable == false
                              ? _eventMainContainerWidget()
                              : CustomShimmerWidget(
                                  child: _eventMainContainerWidget(),
                                )),
                    ),
                    shimmerEnable == false
                        ? _gameTitleWidget()
                        : CustomShimmerWidget(
                            child: _gameTitleWidget(),
                          )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _eventMainContainerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          _dateAndLocation(),
          SizedBox(height: 10.h),
          Container(
              height: 80.h,
              // color: Colors.red,
              child: _teamsWidget()),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }

  Widget _dateAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eventDay(),
            SizedBox(height: 5.h),
            _eventDate(),
          ],
        ),
        SizedBox(
          width: 20.w,
        ),
        Flexible(child: _titleWidget(title: eventStadiumPlace, maxlines: 2)),
      ],
    );
  }

  Widget _teamsWidget() {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _teamLogoTitleWidget(
            teamLogo: firstTeamLogo,
            teamName: firstTeamName,
            onTap: onFirstTeamTap),
        SizedBox(width: 7.w),
        _verticalDivider(),
        SizedBox(width: 8.w),
        Expanded(
          child: showScore == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _scoreContainer(firstTeamScore ?? "0"),
                    SizedBox(width: 5.w),
                    _scoreContainer(secondTeamScore ?? "0")
                  ],
                )
              : _titleWidget(title: eventTime),
        ),
        SizedBox(width: 7.w),
        _verticalDivider(),
        SizedBox(width: 8.w),
        _teamLogoTitleWidget(
            teamLogo: secondTeamLogo,
            teamName: secondTeamName,
            alignment: Alignment.topRight,
            onTap: onSecondTeamTap),
      ],
    );
  }

  Widget _eventDay() {
    return _titleWidget(
      title: eventDay,
      fontSize: 14.sp,
    );
  }

  Widget _eventDate() {
    return _titleWidget(
      title: eventDate,
      color: AppColors.THEME_COLOR_LIGHT_GREEN,
    );
  }

  Widget _teamLogoTitleWidget(
      {String? teamLogo,
      String? teamName,
      VoidCallback? onTap,
      AlignmentGeometry? alignment}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75.h,
        //alignment: alignment ?? Alignment.topLeft,
        margin: EdgeInsets.only(top: 5.h),
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _teamLogo(logoImage: teamLogo),
            SizedBox(height: 10.h),
            Container(
              height: 27.h,
                child: _titleWidget(title: teamName, maxlines: 2)),
          ],
        ),
      ),
    );
  }

  Widget _teamLogo({String? logoImage}) {
    return CustomSeasonEventCircularImageWidget(image: logoImage);
  }

  Widget _verticalDivider() {
    return Container(
      height: 80.h,
      width: 0.5.w,
      color: AppColors.THEME_COLOR_WHITE,
    );
  }

  Widget _gameTitleWidget() {
    return Visibility(
      visible: showButton == true ? true : false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 30.h),
            child: _titleWidget(
                title: gameTitle,
                color: AppColors.THEME_COLOR_DARK_GREEN,
                containerColor: AppColors.THEME_COLOR_LIGHT_GREEN),
          ),
        ),
      ),
    );
  }

  Widget _scoreContainer(text) {
    return Container(
      width: 0.1.sw,
      decoration: BoxDecoration(
        color: AppColors.THEME_COLOR_LIGHT_GREEN,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: _titleWidget(
            title: text,
            color: AppColors.THEME_COLOR_DARK_GREEN,
            containerColor: AppColors.THEME_COLOR_TRANSPARENT,
            fontSize: 12.sp,
            lineSpacing: 0
          )),
    );
  }

  Widget _titleWidget(
      {String? title,
      Color? color,
      double? fontSize,
      int? maxlines,
        double? lineSpacing,
      Color? containerColor}) {
    return Container(
      color: containerColor ?? AppColors.THEME_COLOR_DARK_GREEN,
      child: CustomText(
        text: title,
        fontColor: color ?? AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: fontSize ?? 12.sp,
        maxLines: maxlines ?? 1,
        textOverflow: TextOverflow.ellipsis,
        lineSpacing: lineSpacing ?? 1,
      ),
    );
  }
}

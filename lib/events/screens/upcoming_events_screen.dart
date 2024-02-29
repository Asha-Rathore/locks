import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_events_container.dart';

import '../../utils/app_colors.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_filter_icon.dart';

class UpcomingEventsScreen extends StatelessWidget {
  final bool? isFromLeagues;

  const UpcomingEventsScreen({super.key, this.isFromLeagues = false});

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: AppStrings.UPCOMING_EVENTS,
      actionWidget: _filterIcon(context),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          isFromLeagues! ? _leaguesUpcomingEventsList() : _upcomingEventsList(),
        ],
      ),
    );
  }

  Widget _filterIcon(context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: CustomFilterIcon(
        backgroundColor: AppColors.THEME_COLOR_LIGHT_GREEN,
        iconColor: AppColors.PRIMARY_COLOR,
        height: 35.h,
        width: 40.w,
        scale: 4,
        onTap: () {
          //Utils.showCustomBottomSheet(context: context);
        },
      ),
    );
  }

  Widget _upcomingEventsList() {
    return Expanded(
      child: ListView.builder(
        itemCount:
            AppStrings.viewAllUpComingEventsList['UpcomingEvents'].length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              // AppNavigation.navigateTo(
              //     context, AppRouteName.UPCOMING_EVENTS_DETAIL_SCREEN_ROUTE,
              //     arguments: UpcomingEventsRoutingArgument(
              //       day: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //           [index]['day'],
              //       date: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //           [index]['date'],
              //       place:
              //           AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //               [index]['place'],
              //       firstTeamName:
              //           AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //               [index]['firstTeam'],
              //       secTeamName:
              //           AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //               [index]['secondTeam'],
              //       time: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //           [index]['time'],
              //       game: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //           [index]['game'],
              //       firstTeamLogo:
              //           AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //               [index]['firstTeamLogo'],
              //       secTeamLogo:
              //           AppStrings.viewAllUpComingEventsList['UpcomingEvents']
              //               [index]['secTeamLogo'],
              //     ));
            },
            child: CustomEventsContainer(
              eventDay: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                  ['day'],
              eventDate: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                  [index]['date'],
              eventStadiumPlace: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                  [index]['place'],
              firstTeamName:
                  AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                      ['firstTeam'],
              secondTeamName:
                  AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                      ['secondTeam'],
              eventTime: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                  [index]['time'],
              gameTitle: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                  [index]['game'],
              firstTeamLogo:
                  AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                      ['firstTeamLogo'],
              secondTeamLogo:
                  AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                      ['secTeamLogo'],
              showButton: true,
              onFirstTeamTap: () {
                // AppNavigation.navigateTo(
                //   context,
                //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
                //   arguments: TeamsDetailArguments(
                //       title: AppStrings.INTER_MIAMI, image: AssetPath.TEAM1),
                // );
              },
              onSecondTeamTap: () {
                // AppNavigation.navigateTo(
                //   context,
                //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
                //   arguments: TeamsDetailArguments(
                //       title: AppStrings.CHARLOTTE_FC, image: AssetPath.TEAM1),
                // );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _leaguesUpcomingEventsList() {
    return Expanded(
      child: ListView.builder(
        itemCount:
            AppStrings.viewAllUpComingEventsList['UpcomingEvents'].length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: ((context, index) {
          return CustomEventsContainer(
            showBoxShadow: false,
            eventDay: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                ['day'],
            eventDate: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                ['date'],
            eventStadiumPlace: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                ['place'],
            firstTeamName:
                AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                    ['firstTeam'],
            secondTeamName: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                [index]['secondTeam'],
            eventTime: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                ['time'],
            gameTitle: AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                ['game'],
            firstTeamLogo:
                AppStrings.viewAllUpComingEventsList['UpcomingEvents'][index]
                    ['firstTeamLogo'],
            secondTeamLogo: AppStrings.viewAllUpComingEventsList['UpcomingEvents']
                [index]['secTeamLogo'],
            showButton: true,
          );
        }),
      ),
    );
  }
}

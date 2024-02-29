// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
// import 'package:locks_hybrid/upcoming_events/widgets/custom_scroll_container.dart';
// import 'package:locks_hybrid/utils/app_colors.dart';
// import 'package:locks_hybrid/utils/app_fonts.dart';
// import 'package:locks_hybrid/utils/app_navigation.dart';
// import 'package:locks_hybrid/utils/app_route_name.dart';
// import 'package:locks_hybrid/utils/app_strings.dart';
// import 'package:locks_hybrid/utils/asset_paths.dart';
// import 'package:locks_hybrid/widgets/custom_app_background.dart';
// import 'package:locks_hybrid/widgets/custom_padding.dart';
// import 'package:locks_hybrid/widgets/custom_text.dart';
//
// import '../../widgets/custom_upcoming_events_container.dart';
//
// class UpcomingEventsDetailScreen extends StatelessWidget {
//   final String? day,
//       date,
//       time,
//       place,
//       firstTeamName,
//       secTeamName,
//       firstTeamLogo,
//       secTeamLogo,
//       game;
//   const UpcomingEventsDetailScreen({
//     super.key,
//     this.date,
//     this.time,
//     this.day,
//     this.firstTeamLogo,
//     this.firstTeamName,
//     this.game,
//     this.place,
//     this.secTeamLogo,
//     this.secTeamName,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomAppBackground(
//       title: AppStrings.UPCOMING_EVENTS,
//       child: Column(
//         children: [
//           SizedBox(height: 10.h),
//           _upcomingEvent(context: context),
//           SizedBox(height: 10.h),
//           _scrollContainer(),
//         ],
//       ),
//     );
//   }
//
//   Widget _upcomingEvent({required BuildContext context}) {
//     return CustomUpcomingEventsContainer(
//       day: day,
//       date: date,
//       place: place,
//       firstTeamName: firstTeamName,
//       secTeamName: secTeamName,
//       time: time,
//       game: game,
//       firstTeamLogo: firstTeamLogo,
//       secTeamLogo: secTeamLogo,
//       showButton: true,
//       onFirstTeamTap: (){
//         // AppNavigation.navigateTo(
//         //   context,
//         //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
//         //   arguments: TeamsDetailArguments(
//         //       title: AppStrings.INTER_MIAMI,
//         //       image: AssetPath.TEAM1
//         //   ),
//         // );
//       },
//       onSecondTeamTap: (){
//         // AppNavigation.navigateTo(
//         //   context,
//         //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
//         //   arguments: TeamsDetailArguments(
//         //       title:AppStrings.CHARLOTTE_FC,
//         //       image: AssetPath.TEAM1
//         //   ),
//         // );
//       },
//     );
//   }
//
//   Widget _scrollContainer() {
//     return Expanded(
//       child: CustomScrollContainer(
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),
//             CustomPadding(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _italicText(AppStrings.HEAD_TO_HEAD_RECORDS),
//                   _totalText(),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20.h),
//             _eventListView(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _italicText(text) {
//     return CustomText(
//       text: text,
//       fontStyle: FontStyle.italic,
//       fontColor: AppColors.THEME_COLOR_WHITE,
//       fontFamily: AppFonts.Poppins_Medium,
//       fontSize: 16.sp,
//     );
//   }
//
//   Widget _totalText() {
//     return RichText(
//       textAlign: TextAlign.center,
//       text: TextSpan(
//         style: TextStyle(
//           color: AppColors.THEME_COLOR_LIGHT_GREEN,
//           fontSize: 14.sp,
//           fontFamily: AppFonts.Poppins_Medium,
//           decoration: TextDecoration.underline,
//         ),
//         children: <TextSpan>[
//           const TextSpan(text: AppStrings.TOTAL),
//           TextSpan(
//             text: "05",
//             style: TextStyle(
//               color: AppColors.THEME_COLOR_LIGHT_GREEN,
//               fontSize: 14.sp,
//               fontFamily: AppFonts.Poppins_Bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _eventListView() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: AppStrings.upCommingMatches['upComingMatchesData'].length,
//         physics: const BouncingScrollPhysics(),
//         itemBuilder: ((context, index) {
//           return Column(
//             children: [
//               Visibility(
//                 visible: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonTitle'] !=
//                     "",
//                 child: Column(
//                   children: [
//                     _italicText(
//                       AppStrings.upCommingMatches['upComingMatchesData'][index]
//                           ['seasonTitle'],
//                     ),
//                     SizedBox(height: 20.h),
//                   ],
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: AppStrings
//                     .upCommingMatches['upComingMatchesData'][index]
//                         ['seasonDetails']
//                     .length,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: ((context, i) {
//                   return CustomUpcomingEventsContainer(
//                     backgroundColor: AppColors.PRIMARY_COLOR,
//                     showBoxShadow: false,
//                     showScore: true,
//                     day: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonDetails'][i]['day'],
//                     date: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonDetails'][i]['date'],
//                     place: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonDetails'][i]['place'],
//                     firstTeamName:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['firstTeam'],
//                     secTeamName:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['secondTeam'],
//                     time: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonDetails'][i]['time'],
//                     game: AppStrings.upCommingMatches['upComingMatchesData']
//                         [index]['seasonDetails'][i]['game'],
//                     firstTeamLogo:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['firstTeamLogo'],
//                     secTeamLogo:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['secTeamLogo'],
//                     firstTeamScore:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['firstTeamScore'],
//                     secTeamScore:
//                         AppStrings.upCommingMatches['upComingMatchesData']
//                             [index]['seasonDetails'][i]['secTeamScore'],
//                     onFirstTeamTap: (){
//                       // AppNavigation.navigateTo(
//                       //   context,
//                       //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
//                       //   arguments: TeamsDetailArguments(
//                       //       title: AppStrings.INTER_MIAMI,
//                       //       image: AssetPath.TEAM1,
//                       //
//                       //   ),
//                       // );
//                     },
//                     onSecondTeamTap: (){
//                       // AppNavigation.navigateTo(
//                       //   context,
//                       //   AppRouteName.TEAM_DETAILS_SCREEN_ROUTE,
//                       //   arguments: TeamsDetailArguments(
//                       //       title:AppStrings.CHARLOTTE_FC,
//                       //       image: AssetPath.TEAM1,
//                       //
//                       //   ),
//                       // );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//   // Widget _eventListView() {
//   //   return Expanded(
//   //     child: ListView.builder(
//   //       itemCount: AppStrings.upComingEventsDetailList['UpcomingEvents'].length,
//   //       physics: const BouncingScrollPhysics(),
//   //       itemBuilder: ((context, index) {
//   //         return Column(
//   //           children: [
//   //             CustomUpcomingEventsContainer(
//   //               backgroundColor: AppColors.PRIMARY_COLOR,
//   //               showBoxShadow: false,
//   //               showButton: false,
//   //               showScore: true,
//   //               day: AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                   ['day'],
//   //               date: AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                   ['date'],
//   //               place: AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                   ['place'],
//   //               firstTeamName:
//   //                   AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                       ['firstTeam'],
//   //               secTeamName: AppStrings.upComingEventsDetailList['UpcomingEvents']
//   //                   [index]['secondTeam'],
//   //               time: AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                   ['time'],
//   //               game: AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                   ['game'],
//   //               firstTeamLogo:
//   //                   AppStrings.upComingEventsDetailList['UpcomingEvents'][index]
//   //                       ['firstTeamLogo'],
//   //               secTeamLogo: AppStrings.upComingEventsDetailList['UpcomingEvents']
//   //                   [index]['secTeamLogo'],
//   //               firstTeamScore: AppStrings.upComingEventsDetailList['UpcomingEvents']
//   //                   [index]['firstTeamScore'],
//   //               secTeamScore: AppStrings.upComingEventsDetailList['UpcomingEvents']
//   //                   [index]['secTeamScore'],
//   //             ),
//   //           ],
//   //         );
//   //       }),
//   //     ),
//   //   );
//   // }
// }

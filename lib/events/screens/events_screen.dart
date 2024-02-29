// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:locks_hybrid/utils/app_colors.dart';
// import 'package:locks_hybrid/utils/app_fonts.dart';
// import 'package:locks_hybrid/utils/app_strings.dart';
// import 'package:locks_hybrid/widgets/custom_app_background.dart';
// import 'package:locks_hybrid/widgets/custom_leagues_container.dart';
// import 'package:locks_hybrid/widgets/custom_padding.dart';
// import 'package:locks_hybrid/widgets/custom_text.dart';
//
// import '../../utils/app_navigation.dart';
// import '../../utils/app_route_name.dart';
// import '../../utils/asset_paths.dart';
// import '../routing_arguments/upcoming_event_routing_arguments.dart';
//
// class EventsScreen extends StatelessWidget {
//   const EventsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomAppBackground(
//       title: AppStrings.UPCOMING_EVENTS,
//       child: Column(
//         children: [
//           SizedBox(height: 15.h),
//           _eventsGridView(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _eventsGridView(context) {
//     return Expanded(
//       child: CustomPadding(
//         child: GridView.count(
//           physics: const BouncingScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 14.0,
//           shrinkWrap: false,
//           children: List.generate(
//             AppStrings.eventsList['Events'].length,
//             (index) {
//               return GestureDetector(
//                 onTap: () {
//                   AppNavigation.navigateTo(
//                       context, AppRouteName.UPCOMING_EVENTS_DETAIL_SCREEN_ROUTE,
//                       arguments: UpcomingEventsRoutingArgument(
//                         day: AppStrings.SATURDAY,
//                         date: AppStrings.TEMP_JULY_DATE,
//                         place: AppStrings.LOREM_IPSUM_STADIUM,
//                         firstTeamName: AppStrings.INTER_MIAMI,
//                         secTeamName: AppStrings.CHARLOTTE_FC,
//                         time: AppStrings.TEMP_TIME,
//                         game: AppStrings.SOCCER,
//                         firstTeamLogo: AssetPath.TEAM1LOGO,
//                         secTeamLogo: AssetPath.TEAM2LOGO,
//                       ));
//                 },
//                 child: CustomLeaguesContainer(
//                   image: AppStrings.eventsList['Events'][index]['image'],
//                   child: _text(
//                       text: AppStrings.eventsList['Events'][index]['name']),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _text({String? text}) {
//     return CustomPadding(
//       child: CustomText(
//         text: text,
//         fontColor: AppColors.THEME_COLOR_WHITE,
//         fontFamily: AppFonts.Poppins_Medium,
//         fontSize: 12.sp,
//         lineSpacing: 1.3,
//       ),
//     );
//   }
// }

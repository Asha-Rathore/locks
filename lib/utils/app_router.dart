import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/routing_arguments/otp_arguments.dart';
import 'package:locks_hybrid/auth/screens/login_screen.dart';
import 'package:locks_hybrid/auth/screens/phone_login_screen.dart';
import 'package:locks_hybrid/auth/screens/pre_login_screen.dart';
import 'package:locks_hybrid/auth/screens/verification_screen.dart';
import 'package:locks_hybrid/events/routing_arguments/events_routing_arguments.dart';
import 'package:locks_hybrid/events/screens/events_list_screen.dart';
import 'package:locks_hybrid/events/screens/upcoming_events_screen.dart';
import 'package:locks_hybrid/latest_news/routing_arguments/latest_news_detail_arguments.dart';
import 'package:locks_hybrid/latest_news/screens/latest_news_detail_screen.dart';
import 'package:locks_hybrid/latest_news/screens/latest_news_screen.dart';
import 'package:locks_hybrid/leagues/screen/leagues_detail_screen.dart';
import 'package:locks_hybrid/main_menu/screens/main_screen.dart';
import 'package:locks_hybrid/notifications/screen/notification_screen.dart';
import 'package:locks_hybrid/profile/screens/complete_profile_screen.dart';
import 'package:locks_hybrid/team_members/routing_arguments/honour_milestone_detail_routing_arguments.dart';
import 'package:locks_hybrid/team_members/routing_arguments/team_members_routing_arguments.dart';
import 'package:locks_hybrid/team_members/screens/honour_milestone_detail_screen.dart';
import 'package:locks_hybrid/team_members/screens/team_member_detail_screen.dart';
import 'package:locks_hybrid/team_members/screens/team_members_screen.dart';
import 'package:locks_hybrid/team_standings/screens/team_standings_screen.dart';
import 'package:locks_hybrid/teams/routing_arguments/teams_detail_arguments.dart';
import 'package:locks_hybrid/teams/screens/teams_detail_screen.dart';
import 'package:locks_hybrid/teams/screens/teams_screen.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';

import '../content/routing_arguments/content_routing_arguments.dart';
import '../content/screen/content_screen.dart';
import '../splash/splash_screen.dart';
import '../view_full_image/routing_arguments/full_image_routing_arguments.dart';
import '../view_full_image/screen/view_full_image_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case AppRouteName.SPLASH_SCREEN_ROUTE:
            return SplashScreen();
          case AppRouteName.PRE_LOGIN_SCREEN_ROUTE:
            return PreLoginScreen();
          case AppRouteName.LOGIN_SCREEN_ROUTE:
            return LoginScreen();
          case AppRouteName.VERIFICATION_SCREEN_ROUTE:
            OtpArguments? _otpArguments =
                routeSettings.arguments as OtpArguments?;
            return VerificationScreen(
              otpType: _otpArguments?.otpType,
              userId: _otpArguments?.userId,
              phoneNo: _otpArguments?.phoneNo,
              phoneCode: _otpArguments?.phoneCode,
              countryCode: _otpArguments?.countryCode,
              phoneVerificationId: _otpArguments?.phoneVerificationId,
            );
          case AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE:
            return CompleteProfileScreen();
          case AppRouteName.PHONE_LOGIN_SCREEN_ROUTE:
            return PhoneLoginScreen();
          case AppRouteName.MAIN_SCREEN_ROUTE:
            return MainScreen();
          case AppRouteName.LATEST_NEWS_SCREEN_ROUTE:
            return LatestNewsScreen();
          case AppRouteName.UPCOMING_EVENTS_SCREEN_ROUTE:
            final args = routeSettings.arguments as bool?;
            return UpcomingEventsScreen(isFromLeagues: args);
          case AppRouteName.TEAM_STANDINGS_SCREEN_ROUTE:
            return TeamStandingsScreen();
          case AppRouteName.LATEST_NEWS_DETAIL_SCREEN_ROUTE:
            LatestNewsDetailsArguments? _latestNewsDetailsArgument =
                routeSettings.arguments as LatestNewsDetailsArguments?;
            return LatestNewsDetailScreen(
              newsModelArticles: _latestNewsDetailsArgument?.newsModelArticles,
            );
          // case AppRouteName.UPCOMING_EVENTS_DETAIL_SCREEN_ROUTE:
          //   UpcomingEventsRoutingArgument? upcomingEventsRoutingArgument =
          //       routeSettings.arguments as UpcomingEventsRoutingArgument?;
          //   return UpcomingEventsDetailScreen(
          //     date: upcomingEventsRoutingArgument!.date,
          //     time: upcomingEventsRoutingArgument.time,
          //     day: upcomingEventsRoutingArgument.day,
          //     place: upcomingEventsRoutingArgument.place,
          //     game: upcomingEventsRoutingArgument.game,
          //     firstTeamName: upcomingEventsRoutingArgument.firstTeamName,
          //     secTeamName: upcomingEventsRoutingArgument.secTeamName,
          //     firstTeamLogo: upcomingEventsRoutingArgument.firstTeamLogo,
          //     secTeamLogo: upcomingEventsRoutingArgument.secTeamLogo,
          //   );
          case AppRouteName.NOTIFICATION_SCREEN_ROUTE:
            return NotificationScreen();
          case AppRouteName.CONTENT_SCREEN_ROUTE:
            ContentRoutingArgument? contentRoutingArgument =
                routeSettings.arguments as ContentRoutingArgument?;
            return ContentScreen(
                title: contentRoutingArgument?.title ?? "",
                contentType: contentRoutingArgument?.contentType ?? "");
          case AppRouteName.LEAGUES_DETAIL_SCREEN_ROUTE:
            return LeaguesDetailScreen();
          case AppRouteName.EVENT_LIST_SCREEN_ROUTE:
            EventsRoutingArgument? eventsRoutingArgument =
                routeSettings.arguments as EventsRoutingArgument?;
            return EventListScreen(
              eventType: eventsRoutingArgument?.eventType,
              id: eventsRoutingArgument?.id,
              seasonYear: eventsRoutingArgument?.seasonYear,
              showButton: eventsRoutingArgument?.showButton,
            );
          case AppRouteName.TEAMS_SCREEN_ROUTE:
            return const TeamsScreen();
          case AppRouteName.TEAM_DETAILS_SCREEN_ROUTE:
            TeamsDetailArguments? teamDetailsArgument =
                routeSettings.arguments as TeamsDetailArguments?;
            return TeamsDetailScreen(
              teamId: teamDetailsArgument?.teamId,
              teamName: teamDetailsArgument?.teamName,
            );
          case AppRouteName.TEAM_MEMBERS_SCREEN_ROUTE:
            return const TeamMembersScreen();
          case AppRouteName.TEAM_MEMBER_DETAIL_SCREEN_ROUTE:
            TeamMemberRoutingArguments? _teamMemberRoutingArguments =
                routeSettings.arguments as TeamMemberRoutingArguments?;
            return TeamMemberDetailScreen(
              teamMembersData:
                  _teamMemberRoutingArguments?.teamMembersModelPlayer,
            );
          case AppRouteName.VIEW_FULL_IMAGE_SCREEN_ROUTE:
            ViewFullImageRoutingArguments? viewFullImageRoutingArguments =
                routeSettings.arguments as ViewFullImageRoutingArguments?;
            return ViewFullImageScreen(
                imagePath: viewFullImageRoutingArguments?.imagePath,
                placeholderImagePath:
                    viewFullImageRoutingArguments?.placeholderImagePath,
                mediaPathType: viewFullImageRoutingArguments?.mediaPathType);
          case AppRouteName.HONOUR_MILESTONE_DETAIL_SCREEN_ROUTE:
            HonourMilestoneDetailRoutingArguments?
                _honourMilestoneDetailRoutingArguments = routeSettings.arguments
                    as HonourMilestoneDetailRoutingArguments?;
            return HonourMilestoneDetailScreen(
              type: _honourMilestoneDetailRoutingArguments?.type,
              imagePath: _honourMilestoneDetailRoutingArguments?.imagePath,
              playerName: _honourMilestoneDetailRoutingArguments?.playerName,
              sport: _honourMilestoneDetailRoutingArguments?.sport,
              detail: _honourMilestoneDetailRoutingArguments?.detail,
              teamName: _honourMilestoneDetailRoutingArguments?.teamName,
              date: _honourMilestoneDetailRoutingArguments?.date,
            );
          default:
            return Container();
        }
      },
    );
  }
}

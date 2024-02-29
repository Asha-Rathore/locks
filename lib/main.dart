import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/events/provider/events_provider.dart';
import 'package:locks_hybrid/home/provider/news_provider.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/leagues/provider/teams_provider.dart';
import 'package:locks_hybrid/team_members/provider/honours_provider.dart';
import 'package:locks_hybrid/team_members/provider/milestones_provider.dart';
import 'package:locks_hybrid/team_standings/provider/team_standings_provider.dart';
import 'package:locks_hybrid/teams/provider/team_members_provider.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_router.dart';
import 'package:locks_hybrid/utils/app_size.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/scroll_behaviour.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<LeaguesProvider>(
          create: (context) => LeaguesProvider(),
        ),
        ChangeNotifierProvider<TeamsProvider>(
          create: (context) => TeamsProvider(),
        ),
        ChangeNotifierProvider<TeamMembersProvider>(
          create: (context) => TeamMembersProvider(),
        ),
        ChangeNotifierProvider<LeagueUpcomingEventsProvider>(
          create: (context) => LeagueUpcomingEventsProvider(),
        ),
        ChangeNotifierProvider<LeagueLatestResultEventsProvider>(
          create: (context) => LeagueLatestResultEventsProvider(),
        ),
        ChangeNotifierProvider<TeamUpcomingEventsProvider>(
          create: (context) => TeamUpcomingEventsProvider(),
        ),
        ChangeNotifierProvider<TeamLatestResultEventsProvider>(
          create: (context) => TeamLatestResultEventsProvider(),
        ),
        ChangeNotifierProvider<SeasonEventsProvider>(
          create: (context) => SeasonEventsProvider(),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(),
        ),
        ChangeNotifierProvider<LeagueLiveEventsProvider>(
          create: (context) => LeagueLiveEventsProvider(),
        ),
        ChangeNotifierProvider<HonoursProvider>(
          create: (context) => HonoursProvider(),
        ),
        ChangeNotifierProvider<MilestonesProvider>(
          create: (context) => MilestonesProvider(),
        ),
        ChangeNotifierProvider<TeamStandingsProvider>(
          create: (context) => TeamStandingsProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize:
            const Size(AppSize.FULL_SCREEN_WIDTH, AppSize.FULL_SCREEN_HEIGHT),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: StaticData.navigatorKey,
            title: AppStrings.APP_TITLE,
            theme: ThemeData(
              // checkboxTheme: CheckboxThemeData(
              //   checkColor: MaterialStateProperty.resolveWith(
              //       (_) => AppColors.THEME_COLOR_DARK_GREEN),
              //   fillColor: MaterialStateProperty.resolveWith(
              //       (_) => AppColors.THEME_COLOR_LIGHT_GREEN),
              //   overlayColor: MaterialStateProperty.resolveWith(
              //       (_) => AppColors.THEME_COLOR_DARK_GREEN),
              //   side: AlwaysActiveBorderSide(),
              // ),
              primarySwatch: AppColors.textFieldThemeColor,
            ),
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                ),
              );
            },
            // home: MainScreen() ,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

class AlwaysActiveBorderSide extends MaterialStateBorderSide {
  @override
  BorderSide? resolve(_) =>
      const BorderSide(color: AppColors.THEME_COLOR_DARK_GREEN);
}

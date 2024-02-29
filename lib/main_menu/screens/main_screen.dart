import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/events/routing_arguments/events_routing_arguments.dart';
import 'package:locks_hybrid/home/screen/home_screen.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/screen/leagues_screen.dart';
import 'package:locks_hybrid/profile/screens/profile_screen.dart';
import 'package:locks_hybrid/main_menu/blocs/logout_bloc.dart';
import 'package:locks_hybrid/settings/screen/settings_screen.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_confirmation_dialog.dart';
import '../../widgets/custom_text.dart';
import '../widgets/custom_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  LogoutBloc _logoutBloc = LogoutBloc();

  String icon = AssetPath.HOME_ICON;
  List title = [
    AppStrings.HOME,
    AppStrings.LEAGUES,
    AppStrings.SETTINGS,
    AppStrings.PROFILE,
  ];
  late TabController tabController;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgetOptions = [
      HomeScreen(),
      LeaguesScreen(),
      SettingScreen(),
      ProfileScreen(),
    ];
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
              context: context,
              builder: (context) {
                return _exitDialog();
              })) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: AppColors.PRIMARY_COLOR,
        drawer: CustomDrawer(
            onTapHome: _onTapHome,
            onTapUpComingEvents: _onTapUpComingEvents,
            onTapLiveEvents: _onTapUpLiveEvents,
            onTapTeamStandings: _onTapTeamStandings,
            onTapLogout: _onTapLogout),
        appBar: _appBar(context),
        body: SafeArea(
          child: _widgetOptions.elementAt(tabController.index),
        ),
        bottomNavigationBar: bottombar,
        extendBody: true,
        extendBodyBehindAppBar: true,
      ),
    );
  }

  get bottombar {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 55.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.THEME_COLOR_WHITE.withOpacity(0.30),
                offset: const Offset(
                  0.3,
                  0.3,
                ),
                blurRadius: 10.0,
                spreadRadius: 15,
              ),
            ],
          ),
          child: Container(
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
            // elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navBarData(
                  0,
                  AssetPath.HOME_ICON,
                  _selectedIndex != 0 ? AppStrings.HOME : "",
                  () {
                    _onItemTapped(0);
                  },
                ),
                navBarData(
                  1,
                  AssetPath.LEAGUE_ICON,
                  _selectedIndex != 1 ? AppStrings.LEAGUES : "",
                  () {
                    _onItemTapped(1);
                  },
                ),
                navBarData(
                  2,
                  AssetPath.SETTING_ICON,
                  _selectedIndex != 2 ? AppStrings.SETTINGS : "",
                  () {
                    _onItemTapped(2);
                  },
                ),
                navBarData(
                  3,
                  AssetPath.PROFILE_ICON,
                  _selectedIndex != 3 ? AppStrings.PROFILE : "",
                  () {
                    _onItemTapped(3);
                  },
                ),
              ],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: 78.h,
              width: double.infinity,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              left: tabController.index == 0
                  ? 10.w
                  : tabController.index == 1
                      ? 97.w
                      : tabController.index == 2
                          ? 195.w
                          : tabController.index == 3
                              ? 281.w
                              : 0,
              child: Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.THEME_COLOR_WHITE, width: 3.0),
                  color: AppColors.PRIMARY_COLOR,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.THEME_COLOR_WHITE.withOpacity(0.30),
                      offset: const Offset(
                        0.3,
                        0.3,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Image.asset(
                  icon,
                  scale: 4,
                  color: AppColors.THEME_COLOR_WHITE,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _text(text) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_DARK_GREEN.withOpacity(0.6),
      fontSize: 12.sp,
      fontFamily: AppFonts.Poppins_Regular,
    );
  }

  GestureDetector navBarData(
      int num, String navIcon, String? text, Function onpress,
      {double? scale}) {
    return GestureDetector(
      onTap: () async {
        onpress();
        setState(() {
          tabController.index = num;
        });
        FocusScope.of(context).unfocus();
        await awaitFunction();
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(
              icon: navIcon,
              scale: 4,
              color: AppColors.THEME_COLOR_DARK_GREEN.withOpacity(0.6),
            ),
            SizedBox(height: 5.h),
            _text(text),
          ],
        ),
      ),
    );
  }

  awaitFunction() async {
    Timer(
      const Duration(milliseconds: 200),
      () {
        setState(
          () {
            icon = tabController.index == 0
                ? AssetPath.HOME_ICON
                : tabController.index == 1
                    ? AssetPath.LEAGUE_ICON
                    : tabController.index == 2
                        ? AssetPath.SETTING_ICON
                        : tabController.index == 3
                            ? AssetPath.PROFILE_ICON
                            : AssetPath.PROFILE_ICON;
          },
        );
      },
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      title: AppStrings.APP_BAR_TITLE[_selectedIndex],
      leading: AssetPath.MENU_ICON,
      showAction: true,
      // leadingIconScale: 2.5.sp,
      actionWidget: _actionIcon(
        icon: _selectedIndex == 3
            ? AssetPath.EDIT_ICON
            : AssetPath.NOTIFICATION_ICON,
        scale: _selectedIndex == 3 ? 3 : 4,
      ),
      onclickLead: () {
        _scaffoldKey.currentState!.openDrawer();
        FocusScope.of(context).unfocus();
      },
      onclickAction: () {
        FocusScope.of(context).unfocus();
        if (_selectedIndex != 3) {
          FocusScope.of(context).unfocus();
          setState(() {});
          AppNavigation.navigateTo(
              context, AppRouteName.NOTIFICATION_SCREEN_ROUTE);
        } else {
          AppNavigation.navigateTo(
            context,
            AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          );
        }
      },
    );
  }

  Widget _icon({String? icon, double? scale, color}) {
    return Image.asset(
      icon!,
      color: color,
      scale: scale,
    );
  }

  Widget _actionIcon({String? icon, double? scale, color}) {
    return Image.asset(
      icon!,
      color: color,
      scale: scale,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //------------------- EXIT DIALOG ------------------//
  Widget _exitDialog() {
    return CustomConfirmationDialog(
      title: AppStrings.EXIT,
      description: AppStrings.DO_YOU_WANT_TO_EXIT,
      button1Text: AppStrings.CANCEL,
      button2Text: AppStrings.EXIT,
      onTapNo: () {},
      onTapYes: () {
        exit(0);
      },
    );
  }

  void _onTapHome() {
    AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE);
  }

  void _onTapUpComingEvents() {
    AppNavigation.navigatorPop(context);
    AppNavigation.navigateTo(context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
        arguments: EventsRoutingArgument(
            eventType: EventType.league_upcoming.name,
            id: LeaguesService()
                .getLeaguesProvider
                ?.getSingleLeagueData
                ?.idLeague
                ?.toString(),
            showButton: true));
  }

  void _onTapUpLiveEvents() {
    AppNavigation.navigatorPop(context);
    AppNavigation.navigateTo(context, AppRouteName.EVENT_LIST_SCREEN_ROUTE,
        arguments: EventsRoutingArgument(
            eventType: EventType.league_live.name,
            id: LeaguesService()
                .getLeaguesProvider
                ?.getSingleLeagueData
                ?.idLeague
                ?.toString(),
            showButton: true));
  }

  void _onTapTeamStandings() {
    AppNavigation.navigatorPop(context);
    AppNavigation.navigateTo(context, AppRouteName.TEAM_STANDINGS_SCREEN_ROUTE);
  }

  void _onTapLogout() {
    showDialog(
      context: context,
      builder: (childContext) {
        return CustomConfirmationDialog(
          title: AppStrings.LOGOUT,
          description: AppStrings.DO_YOU_WANT_TO_LOGOUT,
          button1Text: AppStrings.CANCEL,
          button2Text: AppStrings.LOGOUT,
          onTapNo: () {},
          onTapYes: () {
            _logoutBloc.logoutBlocMethod(
                context: context,
                setProgressBar: () {
                  AppDialogs.circularProgressDialog(context: context);
                });
          },
        );
      },
    );
  }
}

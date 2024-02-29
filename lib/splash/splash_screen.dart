import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/services/firebase_messaging_service.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/static_data.dart';
import 'package:provider/provider.dart';

import '../../utils/asset_paths.dart';
import '../utils/app_navigation.dart';
import '../utils/app_route_name.dart';
import '../widgets/custom_app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  UserProvider? _userProvider;

  @override
  void initState() {
    super.initState();
    _splashTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPath.SPLASH_IMAGE),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          _topLeftIcon(),
          _topRightIcon(),
          _bottomLeftIcon(),
          _bottomRightIcon(),
          _appLogo(),
        ],
      ),
    );
  }

  Widget _topLeftIcon() {
    return Positioned(
      right: 310.w,
      bottom: 595.h,
      child: Image.asset(
        AssetPath.SPLASH_ICON1,
        scale: 4,
      ),
    );
  }

  Widget _topRightIcon() {
    return Positioned(
      left: 310.w,
      bottom: 595.h,
      child: Image.asset(
        AssetPath.SPLASH_ICON2,
        scale: 4,
      ),
    );
  }

  Widget _bottomLeftIcon() {
    return Positioned(
      right: 310.w,
      top: 630.h,
      child: Image.asset(
        AssetPath.SPLASH_ICON2,
        scale: 4,
      ),
    );
  }

  Widget _bottomRightIcon() {
    return Positioned(
      left: 160.w,
      top: 560.h,
      child: Image.asset(
        AssetPath.SPLASH_ICON3,
        scale: 4,
      ),
    );
  }

  Widget _appLogo() {
    return Center(
      child: Entry.scale(
        curve: Curves.easeIn,
        duration: const Duration(seconds: 2),
        child: CustomLogo(height: 300.w, width: 300.w),
      ),
    );
  }

  Timer _navigationTimer({required int seconds}) {
    return Timer(Duration(seconds: seconds), () {
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.PRE_LOGIN_SCREEN_ROUTE,
      );
    });
  }


  void _splashTimer() async {
    Timer(const Duration(seconds: 2), _onComplete);
  }

  void _onComplete() async {
    //AppNavigation.navigateTo(context, AppRouteName.TWO_MINUTE_THANK_YOU_SCREEN_ROUTE);
    _checkCurrentUserMethod();
  }





  void _checkCurrentUserMethod() async {
    try {
      await SharedPreference().sharedPreference;
      LeaguesService().callLeaguesApiMethod();
      await FirebaseMessagingService().initializeNotificationSettings();

      _setNotifications();
    } catch (error) {
      print("Eror:$error");
      StaticData.cleaAppDataOnError(context: context);
    }
  }

  void _setNotifications() async {
    FirebaseMessagingService().foregroundNotification();
    FirebaseMessagingService().backgroundTapNotification();
  }

}

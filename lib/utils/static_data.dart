import 'package:flutter/material.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:provider/provider.dart';

class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static clearAllAppData({required BuildContext context}) {
    print("all data");
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (_userProvider.getCurrentUser != null) {
      _userProvider.clearCurrentUser();
      LeaguesService().clearLeaguesServiceData();
      SharedPreference().clear();
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
    }
  }





//If there is some error on splash when initializing notification then in try catch this method call
  static cleaAppDataOnError({required BuildContext context}) {
    print("all data");
    UserProvider _userProvider =
    Provider.of<UserProvider>(context, listen: false);
      _userProvider.clearCurrentUser();
      SharedPreference().clear();
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);

  }
}

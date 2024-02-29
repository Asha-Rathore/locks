import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/settings/blocs/delete_account_bloc.dart';
import 'package:locks_hybrid/main_menu/blocs/logout_bloc.dart';
import 'package:locks_hybrid/settings/blocs/notification_enable_bloc.dart';
import 'package:locks_hybrid/settings/widgets/custom_settings_widget.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:provider/provider.dart';

import '../../content/routing_arguments/content_routing_arguments.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_confirmation_dialog.dart';

class SettingScreen extends StatelessWidget {
  LogoutBloc _logoutBloc = LogoutBloc();
  DeleteAccountBloc _deleteAccountBloc = DeleteAccountBloc();
  NotificationEnableBloc _notificationEnableBloc = NotificationEnableBloc();

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Column(
        children: [
          SizedBox(height: 15.h),
          _notifications(),
          SizedBox(height: 10.h),
          _termsAndCondition(context),
          SizedBox(height: 10.h),
          _privacyPolicy(context),
          // SizedBox(height: 10.h),
          // _logoutButton(context),
          SizedBox(height: 10.h),
          _deleteAccountButton(context),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext parentContext) {
    return CustomButton(
      onTap: () {
        showDialog(
          context: parentContext,
          builder: (context) {
            return CustomConfirmationDialog(
              title: AppStrings.LOGOUT,
              description: AppStrings.DO_YOU_WANT_TO_LOGOUT,
              button1Text: AppStrings.CANCEL,
              button2Text: AppStrings.LOGOUT,
              onTapNo: () {},
              onTapYes: () {
                _logoutBloc.logoutBlocMethod(
                    context: parentContext,
                    setProgressBar: () {
                      AppDialogs.circularProgressDialog(context: context);
                    });
              },
            );
          },
        );
      },
      text: AppStrings.LOGOUT,
      backgroundColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      textColor: AppColors.THEME_COLOR_DARK_GREEN,
    );
  }

  Widget _deleteAccountButton(BuildContext parentContext) {
    return CustomButton(
      onTap: () {
        showDialog(
          context: parentContext,
          builder: (context) {
            return CustomConfirmationDialog(
              title: AppStrings.DELETE_ACCOUNT,
              description: AppStrings.ARE_YOU_SURE_YOU_WANT_TO_DELETE_ACCOUNT,
              button1Text: AppStrings.CANCEL,
              button2Text: AppStrings.DELETE,
              onTapNo: () {},
              onTapYes: () {
                _deleteAccountBloc.deleteAccountBlocMethod(
                    context: parentContext,
                    setProgressBar: () {
                      AppDialogs.circularProgressDialog(context: context);
                    });
              },
            );
          },
        );
      },
      text: AppStrings.DELETE_ACCOUNT,
      backgroundColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      textColor: AppColors.THEME_COLOR_DARK_GREEN,
    );
  }

  Widget _notifications() {
    return Consumer<UserProvider>(builder: (context, userConsumerData, child) {
      return SettingsWidget(
        text: AppStrings.NOTIFICATIONS,
        isSwitch: true,
        switchEnable: userConsumerData.getCurrentUser?.data?.notifications ==
                NotificationType.enable.index
            ? true
            : false,
        onSwitchChanged: (bool switchData) {
          print("Switch Data:${switchData.toString()}");
          _notificationEnableBloc.notificationBlocMethod(
              context: context,
              notificationEnable: switchData,
              setProgressBar: () {
                AppDialogs.circularProgressDialog(context: context);
              });
        },
      );
    });
  }

  Widget _termsAndCondition(context) {
    return SettingsWidget(
      text: AppStrings.TERMS_AND_CONDITIONS,
      onTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.CONTENT_SCREEN_ROUTE,
          arguments: ContentRoutingArgument(
              title: AppStrings.TERMS_AND_CONDITIONS,
              contentType: AppStrings.TERMS_CONDITION_TYPE),
        );
      },
    );
  }

  Widget _privacyPolicy(context) {
    return SettingsWidget(
      text: AppStrings.PRIVACY_POLICY,
      onTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.CONTENT_SCREEN_ROUTE,
          arguments: ContentRoutingArgument(
              title: AppStrings.PRIVACY_POLICY,
              contentType: AppStrings.PRIVACY_POLICY_TYPE),
        );
      },
    );
  }
}

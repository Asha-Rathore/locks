import 'package:flutter/material.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/widgets/custom_appbar.dart';

import '../utils/asset_paths.dart';

class CustomAppBackground extends StatelessWidget {
  final String? title;
  final Widget? actionWidget, child;
  final Function()? onClickAction;
  final Color? appBarColor;
  const CustomAppBackground({
    super.key,
    this.title,
    this.actionWidget,
    this.onClickAction,
    this.child, this.appBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_COLOR,
      appBar: _appBar(context),
      body: child,
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      backgroundColor: appBarColor,
      title: title,
      leading: AssetPath.BACK_ICON,
      showAction: true,
      // leadingIconScale: 2.5.sp,
      actionWidget: actionWidget,
      onclickLead: () {
        FocusScope.of(context).unfocus();
        AppNavigation.navigatorPop(context);
      },
      onclickAction: onClickAction,
    );
  }
}

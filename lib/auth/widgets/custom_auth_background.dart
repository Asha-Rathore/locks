import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/widgets/custom_form_container.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/widgets/custom_appbar.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';

import '../../utils/app_colors.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_app_logo.dart';

class CustomAuthBackground extends StatelessWidget {
  final bool? isLeading;
  final Widget? child;
  final VoidCallback? onLeadingTap;

  CustomAuthBackground({this.isLeading = true, this.child, this.onLeadingTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
          fit: BoxFit.cover,
        ),
      ),
      child: _scaffoldWidget(context),
    );
  }

  Widget _scaffoldWidget(context) {
    return Scaffold(
      backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
      appBar: _appBar(context),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 5.h),
            _appLogo(),
            // SizedBox(height: 10.h),
            _formArea(context)
          ],
        ),
      ),
    );
  }

  Widget _appLogo() {
    return CustomLogo(
      height: 160.w,
      width: 260.w,
    );
  }

  Widget _formArea(BuildContext context) => Expanded(
        child: CustomFormContainerWidget(
          child: CustomPadding(
            padding: 22.w,
            child: child,
          ),
        ),
      );

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      leading: isLeading! ? AssetPath.BACK_ICON : null,
      onclickLead: onLeadingTap ?? () {
        AppNavigation.navigatorPop(context);
      },
    );
  }
}

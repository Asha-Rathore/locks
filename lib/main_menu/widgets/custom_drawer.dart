import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_circular_profile.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_confirmation_dialog.dart';
import '../../widgets/custom_text.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback onTapHome,
      onTapUpComingEvents,
      onTapLiveEvents,
      onTapTeamStandings,
      onTapLogout;

  CustomDrawer(
      {required this.onTapHome,
      required this.onTapUpComingEvents,
      required this.onTapLiveEvents,
      required this.onTapTeamStandings,
      required this.onTapLogout});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<VoidCallback> _onTapList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onTapList = [
      widget.onTapHome,
      widget.onTapUpComingEvents,
      widget.onTapLiveEvents,
      widget.onTapTeamStandings
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      ),
      child: Drawer(
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: SafeArea(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              _crossIcon(),
              SizedBox(height: 15.h),
              _userDetail(),
              SizedBox(height: 15.h),
              _divider(),
              SizedBox(height: 25.h),
              _menuListWidget(context: context),
              const Spacer(),
              _logout(),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crossIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: InkWell(
          onTap: () {
            AppNavigation.navigatorPop(context);
          },
          child: Image.asset(
            AssetPath.CROSS_ICON,
            scale: 3,
          ),
        ),
      ),
    );
  }

  Widget _userDetail() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child:
          Consumer<UserProvider>(builder: (context, userConsumerData, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _userProfile(
                userImagePath:
                    userConsumerData.getCurrentUser?.data?.profileImage),
            SizedBox(height: 10.h),
            _userName(
                firstName: userConsumerData.getCurrentUser?.data?.firstName,
                lastName: userConsumerData.getCurrentUser?.data?.lastName),
            SizedBox(height: 6.h),
            _userEmail(userEmail: userConsumerData.getCurrentUser?.data?.email),
          ],
        );
      }),
    );
  }

  Widget _userProfile({String? userImagePath}) {
    return CustomCircularImageWidget(
      height: 90.h,
      width: 90.h,
      image: Constants.getImage(imagePath: userImagePath),
    );
  }

  Widget _userName({String? firstName, String? lastName}) {
    return CustomText(
      text: Constants.concatFirstLastName(
          firstName: firstName, lastName: lastName),
      fontSize: 18.sp,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_SemiBold,
    );
  }

  Widget _userEmail({String? userEmail}) {
    return Visibility(
      visible: userEmail.checkNullEmptyText,
      child: CustomText(
        text: userEmail,
        fontSize: 13.sp,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Regular,
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: AppColors.THEME_COLOR_WHITE,
      indent: 20.w,
      endIndent: 20.w,
      thickness: 0.3,
    );
  }

  Widget _menuListWidget({required BuildContext context}) {
    return ListView.builder(
      itemCount: AppStrings.DRAWER_TITLE_LIST.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctxt, int index) {
        return menuListTile(
            context: context,
            index: index,
            imagePath: AppStrings.DRAWER_ICONS_LIST[index],
            title: AppStrings.DRAWER_TITLE_LIST[index],
            onTap: _onTapList[index]);
      },
    );
  }

  Widget menuListTile(
      {required BuildContext context,
      required int index,
      required String imagePath,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 20.w, top: 7.h, bottom: 7.h),
        margin: EdgeInsets.only(top: 5.h, bottom: 3.h, right: 26.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _trailingImage(imagePath: imagePath),
            SizedBox(width: index == 2 ? 21.w : index == 3 ? 19.w : 20.w),
            Padding(
              padding: EdgeInsets.only(top: 3.h),
                child: _title(text: title)),
          ],
        ),
      ),
    );
  }

  Widget _trailingImage({String? imagePath}) {
    return Image.asset(
      imagePath!,
      height: 15.h,
      color: AppColors.THEME_COLOR_LIGHT_GREEN,
    );
  }

  Widget _title({String? text, Color? color}) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontSize: 16.sp,
      fontFamily: AppFonts.Poppins_SemiBold,
      maxLines: 1,
    );
  }

  Widget _logout() {
    return GestureDetector(
      onTap: widget.onTapLogout,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 45.0, right: 40, top: 20, bottom: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AssetPath.LOGOUT_ICON,
                  scale: 3.5.sp,
                  color: AppColors.THEME_COLOR_BLACK,
                ),
                SizedBox(width: 10.w),
                CustomText(
                  text: AppStrings.LOGOUT,
                  fontColor: AppColors.THEME_COLOR_BLACK,
                  fontFamily: AppFonts.Poppins_SemiBold,
                  fontSize: 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

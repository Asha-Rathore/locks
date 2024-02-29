import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_navigation.dart';
import 'custom_text.dart';

class CustomConfirmationDialog extends StatefulWidget {
  final String? title, description, button1Text, button2Text;
  final Function()? onTapYes;
  final Function()? onTapNo;
  final bool? isDescriptionVisible;
  const CustomConfirmationDialog(
      {Key? key,
      this.title,
      this.description,
      this.button1Text,
      this.button2Text,
      this.onTapYes,
      this.onTapNo,
      this.isDescriptionVisible = true})
      : super(key: key);

  @override
  _CustomConfirmationDialogState createState() =>
      _CustomConfirmationDialogState();
}

class _CustomConfirmationDialogState extends State<CustomConfirmationDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeIn);
    animationController!.addListener(() {
      setState(() {});
    });
    animationController!.forward();
  }

  @override
  void dispose() {
    animationController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation!,
      child: Dialog(
        backgroundColor: AppColors.PRIMARY_COLOR,
        insetAnimationCurve: Curves.bounceOut,
        insetAnimationDuration: const Duration(seconds: 2),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /////////--------- DIALOG TITLE ---------/////////
            CustomPadding(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  _dialogTitle(),
                  SizedBox(height: 20.h),
                  /////////--------- DIALOG DESCRIPTION ---------/////////
                  Visibility(
                    visible: widget.isDescriptionVisible ?? true,
                    child: _dialogDescription(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /////////--------- NO TAP BUTTON ---------/////////
                _onTapNoBtn(),
                /////////--------- YES TAP BUTTON ---------/////////
                _onTapYesBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogTitle() {
    return Row(
      children: [
        //SizedBox(width: 20.w),
        Spacer(),
        CustomText(
          text: widget.title ?? "",
          fontColor: AppColors.THEME_COLOR_WHITE,
          fontSize: 18.sp,
          fontFamily: AppFonts.Poppins_SemiBold,
        ),
        Spacer(),
        // GestureDetector(
        //   onTap: () {
        //     AppNavigation.navigatorPop(context);
        //   },
        //   child: Image.asset(
        //     AssetPath.CROSS_ICON,
        //     scale: 4,
        //   ),
        // ),
      ],
    );
  }

  Widget _dialogDescription() {
    return CustomPadding(
      padding: 24.w,
      child: CustomText(
        text: widget.description ?? "",
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontSize: 14.sp,
        maxLines: 2,
        textAlign: TextAlign.center,
        fontFamily: AppFonts.Roboto_Regular,
        lineSpacing: 1.5,
      ),
    );
  }

  Widget _onTapNoBtn() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          animationController!.reverse();
          AppNavigation.navigatorPop(context);
          widget.onTapNo!();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            child: Center(
              child: CustomText(
                text: widget.button1Text ?? "",
                fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
                fontSize: 18.sp,
                fontFamily: AppFonts.Poppins_SemiBold,
              ),
            ),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              border: Border(
                top: BorderSide(
                    color: AppColors.THEME_COLOR_WHITE.withOpacity(0.6)),
                right: BorderSide(
                    color: AppColors.THEME_COLOR_WHITE.withOpacity(0.6),
                    width: 0.5.w),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _onTapYesBtn() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          animationController!.reverse();
          AppNavigation.navigatorPop(context);
          widget.onTapYes!();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            child: Center(
              child: CustomText(
                text: widget.button2Text,
                fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
                fontSize: 18.sp,
                fontFamily: AppFonts.Poppins_SemiBold,
              ),
            ),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              border: Border(
                top: BorderSide(
                    color: AppColors.THEME_COLOR_WHITE.withOpacity(0.6)),
                left: BorderSide(
                    color: AppColors.THEME_COLOR_WHITE.withOpacity(0.6),
                    width: 0.5.w),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

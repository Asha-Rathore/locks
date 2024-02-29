import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_button.dart';
import 'package:locks_hybrid/widgets/custom_check_box.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_search_bar.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../utils/app_route_name.dart';

class CustomFilterBottomSheet extends StatefulWidget {
  final double? height;
  final ValueChanged<bool> onShowResultTap;

  CustomFilterBottomSheet(
      {super.key, this.height, required this.onShowResultTap});

  @override
  State<CustomFilterBottomSheet> createState() =>
      _CustomFilterBottomSheetState();
}

class _CustomFilterBottomSheetState extends State<CustomFilterBottomSheet> {
  int? _selectedOption;
  LeaguesModelData? _singleLeagueData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
        color: AppColors.PRIMARY_COLOR,
        boxShadow: [
          BoxShadow(
            color: AppColors.THEME_COLOR_WHITE.withOpacity(0.16),
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CustomPadding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5.h),
            _bar(context),
            SizedBox(height: 15.h),
            _leaguesWaitingWidget(),
            // _text(text: AppStrings.SEARCH_FILTER),
            // SizedBox(height: 10.h),
            // _customSearchTextField(),
            // SizedBox(height: 15.h),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: _text(text: AppStrings.SEARCH_BY),
            // ),
            // SizedBox(height: 15.h),
            // _checkBox(),
            SizedBox(height: 15.h),
            _button(),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _leaguesWaitingWidget() {
    return Consumer<LeaguesProvider>(
        builder: (context, leaguesConsumerData, child) {
      return leaguesConsumerData.getWaitingStatus == true
          ? AppDialogs.circularProgressWidget()
          : (leaguesConsumerData.getLeaguesModel?.data?.length ?? 0) > 0
              ? _leaguesListWidget(
                  leaguesObject: leaguesConsumerData.getLeaguesModel?.data)
              : CustomErrorWidget(
                  errorImagePath: AssetPath.LEAGUES_ICON,
                  errorText: AppStrings.NO_LEAGUES_FOUND_ERROR,
                  imageColor: AppColors.THEME_COLOR_WHITE,
                );
    });
  }

  Widget _leaguesListWidget({List<LeaguesModelData?>? leaguesObject}) {
    _getSelectedOption();
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: leaguesObject?.length ?? 0,
          itemBuilder: (context, index) {
            return _leaguesWidget(leaguesData: leaguesObject?[index]);
          }),
    );
  }

  Widget _leaguesWidget({LeaguesModelData? leaguesData}) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: AppColors.THEME_COLOR_WHITE,
              disabledColor: Colors.blue),
          child: Radio(
            groupValue: _selectedOption,
            activeColor: AppColors.THEME_COLOR_LIGHT_GREEN,
            value: leaguesData?.idLeague,
            onChanged: (value) {
              _selectedOption = value;
              _singleLeagueData = leaguesData;
              setState(() {});
            },
          ),
        ),
        CustomText(
          text: leaguesData?.strLeagueName,
          fontColor: AppColors.THEME_COLOR_WHITE,
          fontFamily: AppFonts.Poppins_SemiBold,
          fontSize: 14.sp,
        )
      ],
    );
  }

  Widget _bar(context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigatorPop(context);
      },
      child: Container(
        height: 3.5.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: AppColors.LIGHT_PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  Widget _button() {
    return CustomButton(
      onTap: () {
        log("Single League Data:${_singleLeagueData?.toJson()}");
        widget.onShowResultTap(true);
        LeaguesService().setSingleLeagueData(
            singleLeagueData: _singleLeagueData,
            isToast: true,
            setProgressBar: () {
              AppDialogs.circularProgressDialog(context: context);
            },
            onFailure: () {
              AppNavigation.navigatorPop(context);
            },
            onSuccess: () {
              AppNavigation.navigatorPop(context);
              AppNavigation.navigatorPop(context);
            });
      },
      text: AppStrings.SHOW_RESULTS,
      backgroundColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      textColor: AppColors.THEME_COLOR_DARK_GREEN,
    );
  }

  void _getSelectedOption() {
    _selectedOption = _selectedOption == null
        ? LeaguesService().getLeaguesProvider?.getSingleLeagueData?.idLeague
        : _selectedOption;

    _singleLeagueData = _singleLeagueData == null
        ? LeaguesService().getLeaguesProvider?.getSingleLeagueData
        : _singleLeagueData;
  }
}

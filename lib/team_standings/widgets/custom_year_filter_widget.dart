import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/models/seasons_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/widgets/custom_button.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CustomYearFilterBottomSheet extends StatefulWidget {
  SeasonsModel? seasonsModel;
  String? seasonYear;
  ValueChanged<String?> onSeasonYearChanged;

  CustomYearFilterBottomSheet(
      {this.seasonsModel, this.seasonYear, required this.onSeasonYearChanged});

  @override
  State<CustomYearFilterBottomSheet> createState() =>
      _CustomYearFilterBottomSheetState();
}

class _CustomYearFilterBottomSheetState
    extends State<CustomYearFilterBottomSheet> {
  String? _selectedSeasonYear;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedSeasonYear = widget.seasonYear;
  }

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
            _seasonListWidget(),
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

  Widget _seasonListWidget() {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (widget.seasonsModel?.seasons?.length ?? 0) > 4
              ? 4
              : widget.seasonsModel?.seasons?.length,
          itemBuilder: (context, index) {
            return _yearsWidget(
                seasonData: widget.seasonsModel?.seasons?[index]);
          }),
    );
  }

  Widget _yearsWidget({SeasonsModelSeasons? seasonData}) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: AppColors.THEME_COLOR_WHITE,
              disabledColor: Colors.blue),
          child: Radio(
            groupValue: _selectedSeasonYear,
            activeColor: AppColors.THEME_COLOR_LIGHT_GREEN,
            value: seasonData?.strSeason,
            onChanged: (value) {
              // _selectedOption = value;
              // _singleLeagueData = leaguesData;
              // setState(() {});
              setState(() {
                _selectedSeasonYear = value;
              });
            },
          ),
        ),
        CustomText(
          text: seasonData?.strSeason,
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
        widget.onSeasonYearChanged(_selectedSeasonYear);
      },
      text: AppStrings.SHOW_RESULTS,
      backgroundColor: AppColors.THEME_COLOR_LIGHT_GREEN,
      textColor: AppColors.THEME_COLOR_DARK_GREEN,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_padding.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/custom_location_season_rich_widget.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomLeagueTeamDetailWidget extends StatelessWidget {
  final bool? shimmerEnable;
  final String? leagueImagePath,
      location,
      season,
      leagueDescription,
      countryFlag;
  final VoidCallback? onTap;

  CustomLeagueTeamDetailWidget(
      {this.shimmerEnable,
      this.leagueImagePath,
      this.location,
      this.season,
      this.leagueDescription,
      this.countryFlag,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return shimmerEnable == false
        ? _leaguesDetailMainWidget()
        : CustomShimmerWidget(
            child: _leaguesDetailMainWidget(),
          );
  }

  Widget _leaguesDetailMainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imageTextWidget(),
        SizedBox(height: 10.h),
        Padding(
          padding:
              EdgeInsets.only(right: AppPadding.DEFAULT_HORIZONTAL_PADDING.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _descriptionTitleWidget(),
              SizedBox(height: 10.h),
              _availableInWidget(),
              SizedBox(height: 10.h),
              _descriptionTextWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget _imageTextWidget() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        height: 0.26.sh,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _imageWidget(),
            _customLocationSeasonRowWidget(),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return CustomExtendedImageWidget(
      imagePath: leagueImagePath,
      imageType: MediaPathType.network.name,
      imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
    );
  }

  Widget _customLocationSeasonRowWidget() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 1.sw,
        color: AppColors.THEME_COLOR_BLACK.withOpacity(0.4),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.DEFAULT_HORIZONTAL_PADDING.w,
              vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _locationSeasonWidget(title: AppStrings.LOCATION, text: location),
              _locationSeasonWidget(title: AppStrings.SEASON1, text: season),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationSeasonWidget({String? title, String? text}) {
    return text.checkNullEmptyText
        ? CustomLocationSeasonRichWidget(
            title: title,
            text: text,
          )
        : Container();
  }

  Widget _descriptionTitleWidget() {
    return _titleDescriptionWidget(
      text: AppStrings.DESCRIPTION,
      fontSize: 16.sp,
    );
  }

  Widget _availableInWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.5.h),
          child: Container(
            child: _titleDescriptionWidget(
              text: AppStrings.AVAILABLE_IN,
              fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
              fontFamily: AppFonts.Poppins_Medium,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Visibility(
          visible: shimmerEnable == false ? true : false,
          child: Image.asset(
            countryFlag ?? AssetPath.USA_FLAG,
            height: 13.h,
          ),
        )
        // _flag(),
        // SizedBox(width: 10.w),
        // _flag(),
        // SizedBox(width: 10.w),
        // _flag(),
      ],
    );
  }

  Widget _descriptionTextWidget() {
    return _titleDescriptionWidget(
      text: leagueDescription,
      fontFamily: AppFonts.Roboto_Regular,
      fontSize: 12.sp,
    );
  }

  Widget _titleDescriptionWidget(
      {String? text, Color? fontColor, String? fontFamily, double? fontSize}) {
    return Padding(
        padding: EdgeInsets.only(left: AppPadding.DEFAULT_HORIZONTAL_PADDING.w),
        child: Container(
          color: AppColors.PRIMARY_COLOR,
          child: CustomText(
            text: text,
            fontColor: fontColor ?? AppColors.THEME_COLOR_WHITE,
            fontFamily: fontFamily ?? AppFonts.Poppins_Medium,
            fontSize: fontSize ?? 16.sp,
            textAlign: TextAlign.left,
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomFormerTeamsWidget extends StatelessWidget {
  final String? teamImagePath, sport, team, moveType, joinedDate, departedDate;
  final bool? shimmerEnable;
  final VoidCallback? onTap;

  const CustomFormerTeamsWidget(
      {this.shimmerEnable,
      this.teamImagePath,
      this.sport,
      this.team,
      this.moveType,
      this.joinedDate,
      this.departedDate,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CustomPadding(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.THEME_COLOR_DARK_GREEN,
                borderRadius: BorderRadius.circular(10.r),
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
              child: shimmerEnable == false
                  ? _formerTeamWidget(context: context)
                  : CustomShimmerWidget(
                      child: _formerTeamWidget(context: context),
                    )),
        ),
      ),
    );
  }

  Widget _formerTeamWidget({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formerTeamImageWidget(context: context),
        SizedBox(height: 10.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleDescriptionTextWidget(
                  title: AppStrings.SPORT_TEXT, description: sport),
              _titleDescriptionTextWidget(
                  title: AppStrings.FORMER_TEAM_TEXT,
                  description: team),
              _titleDescriptionTextWidget(
                  title: AppStrings.TYPE_TEXT, description: moveType),
              _titleDescriptionTextWidget(
                  title: AppStrings.JOINED_YEAR_TEXT,
                  description: joinedDate,),
              _titleDescriptionTextWidget(
                  title: AppStrings.DEPARTED_YEAR_TEXT,
                  description: departedDate),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _formerTeamImageWidget(
      {required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      child: Container(
        width: 1.sw,
        height: 70.h,
        color: AppColors.THEME_COLOR_DARK_GREEN,
        padding: EdgeInsets.only(top: 10.0.h),
        child: CustomExtendedImageWidget(
          imagePath: teamImagePath,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          imageType: MediaPathType.network.name,
          placeholderColor: AppColors.THEME_COLOR_DARK_GREEN,
          fit: BoxFit.contain,
          // onTap: () {
          //   Constants.imageViewMethod(context: context,
          //       imagePath: newsData?.url,
          //       mediaPathType: MediaPathType.network.name);
          // },
        ),
      ),
    );
  }

  Widget _titleDescriptionTextWidget(
      {required String title, String? description}) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Container(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: title,
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontFamily: AppFonts.Poppins_Medium,
              fontSize: 12.0.sp,
              textAlign: TextAlign.left,
              lineSpacing: 1.4,
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 0.7.h),
                child: CustomText(
                  text: description,
                  fontColor: AppColors.THEME_COLOR_WHITE,
                  fontFamily: AppFonts.Poppins_Regular,
                  fontSize: 11.0.sp,
                  textAlign: TextAlign.left,
                  lineSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

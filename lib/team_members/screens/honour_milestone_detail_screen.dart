import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_image_widget.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../view_full_image/routing_arguments/full_image_routing_arguments.dart';

class HonourMilestoneDetailScreen extends StatelessWidget {
  String? type, imagePath, playerName, sport, detail, teamName, date;

  HonourMilestoneDetailScreen(
      {this.type,
      this.imagePath,
      this.playerName,
      this.sport,
      this.detail,
      this.teamName,
      this.date});

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: type == HonourMilestoneType.honour.name
          ? AppStrings.HONOUR_HEADING_TEXT
          : AppStrings.MILESTONE_HEADING_TEXT,
      child: CustomPadding(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              _imageWidget(),
              SizedBox(height: 20.h),
              _playerName(),
              SizedBox(height: 10.h),
              _divider(),
              _titleTextWidget(
                  title: type == HonourMilestoneType.honour.name
                      ? AppStrings.HONOUR_TEXT
                      : AppStrings.MILESTONE_TEXT,
                  text: detail),
              _titleTextWidget(title: AppStrings.TEAM1_TEXT, text: teamName),
              _titleTextWidget(title: AppStrings.SPORT_TEXT, text: sport),
              _titleTextWidget(
                  title: type == HonourMilestoneType.honour.name
                      ? AppStrings.SEASON_TEXT
                      : AppStrings.YEAR_TEXT,
                  text: date),
              SizedBox(height: 9.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Container(
      width: 1.sw,
      height: 0.14.sh,
      child: CustomExtendedImageWidget(
        imagePath: imagePath,
        imageColor: type == HonourMilestoneType.honour.name
            ? AppColors.THEME_COLOR_WHITE
            : null,
        imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
        imageType: type == HonourMilestoneType.honour.name
            ? MediaPathType.asset.name
            : MediaPathType.network.name,
        fit: BoxFit.contain,

        onTap: () {
          // Constants.imageViewMethod(
          //     context: context,
          //     imagePath: newsData?.url,
          //     mediaPathType: MediaPathType.network.name);
        },
      ),
    );
  }

  Widget _playerName() {
    return CustomText(
      text: playerName,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.0.sp,
      textAlign: TextAlign.left,
      lineSpacing: 1.25,
    );
  }

  Widget _divider() {
    return const Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: 0.3,
    );
  }

  Widget _titleTextWidget({String? title, String? text}) {
    return text.checkNullEmptyText
        ? Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontColor: AppColors.THEME_COLOR_WHITE,
                  fontFamily: AppFonts.Poppins_Medium,
                  fontSize: 14.0.sp,
                  textAlign: TextAlign.left,
                  underlined: true,
                ),
                SizedBox(
                  height: 7.h,
                ),
                CustomText(
                  text: text,
                  fontColor: AppColors.THEME_COLOR_WHITE,
                  fontFamily: AppFonts.Poppins_Regular,
                  fontSize: 12.0.sp,
                  textAlign: TextAlign.left,
                  lineSpacing: 1.4,
                )
              ],
            ),
          )
        : Container();
  }
}

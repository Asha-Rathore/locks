import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_image_widget.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../view_full_image/routing_arguments/full_image_routing_arguments.dart';

class LatestNewsDetailScreen extends StatelessWidget {
  final NewsModelArticles? newsModelArticles;

  LatestNewsDetailScreen({this.newsModelArticles});

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: AppStrings.LATEST_NEWS,
      child: CustomPadding(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              _newsImagePageViewBuilder(context: context),
              SizedBox(height: 10.h),
              _title(),
              SizedBox(height: 10.h),
              _dateAndTimeWidget(),
              SizedBox(height: 10.h),
              _divider(),
              SizedBox(height: 10.h),
              _descriptionTitle(),
              SizedBox(height: 9.h),
              _descriptionText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _newsImagePageViewBuilder({required BuildContext context}) {
    return (newsModelArticles?.images?.length ?? 0) > 0
        ? Container(
            width: 1.sw,
            height: 0.25.sh,
            child: PageView.builder(
              itemBuilder: (context, index) {
                return _newsImageWidget(
                    context: context,
                    newsData: newsModelArticles?.images?[index]);
              },
              itemCount: newsModelArticles?.images?.length ?? 0,
            ),
          )
        : _newsImageWidget(context: context, newsData: null);
  }

  Widget _newsImageWidget(
      {required BuildContext context, NewsModelArticlesImages? newsData}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 1.sw,
        height: 0.25.sh,
        child: CustomExtendedImageWidget(
          imagePath: newsData?.url,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          imageType: MediaPathType.network.name,
          fit: BoxFit.cover,
          onTap: () {
            Constants.imageViewMethod(
                context: context,
                imagePath: newsData?.url,
                mediaPathType: MediaPathType.network.name);
          },
        ),
      ),
    );
  }

  Widget _title() {
    return CustomText(
      text: newsModelArticles?.headline,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.0.sp,
      textAlign: TextAlign.left,
      lineSpacing: 1.25,
    );
  }

  Widget _dateAndTimeWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _iconAndText(
          icon: AssetPath.CALENDER_WITH_DOTS_ICON,
          text: Constants.getEventDate(
              eventTimeStamp: newsModelArticles?.lastModified),
        ),
        SizedBox(width: 17.w),
        _iconAndText(
          icon: AssetPath.TIME_ICON,
          text: Constants.getEventTime(
              eventTimeStamp: newsModelArticles?.lastModified),
        ),
      ],
    );
  }

  Widget _iconAndText({required String icon, String? text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          height: 10.2.h,
        ),
        SizedBox(width: 7.w),
        Padding(
          padding: EdgeInsets.only(top: 3.5.h),
          child: CustomText(
            text: text,
            fontColor: AppColors.THEME_COLOR_WHITE.withOpacity(0.8),
            fontFamily: AppFonts.Poppins_Medium,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return const Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: 0.3,
    );
  }

  Widget _descriptionTitle() {
    return CustomText(
      text: AppStrings.DESCRIPTION,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Medium,
      fontSize: 14.sp,
      textAlign: TextAlign.left,
    );
  }

  Widget _descriptionText() {
    return CustomText(
      text: newsModelArticles?.description,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontFamily: AppFonts.Poppins_Regular,
      fontSize: 12.0.sp,
      textAlign: TextAlign.left,
      lineSpacing: 1.4,
    );
  }

  void _onTapViewImage(
      {BuildContext? context, String? imagePath, bool? imageTypeFile}) {
    // return AppNavigation.navigateTo(
    //   context!,
    //   AppRouteName.VIEW_FULL_IMAGE_SCREEN_ROUTE,
    //   arguments: ViewFullImageRoutingArguments(
    //       image: imagePath != null ? imagePath : AssetPath.NEWS1,
    //       isImageTypeFile: imageTypeFile),
    // );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/widgets/custom_extended_image_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';

class CustomNewsWidget extends StatelessWidget {
  final String? title, timeAgo, description, image, date, time;
  final List<NewsModelArticlesImages?>? newsImages;
  final bool? isHome, shimmerEnable;
  final VoidCallback? onTap;

  const CustomNewsWidget({super.key,
    this.newsImages,
    this.title,
    this.timeAgo,
    this.description,
    this.image,
    this.isHome,
    this.date,
    this.time,
    this.shimmerEnable,
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
                  ? _newsWidget(context: context)
                  : CustomShimmerWidget(
                child: _newsWidget(context: context),
              )),
        ),
      ),
    );
  }

  Widget _newsWidget({required BuildContext context}) {
    return Column(
      children: [
        _newsImagePageViewBuilder(context: context),
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleAndTime(),
              SizedBox(height: 7.h),
              _description(),
              if (isHome == false) ...[
                SizedBox(height: 7.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _iconAndText(
                      icon: AssetPath.CALENDER_WITH_DOTS_ICON,
                      text: date,
                    ),
                    SizedBox(width: 17.w),
                    _iconAndText(
                      icon: AssetPath.TIME_ICON,
                      text: time,
                    ),
                  ],
                ),
              ],
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _newsImagePageViewBuilder({required BuildContext context}) {
    return (newsImages?.length ?? 0) > 0
        ? Container(
      width: 1.sw,
      height: 0.18.sh,
      child: PageView.builder(
        itemBuilder: (context, index) {
          return _newsImageWidget(
              context: context, newsData: newsImages?[index]);
        },
        itemCount: newsImages?.length ?? 0, // Can be null
      ),
    )
        : _newsImageWidget(context: context, newsData: null);
  }

  Widget _newsImageWidget(
      {required BuildContext context, NewsModelArticlesImages? newsData}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      child: Container(
        width: 1.sw,
        height: 0.18.sh,
        child: CustomExtendedImageWidget(
          imagePath: newsData?.url,
          imagePlaceholder: AssetPath.FEED_PLACEHOLDER_IMAGE,
          imageType: MediaPathType.network.name,
          fit: BoxFit.cover,
          // onTap: () {
          //   Constants.imageViewMethod(context: context,
          //       imagePath: newsData?.url,
          //       mediaPathType: MediaPathType.network.name);
          // },
        ),
      ),
    );
  }

  Widget _titleAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: _title()),
        SizedBox(
          width: 20.w,
        ),
        isHome == false ? const SizedBox() : _timeAgoWidget(),
      ],
    );
  }

  Widget _title() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: CustomText(
        text: title,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Medium,
        fontSize: 13.0.sp,
        maxLines: 2,
        textAlign: TextAlign.left,
        textOverflow: TextOverflow.ellipsis,
        lineSpacing: 1.25,
      ),
    );
  }

  Widget _timeAgoWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Container(
        color: AppColors.THEME_COLOR_DARK_GREEN,
        child: CustomText(
          text: timeAgo,
          fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
          fontFamily: AppFonts.Poppins_Medium,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  Widget _description() {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child:
      CustomText(
        text: description,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontFamily: AppFonts.Poppins_Regular,
        fontSize: 11.0.sp,
        textAlign: TextAlign.left,
        maxLines: 3,
        textOverflow: TextOverflow.ellipsis,
        lineSpacing: 1.4,
      ),
    );
  }

  Widget _iconAndText({required String icon, String? text}) {
    return Container(
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: Row(
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/home/models/news_model.dart';
import 'package:locks_hybrid/home/provider/news_provider.dart';
import 'package:locks_hybrid/latest_news/routing_arguments/latest_news_detail_arguments.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_news_widget.dart';
import 'package:provider/provider.dart';

class LatestNewsScreen extends StatefulWidget {

  @override
  State<LatestNewsScreen> createState() => _LatestNewsScreenState();
}

class _LatestNewsScreenState extends State<LatestNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
        title: AppStrings.LATEST_NEWS, child: _newsWaitingListWidget());
  }

  Widget _newsWaitingListWidget() {
    return Consumer<NewsProvider>(builder: (context, newsConsumerData, child) {
      return newsConsumerData.getWaitingStatus == true
          ? _newsShimmerListWidget()
          : (newsConsumerData.getNewsModel?.articles?.length ?? 0) > 0
              ? _newsListWidget(
                  newsObject: newsConsumerData.getNewsModel?.articles)
              : Center(
                  child: CustomErrorWidget(
                    errorImagePath: AssetPath.NEWS_ICON,
                    errorText: AppStrings.NO_NEWS_FOUND_ERROR,
                    imageColor: AppColors.THEME_COLOR_WHITE,
                    imageSize: 55.h,
                  ),
                );
    });
  }

  Widget _newsListWidget({List<NewsModelArticles?>? newsObject}) {
    return ListView.builder(
      itemCount: newsObject?.length ?? 0,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: ((context, index) {
        return _newsWidget(newsData: newsObject?[index]);
      }),
    );
  }

  Widget _newsWidget({NewsModelArticles? newsData}) {
    return CustomNewsWidget(
      isHome: false,
      newsImages: newsData?.images,
      title: newsData?.headline,
      timeAgo: Constants.timeAgoMethod(date: newsData?.lastModified),
      description: newsData?.description,
      date: Constants.getEventDate(eventTimeStamp: newsData?.lastModified),
      time: Constants.getEventTime(eventTimeStamp: newsData?.lastModified),
      shimmerEnable: false,
      onTap: () {
        AppNavigation.navigateTo(context, AppRouteName.LATEST_NEWS_DETAIL_SCREEN_ROUTE,
            arguments: LatestNewsDetailsArguments(newsModelArticles: newsData));
      },
    );
  }

  Widget _newsShimmerListWidget() {
    return ListView.builder(
      itemCount: 2,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: ((context, index) {
        return CustomNewsWidget(
          isHome: false,
          image: null,
          title: AppStrings.LOREM_IPSUM,
          description: AppStrings.DESCRIPTION_LOREM_IPSUM,
          date: AppStrings.NEWS_DATE_TEXT,
          time: AppStrings.NEWS_TIME_TEXT,
          shimmerEnable: true,
        );
      }),
    );
  }
}

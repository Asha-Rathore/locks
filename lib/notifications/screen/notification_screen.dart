import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/notifications/blocs/notification_bloc.dart';
import 'package:locks_hybrid/notifications/model/notification_model.dart';
import 'package:locks_hybrid/notifications/widgets/custom_notification_container.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_refresh_indicator_widget.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_text.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc _notificationBloc = NotificationBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callNotificationApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: AppStrings.NOTIFICATIONS,
      child: _notificationStreamBuilderWidget(),
    );
  }

  Widget _notificationStreamBuilderWidget() {
    return StreamBuilder(
      stream: _notificationBloc.getNotification(),
      builder: (BuildContext context,
          AsyncSnapshot<NotificationModel?>? notificationSnapshot) {
        return notificationSnapshot?.connectionState == ConnectionState.waiting
            ? _notificationListViewShimmerWidget()
            : _notificationRefreshIndicatorWidget(
                notificationObject: notificationSnapshot?.data);
      },
    );
  }

  Widget _notificationRefreshIndicatorWidget(
      {NotificationModel? notificationObject}) {
    return CustomRefreshIndicatorWidget(
        onRefresh: () async {
          await _callNotificationApiMethod();
        },
        child: (notificationObject?.data?.length ?? 0) > 0
            ? _notificationListViewWidget(
                notificationObject: notificationObject?.data)
            : Container(
                width: 1.sw,
                height: 1.sh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.3.sh),
                    child: CustomErrorWidget(
                      errorImagePath: AssetPath.NOTIFICATION2_ICON,
                      errorText: AppStrings.NO_NOTIFICATION_FOUND_ERROR,
                      imageColor: AppColors.THEME_COLOR_WHITE,
                      imageSize: 53.h,
                    ),
                  ),
                ),
              ));
  }

  Widget _notificationListViewWidget(
      {List<NotificationModelData?>? notificationObject}) {
    return ListView.builder(
      itemCount: notificationObject?.length ?? 0,
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: ((context, index) {
        return _notificationWidget(
            notificationData: notificationObject?[index]);
      }),
    );
  }

  Widget _notificationWidget({NotificationModelData? notificationData}) {
    return CustomNotificationContainer(
      title: notificationData?.type,
      description: notificationData?.message,
      time: Constants.timeAgoMethod(
          date: notificationData?.createdAt,
          parseFormat: AppStrings.UTC_DATE_24_HOUR2_FORMAT,
          locale: "en_short"),
      shimmerEnable: false,
    );
  }

  Widget _notificationListViewShimmerWidget() {
    return ListView.builder(
      itemCount: 2,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: ((context, i) {
        return CustomNotificationContainer(
          title: "Notification titles",
          description: "This is notification description",
          time: "",
          shimmerEnable: true,
        );
      }),
    );
  }

  Future<void> _callNotificationApiMethod() async {
    await _notificationBloc.notificationBlocMethod();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _notificationBloc.cancelStream();
    super.dispose();
  }
}

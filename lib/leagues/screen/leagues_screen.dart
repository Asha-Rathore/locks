import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_bloc.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/leagues_model.dart';
import 'package:locks_hybrid/leagues/provider/leagues_provider.dart';
import 'package:locks_hybrid/leagues/widgets/custom_leagues_container_widget.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/widgets/custom_error_widget.dart';
import 'package:locks_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_text.dart';

class LeaguesScreen extends StatefulWidget {
  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  LeaguesProvider? _leaguesProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_callLeaguesApiMethod();
    _callLeaguesApiMethod();
  }

  @override
  Widget build(BuildContext context) {
    _leaguesProvider = Provider.of<LeaguesProvider>(context, listen: true);

    return CustomPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _featuredLeaguesText(),
          SizedBox(height: 5.h),
          Expanded(child: _leaguesWaitingWidget()),
          // SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Widget _featuredLeaguesText() {
    return CustomText(
      text: AppStrings.FEATURED_LEAGUES,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontStyle: FontStyle.italic,
      fontSize: 16.sp,
      fontFamily: AppFonts.Poppins_Medium,
    );
  }

  Widget _leaguesWaitingWidget() {
    return _leaguesProvider?.getWaitingStatus == true
        ? _leaguesShimmerWidget()
        : _leaguesRefreshIndicatorWidget();
  }

  Widget _leaguesRefreshIndicatorWidget() {
    return CustomRefreshIndicatorWidget(
      onRefresh: () async {
        await _callLeaguesApiMethod();
      },
      child: (_leaguesProvider?.getLeaguesModel?.data?.length ?? 0) > 0
          ? _leaguesGridViewWidget(
              leaguesObject: _leaguesProvider?.getLeaguesModel?.data)
          : Container(
              height: 1.0.sh,
              width: 1.0.sw,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 0.2.sh),
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: CustomErrorWidget(
                  errorImagePath: AssetPath.LEAGUES_ICON,
                  errorText: AppStrings.NO_LEAGUES_FOUND_ERROR,
                  imageColor: AppColors.THEME_COLOR_WHITE,
                ),
              ),
            ),
    );
  }

  Widget _leaguesGridViewWidget({List<LeaguesModelData?>? leaguesObject}) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: leaguesObject?.length ?? 0,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 0.5.sw,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 15.h),
        itemBuilder: (BuildContext ctx, index) {
          return _leaguesWidget(leaguesData: leaguesObject?[index]);
        });
  }

  Widget _leaguesWidget({LeaguesModelData? leaguesData}) {
    return CustomLeaguesContainerWidget(
      image: Constants.getImage(imagePath: leaguesData?.strLeagueImage),
      title: Constants.concatLeagueTitleAbbreviationWidget(
          leagueName: leaguesData?.strLeagueName,
          leagueAbbreviation: leaguesData?.strLeagueAbbreviation),
      shimmerEnable: false,
      onTap: () {
        LeaguesService().setSingleLeagueData(
            singleLeagueData: leaguesData,
            isToast: true,
            setProgressBar: () {
              AppDialogs.circularProgressDialog(context: context);
            },
            onFailure: () {
              AppNavigation.navigatorPop(context);
            },
            onSuccess: () {
              AppNavigation.navigatorPop(context);
              AppNavigation.navigateTo(
                context,
                AppRouteName.LEAGUES_DETAIL_SCREEN_ROUTE,
              );
            });
      },
    );
  }

  Widget _leaguesShimmerWidget() {
    return GridView.builder(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 0.5.sw,
            crossAxisSpacing: 14.w,
            mainAxisSpacing: 15.h),
        itemCount: 5,
        itemBuilder: (BuildContext ctx, index) {
          return CustomLeaguesContainerWidget(
            title: AppStrings.NATIONAL_BASKETBALL_ASSOCIATION_TEXT,
            shimmerEnable: true,
          );
        });
  }


  Future<void> _callLeaguesApiMethod() async{
    await LeaguesService().callLeaguesApiMethod();
  }

// void _callLeaguesApiMethod() async {
//   _leaguesBloc.initializeLeaguesProvider(context: context);
//   // _leaguesBloc.clearData(context: context);
//   _leaguesBloc.leaguesBlocMethod(
//       context: context, apiTimeStamp: Constants.getApiTimesTamp());
// }
}

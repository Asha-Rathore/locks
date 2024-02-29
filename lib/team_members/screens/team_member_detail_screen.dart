import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/team_members/screens/former_team_screen.dart';
import 'package:locks_hybrid/team_members/screens/team_member_overview_screen.dart';
import 'package:locks_hybrid/team_members/widgets/custom_team_member_image_widget.dart';
import 'package:locks_hybrid/teams/models/team_members_model.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/widgets/custom_app_background.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_padding.dart';
import '../widgets/custom_barchart.dart';
import '../widgets/custom_tabbar.dart';

class TeamMemberDetailScreen extends StatefulWidget {
  final TeamMembersModelPlayer? teamMembersData;

  const TeamMemberDetailScreen({this.teamMembersData});

  @override
  State<TeamMemberDetailScreen> createState() => _TeamMemberDetailScreenState();
}

class _TeamMemberDetailScreenState extends State<TeamMemberDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int initialIndex = 0;
  double rating = 4.5;

  @override
  void initState() {
    setState(() {
      _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBackground(
      title: AppStrings.PLAYER_DETAILS_TEXT,
      appBarColor: AppColors.THEME_COLOR_DARK_GREEN,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _header(),
          _tabBarWidget(),
          SizedBox(height: 10.h),
          _tabBarView()
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      // width: double.infinity,
      color: AppColors.THEME_COLOR_DARK_GREEN,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profileImageWidget(),
          SizedBox(height: 12.h),
          _playerName(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _profileImageWidget() {
    return CustomTeamMemberImageWidget(
      imagePath: widget.teamMembersData?.strCutout,
      number: widget.teamMembersData?.strNumber,
    );
  }

  // void _onTapViewImage(
  //     {BuildContext? context, String? imagePath, bool? imageTypeFile}) {
  //   return AppNavigation.navigateTo(
  //     context!,
  //     AppRouteName.VIEW_FULL_IMAGE_SCREEN_ROUTE,
  //     arguments: ViewFullImageRoutingArguments(
  //         image: imagePath != null ? imagePath : AssetPath.PLAYER1,
  //         isImageTypeFile: imageTypeFile),
  //   );
  // }

  Widget _playerName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.getCountryImage(
                    countryName: widget.teamMembersData?.strNationality) ??
                AssetPath.USA_FLAG,
            height: 13.h,
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: CustomText(
              text: widget.teamMembersData?.strPlayer,
              //text: "dssd s s s dds s ds ss dds sd ds sdsssd ss s s",
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontSize: 16.sp,
              fontFamily: AppFonts.Poppins_SemiBold,
              textAlign: TextAlign.center,
              lineSpacing: 1.2,
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget _tabBarWidget() {
    return CustomTabBar(
      tabController: _tabController,
      firstTabText: AppStrings.OVERVIEW,
      secTabText: AppStrings.FORMER_TEAMS,
    );
  }

  Widget _tabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //------------------------- OVERVIEW -----------------------------//
          TeamMemberOverviewScreen(
            teamMembersData: widget.teamMembersData,
          ),

          //------------------------- FORMER TEAMS --------------------------- //
          FormerTeamScreen(
            playerId: widget.teamMembersData?.idPlayer,
          )
        ],
      ),
    );
  }

//------------------------------------ OVERVIEW ---------------------------------------//

//------------------------------------ PLAYER STATE ---------------------------------------//
}

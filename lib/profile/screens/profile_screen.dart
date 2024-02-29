import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locks_hybrid/auth/models/user_model.dart';
import 'package:locks_hybrid/auth/provider/user_provider.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/widgets/custom_padding.dart';
import 'package:locks_hybrid/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../../utils/asset_paths.dart';
import '../../widgets/custom_circular_profile.dart';

class ProfileScreen extends StatelessWidget {
  UserModelData? _userModelData;

  @override
  Widget build(BuildContext context) {
    _userModelData =
        Provider.of<UserProvider>(context, listen: true).getCurrentUser?.data;

    return Center(
      child: CustomPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            _userProfile(),
            SizedBox(height: 20.h),
            _dividerImage(),
            SizedBox(height: 50.h),
            _rowWidget(
              title: AppStrings.FULL_NAME,
              text: Constants.concatFirstLastName(
                  firstName: _userModelData?.firstName,
                  lastName: _userModelData?.lastName),
            ),
            _rowWidget(
              title: AppStrings.EMAIL_ADDRESS,
              text: _userModelData?.email,
            ),
            _rowWidget(
              title: AppStrings.PHONE_NUMBER,
              text: _userModelData?.phoneNumber != null
                  ? Constants.MASK_TEXT_FORMATTER_PHONE_NO
                      .maskText(_userModelData!.phoneNumber!)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _userProfile() {
    return CustomCircularImageWidget(
      height: 110.h,
      width: 110.h,
      borderWidth: 2,
      image: Constants.getImage(
          imagePath: _userModelData?.profileImage),
    );
  }

  Widget _dividerImage() {
    return Image.asset(
      AssetPath.DIVIDER_ICON,
      scale: 2.7,
    );
  }

  Widget _rowWidget({String? title, String? text}) {
    return text.checkNullEmptyText
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: title,
                    fontColor: AppColors.THEME_COLOR_WHITE,
                    fontFamily: AppFonts.Poppins_SemiBold,
                    fontSize: 16.sp,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomText(
                      text: text,
                      fontColor: AppColors.THEME_COLOR_LIGHT_GREEN,
                      fontFamily: AppFonts.Poppins_Regular,
                      fontSize: 14.sp,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _divider(),
              SizedBox(height: 10.h),
            ],
          )
        : Container();
  }

  Widget _divider() {
    return Divider(
      color: AppColors.THEME_COLOR_WHITE.withOpacity(0.4),
      thickness: 1.5,
    );
  }
}

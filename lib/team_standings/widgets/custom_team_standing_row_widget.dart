// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:locks_hybrid/utils/app_colors.dart';
// import 'package:locks_hybrid/utils/app_fonts.dart';
// import 'package:locks_hybrid/widgets/custom_text.dart';
//
// class CustomTeamStandingRowWidget extends StatelessWidget {
//
//   String? rank,teamName,fieldOne,fieldTwo,fieldThree,fieldFour,fieldFive;
//
//   CustomTeamStandingRowWidget({
//     this.rank,
//     this.teamName,
//     this.fieldOne,
//     this.fieldTwo,
//     this.fieldThree,
//     this.fieldFour,
//     this.fieldFive
// });
//
//   @override
//   Widget build(BuildContext context) {
//     return _standingsRowWidget();
//   }
//
//   Widget _standingsRowWidget() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 5.0.w),
//       child: Column(
//         children: [
//           SizedBox(height: 20.h),
//           Row(
//             children: [
//               _textWidget(text:rank, textAlign:TextAlign.left),
//
//               _textWidget(text:"Inter Miami", textAlign:TextAlign.left),
//
//               _textWidget(text:"1"),
//
//               _textWidget(text:"1"),
//
//               _textWidget(text:"1"),
//
//               _textWidget(text:"1"),
//             ],
//           ),
//           SizedBox(height: 10.h),
//           _divider(),
//           //showDivider! ? _divider() : SizedBox(height: 10.h),
//         ],
//       ),
//     );
//   }
//
//   Widget _textWidget({String? text, TextAlign? textAlign}) {
//     return CustomText(
//       text: text,
//       fontColor: AppColors.THEME_COLOR_WHITE,
//       fontFamily: AppFonts.Poppins_Medium,
//       fontSize: 14.sp,
//       textAlign: textAlign ?? TextAlign.center,
//     );
//   }
//
//   Widget _divider() {
//     return const Divider(
//       color: AppColors.THEME_COLOR_WHITE,
//       thickness: 0.3,
//     );
//   }
// }

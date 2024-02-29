import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_colors.dart';

class AppDialogs {
  static void showToast({String? message}) {
    Fluttertoast.showToast(
      msg: message ?? "",
      textColor: AppColors.THEME_COLOR_WHITE,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  static Widget circularProgressWidget() {
    return CircularProgressIndicator(
      color: AppColors.LIGHT_PRIMARY_COLOR,
    );
  }

  //circular progress dialog
  static void circularProgressDialog({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.LIGHT_PRIMARY_COLOR,
              ),
            ),
          );
        });
  }

  //
  //
  //flushbar dialog
  // static void flushBarDialog({required BuildContext context,String? message}) {
  //   Flushbar(
  //     messageText: Padding(
  //       padding: EdgeInsets.only(left: 8.0,right: 14.0),
  //       child: CustomTextWidget(
  //         text: message,
  //         textColor: AppColors.WHITE_COLOR,
  //         fontSize: 1.18,
  //       ),
  //     ),
  //     icon: Padding(
  //       padding: EdgeInsets.only(left: 14.0),
  //       child: Icon(
  //         Icons.info_outline,
  //         size: 22.0,
  //         color: AppColors.WHITE_COLOR,
  //       ),
  //     ),
  //     duration:  Duration(seconds: 1),
  //     backgroundColor: AppColors.RED_COLOR,
  //     flushbarPosition: FlushbarPosition.TOP,
  //     // flushbarStyle: FlushbarStyle.FLOATING,
  //     borderRadius: BorderRadius.circular(8.0),
  //     padding: EdgeInsets.symmetric(vertical: 16.0),
  //     margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
  //   )..show(context);
  // }

  //any other dialog open in app
  static void showMainDialogMethod(
      {required BuildContext context, required Widget child}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return child;
        });
  }
}

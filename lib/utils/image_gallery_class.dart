import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locks_hybrid/utils/app_colors.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_fonts.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/network_strings.dart';

import 'app_navigation.dart';
import 'app_strings.dart';

class ImageGalleryClass {
  ImagePicker picker = ImagePicker();
  XFile? getFilePath;
  CroppedFile? croppedImageFile;
  File? imageFile;
  Map<String, dynamic> _imageFileObject = {
    "media_path": null,
    "thumbnail_image_Path": null,
    "media_type": null
  };

  Map<String, dynamic>? imageGalleryBottomSheet(
      {required BuildContext context,
      required ValueChanged<Map<String, dynamic>?> onMediaChanged}) {
    showModalBottomSheet(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(40.r),
        //     topRight: Radius.circular(40.r),
        //   ),
        // ),
        context: context,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(40.r),
              //   topRight: Radius.circular(40.r),
              // ),
              color: AppColors.PRIMARY_COLOR,
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
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        getCameraImage(
                            onMediaChanged: onMediaChanged, context: context);
                      },
                      child: _cameraIconRow()),
                  _divider(),
                  GestureDetector(
                      onTap: () {
                        getGalleryImage(
                            onMediaChanged: onMediaChanged, context: context);
                      },
                      child: _galleryIconRow()),
                ],
              ),
            ),
          );
        });
    return null;
  }

  Widget _divider() {
    return const Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: 0.3,
    );
  }

  Widget _cameraIconRow() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.camera_enhance,
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            AppStrings.CAMERA_TEXT,
            style: TextStyle(
              color: AppColors.THEME_COLOR_WHITE,
              fontFamily: AppFonts.Poppins_SemiBold,
              fontSize: 16.sp,
            ),
            textScaleFactor: 1.3,
          ),
        ],
      ),
    );
  }

  Widget _galleryIconRow() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.image,
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            AppStrings.GALLERY_TEXT,
            style: TextStyle(
              color: AppColors.THEME_COLOR_WHITE,
              fontFamily: AppFonts.Poppins_SemiBold,
              fontSize: 16.sp,
            ),
            textScaleFactor: 1.3,
          ),
        ],
      ),
    );
  }

  void getCameraImage(
      {required ValueChanged<Map<String, dynamic>?> onMediaChanged,
      required BuildContext context}) async {
    try {
      getFilePath =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (getFilePath != null) {
        cropImage(
            imageFilePath: getFilePath!.path,
            onMediaChanged: onMediaChanged,
            context: context);
      } else {
        AppNavigation.navigatorPop(context);
      }
    } on PlatformException catch (e) {
      AppDialogs.showToast(
          message: e.message ?? NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }

  void getGalleryImage(
      {required ValueChanged<Map<String, dynamic>?> onMediaChanged,
      required BuildContext context}) async {
    try {
      getFilePath =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (getFilePath != null) {
        cropImage(
            imageFilePath: getFilePath!.path,
            onMediaChanged: onMediaChanged,
            context: context);
      } else {
        AppNavigation.navigatorPop(context);
      }
    } on PlatformException catch (e) {
      AppDialogs.showToast(
          message: e.message ?? NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }

  void cropImage(
      {String? imageFilePath,
      required BuildContext context,
      required ValueChanged<Map<String, dynamic>?> onMediaChanged}) async {
    AppNavigation.navigatorPop(context);
    croppedImageFile = await ImageCropper().cropImage(
      sourcePath: imageFilePath!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppStrings.APP_TITLE,
          toolbarColor: AppColors.THEME_COLOR_BLACK,
          toolbarWidgetColor: AppColors.THEME_COLOR_WHITE,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    //if image cropped then set object
    if (croppedImageFile != null) {
      _imageFileObject["media_path"] = croppedImageFile!.path;
      _imageFileObject["thumbnail_image_Path"] = null;
      _imageFileObject["media_type"] = MediaType.image.name;
      onMediaChanged(_imageFileObject);
    } else {
      _imageFileObject["media_path"] = null;
      _imageFileObject["thumbnail_image_Path"] = null;
      _imageFileObject["media_type"] = null;
      onMediaChanged(_imageFileObject);
    }
  }
}

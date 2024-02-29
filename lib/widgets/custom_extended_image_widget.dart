import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/utils/enums.dart';

class CustomExtendedImageWidget extends StatelessWidget {
  final String? imagePath, imageType;
  final String imagePlaceholder;
  final BoxFit? fit;
  final Color? placeholderColor,imageColor;
  final VoidCallback? onTap;

  CustomExtendedImageWidget(
      {this.imagePath,
        this.imageType,
        required this.imagePlaceholder,
        this.imageColor,
        this.placeholderColor,
        this.fit,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return imagePath != null && imageType == MediaPathType.file.name
        ? GestureDetector(
      onTap: onTap,
      child: ExtendedImage.file(
        File(imagePath!),
        fit: fit ?? BoxFit.cover,
        color: imageColor,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );

            case LoadState.failed:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );
          }
        },
        //cancelToken: cancellationToken,
      ),
    )
        : imagePath != null && imageType == MediaPathType.network.name
        ? GestureDetector(
      onTap: onTap,
      child: ExtendedImage.network(
        imagePath!,
        fit: fit ?? BoxFit.cover,
        color: imageColor,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );

            case LoadState.failed:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );
          }
        },
        //cancelToken: cancellationToken,
      ),
    )
     : imagePath != null && imageType == MediaPathType.asset.name
        ? GestureDetector(
      onTap: onTap,
      child: ExtendedImage.asset(
        imagePath!,
        color: imageColor,
        fit: fit ?? BoxFit.cover,
        loadStateChanged: (state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );

            case LoadState.failed:
              return Image.asset(
                imagePlaceholder,
                fit: fit ?? BoxFit.cover,
                color: placeholderColor,
              );
          }
        },
        //cancelToken: cancellationToken,
      ),
    )

        : Image.asset(
      imagePlaceholder,
      fit: fit ?? BoxFit.cover,
      color: placeholderColor,
    );
  }
}

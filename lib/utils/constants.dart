import 'package:flutter/material.dart';
import 'package:locks_hybrid/leagues/blocs/leagues_service.dart';
import 'package:locks_hybrid/leagues/models/teams_model.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/asset_paths.dart';
import 'package:locks_hybrid/utils/country_images.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:locks_hybrid/view_full_image/routing_arguments/full_image_routing_arguments.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:timeago/timeago.dart' as timeAgo;


class Constants {
  static const EMAIL_MAX_LENGTH = 35;
  static const PASSWORD_MAX_LENGTH = 30;
  static const NAME_MAX_LENGTH = 30;
  static const DESCRIPTION_MAX_LENGTH = 275;
  static const ZIP_CODE_MAX_LENGTH = 7;
  static const CVC_LENGTH = 3;

  ///---------------- Sports Db Api Show Length ------------------- ///
  static const TEAMS_SHOW_LENGTH = 6;
  static const TEAM_MEMBERS_SHOW_LENGTH = 6;
  static const EVENTS_LENGTH = 2;
  static const HOME_LIVE_EVENTS_LENGTH = 1;
  static const NEWS_LENGTH = 2;

  static MaskTextInputFormatter MASK_TEXT_FORMATTER_PHONE_NO =
      MaskTextInputFormatter(
          mask: '(###) ###-####',
          filter: {"#": RegExp(r'[0-9]')},
          type: MaskAutoCompletionType.lazy);

  static void unFocusKeyboardMethod({required BuildContext context}) {
    FocusScope.of(context).unfocus();
  }

  static String? getImage({String? imagePath}) {
    if (imagePath.checkNullEmptyText) {
      return NetworkStrings.NETWORK_IMAGE_BASE_URL + imagePath!;
    }
    return null;
  }

  static String? concatFirstLastName({String? firstName, String? lastName}) {
    return (firstName ?? "") + " " + (lastName ?? "");
  }

  static String? concatLeagueTitleAbbreviationWidget(
      {String? leagueName, String? leagueAbbreviation}) {
    return (leagueName ?? "") + " (" + (leagueAbbreviation ?? "") + ")";
  }

  static bool checkListLength({int? totalLength, int? showLength}) {
    //If list total length greater than needed show length
    if ((totalLength ?? 0) > (showLength ?? 0)) {
      return true;
    }

    return false;
  }

  //get api stamp
  static String getApiTimesTamp() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  //image view method
  static void imageViewMethod(
      {required BuildContext context,
      String? imagePath,
      String? mediaPathType}) {
    if (imagePath.checkNullEmptyText == true) {
      AppNavigation.navigateTo(
        context,
        AppRouteName.VIEW_FULL_IMAGE_SCREEN_ROUTE,
        arguments: ViewFullImageRoutingArguments(
            imagePath: imagePath,
            mediaPathType: mediaPathType ?? MediaPathType.network.name),
      );
    }
  }

  static DateTime parseDateTime(
      {required String parseFormat,
      required String inputDateTime,
      bool utc = false}) {
    return DateFormat(parseFormat).parse(inputDateTime, utc);
  }

  static String formatDateTime(
      {required String parseFormat, required DateTime inputDateTime}) {
    return DateFormat(parseFormat).format(inputDateTime);
  }

  static String? getEventDate({String? eventTimeStamp}) {
    try {
      if (eventTimeStamp != null && eventTimeStamp.isNotEmpty) {
        return Constants.formatDateTime(
            parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_MMM_DD_YYYY,
            inputDateTime: Constants.parseDateTime(
                parseFormat: AppStrings.UTC_DATE_24_HOUR_FORMAT,
                inputDateTime: eventTimeStamp,
                utc: true)
                .toLocal());
      }
    }catch(e){

    }
    return null;
  }




  static String? getLiveEventData({String? eventTimeStamp}) {
    try {
      if (eventTimeStamp != null && eventTimeStamp.isNotEmpty) {
        return Constants.formatDateTime(
            parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_YYYY_MM_DD,
            inputDateTime: Constants.parseDateTime(
                parseFormat: AppStrings.UTC_DATE_24_HOUR_FORMAT,
                inputDateTime: eventTimeStamp,
                utc: true)
                .toLocal());
      }
    }catch(e){

    }
    return null;
  }

  static String? getEventLocation(
      {String? eventVenue, String? eventCity, String? eventCountry}) {
    List _eventLocationList = [];

    eventVenue.checkNullEmptyText ? _eventLocationList.add(eventVenue) : null;
    eventCity.checkNullEmptyText ? _eventLocationList.add(eventCity) : null;
    eventCountry.checkNullEmptyText
        ? _eventLocationList.add(eventCountry)
        : null;

    return _eventLocationList.join(",");
  }

  static String? getEventDay({String? eventTimeStamp}) {
    try {
      if (eventTimeStamp != null && eventTimeStamp.isNotEmpty) {
        return Constants.formatDateTime(
            parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_EEEE,
            inputDateTime: Constants.parseDateTime(
                parseFormat: AppStrings.UTC_DATE_24_HOUR_FORMAT,
                inputDateTime: eventTimeStamp,
                utc: true)
                .toLocal());
      }
    }catch(e){

    }
    return null;
  }

  static String? getEventTime({String? eventTimeStamp}) {
    try {
      if (eventTimeStamp != null && eventTimeStamp.isNotEmpty) {
        return Constants.formatDateTime(
            parseFormat: AppStrings.DATE_MONTH_YEAR_12_HOUR_FORMAT_HH_MM,
            inputDateTime: Constants.parseDateTime(
                parseFormat: AppStrings.UTC_DATE_24_HOUR_FORMAT,
                inputDateTime: eventTimeStamp,
                utc: true)
                .toLocal());
      }
    }catch(e){

    }
    return null;
  }

  static String? getMilestoneYear({String? milestoneDate}) {
    try {
      if (milestoneDate != null && milestoneDate.isNotEmpty) {
        return Constants.formatDateTime(
            parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_YYYY,
            inputDateTime: Constants.parseDateTime(
                parseFormat: AppStrings.DATE_MONTH_YEAR_FORMAT_YYYY_MM_DD,
                inputDateTime: milestoneDate,
                utc: true)
                .toLocal());
      }
    }catch(e){

    }
    return null;
  }


  static String? getTeamImage({String? teamName}) {
    int index = -1;
    if (teamName != null && teamName.isNotEmpty) {
      index = LeaguesService()
              .getTeamsProvider
              ?.getTeamsModel
              ?.teams
              ?.indexWhere(
                  (teamModelData) => teamModelData?.strTeam == teamName) ??
          -1;

      if (index >= 0) {
        return LeaguesService()
            .getTeamsProvider
            ?.getTeamsModel
            ?.teams?[index]
            ?.strTeamBadge;
      }

      return null;
    }
    return null;
  }

  static bool showScore({String? homeScore, String? awayScore}) {
    if (homeScore.checkNullEmptyText == true &&
        awayScore.checkNullEmptyText == true) {
      return true;
    }
    return false;
  }

  static String? getCountryImage({String? countryName}) {
    Country? _countryData = CountryFlags.firstWhereOrNull(
        (countryObject) => countryObject.name == countryName);

    if (_countryData != null) {
      return "${AssetPath.COUNTRY_FLAGS}/${_countryData.code.toLowerCase()}.png";
    }

    return null;
  }


  static String? timeAgoMethod(
      {String? date,
       String parseFormat = AppStrings.UTC_DATE_24_HOUR_FORMAT,
      String? locale}) {
    String? timeAgoTime;
    if (date != null && date.isNotEmpty) {
      DateTime newsDateTime = parseDateTime(
          parseFormat: AppStrings.UTC_DATE_24_HOUR_FORMAT,
          // parseFormat: endPoint == NetworkStrings.SHOW_POST_LIST_ENDPOINT ||
          //         endPoint == NetworkStrings.COMMENT_LIST_ENDPOINT ||
          //         endPoint == NetworkStrings.SHOW_ROOM_POST_LIST_ENDPOINT
          //     ? AppStrings.UTC_DATE_FORMAT
          //     : AppStrings.UTC_DATE_FORMAT2,
          inputDateTime: date,
          utc: true)
          .toLocal();
      //log("Created date time:${createdDateTime}");
      timeAgoTime = timeAgo.format(newsDateTime,locale: locale ?? "en");
    }
    return timeAgoTime;
  }


  static String? getSeasonData({String? seasonYear}) {
     List _seasonList = [];

     _seasonList = seasonYear?.split("-") ?? [];

     if(_seasonList.length ==2){
       return _seasonList[1];
     }
     else if(_seasonList.length == 1)
       {
         return _seasonList[0];
       }


    return null;
  }



  static String US_COUNTRY_CODE = "US";
  static String US_PHONE_CODE = "+1";
}

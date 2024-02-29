import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:locks_hybrid/services/connectivity_manager.dart';
import 'package:locks_hybrid/services/shared_preference.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/network_strings.dart';
import 'package:locks_hybrid/utils/static_data.dart';

class Network {
  static Dio? _dio;
  static CancelToken? _cancelRequestToken;

  static Network? _network;

  static ConnectivityManager? _connectivityManager;

  Network._createInstance();

  factory Network() {
    // factory with constructor, return some value
    if (_network == null) {
      _network = Network
          ._createInstance(); // This is executed only once, singleton object

      _dio = _getDio();
      _cancelRequestToken = _getCancelToken();

      _connectivityManager = ConnectivityManager();
    }
    return _network!;
  }

  static Dio _getDio() {
    // BaseOptions options = new BaseOptions(
    //   connectTimeout: 20000,
    // );
    return _dio ??= Dio();
  }

  static CancelToken _getCancelToken() {
    return _cancelRequestToken ??= CancelToken();
  }

  ////////////////// Get Request /////////////////////////
  Future<Response?> getRequest(
      {String baseUrl = NetworkStrings.SPORTS_DB_API_BASE_URL,
      required String endPoint,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      bool isErrorToast = true,
      bool isStandingsApi = false,
      int connectTimeOut = 20000,
      required bool isHeaderRequire}) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.get(baseUrl + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
              headers: _setHeader(isHeaderRequire: isHeaderRequire),
              sendTimeout: connectTimeOut,
              receiveTimeout: connectTimeOut,
            ));
        //print(response);
      } on DioError catch (e) {
        log("Error:${e.response.toString()}");
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isStandingsApi: isStandingsApi,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: " + e.message);
      }
    } else {
      _noInternetConnection(onFailure: onFailure,isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Post Request /////////////////////////
  Future<Response?> postRequest({
    String baseUrl = NetworkStrings.SPORTS_DB_API_BASE_URL,
    required String endPoint,
    FormData? formData,
    VoidCallback? onFailure,
    bool isToast = true,
    int connectTimeOut = 20000,
    bool isErrorToast = true,
    required bool isHeaderRequire,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.post(baseUrl + endPoint,
            data: formData,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: " + e.message);
      }
    } else {
      _noInternetConnection(onFailure: onFailure,isErrorToast: isErrorToast);
    }
    return response;
  }

  ////////////////// Put Request /////////////////////////
  Future<Response?> putRequest(
      {String baseUrl = NetworkStrings.SPORTS_DB_API_BASE_URL,
      required String endPoint,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      int connectTimeOut = 20000,
      bool isErrorToast = true,
      required bool isHeaderRequire}) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.put(baseUrl + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
        //print(response);
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: " + e.message);
      }
    } else {
      _noInternetConnection(onFailure: onFailure,isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Delete Request /////////////////////////
  Future<Response?> deleteRequest(
      {String baseUrl = NetworkStrings.SPORTS_DB_API_BASE_URL,
      required String endPoint,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      int connectTimeOut = 20000,
      bool isErrorToast = true,
      required bool isHeaderRequire}) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.delete(baseUrl + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
        print(response.toString());
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: " + e.message);
      }
    } else {
      _noInternetConnection(onFailure: onFailure,isErrorToast: isErrorToast);
    }
    return response;
  }

  ////////////////// Get Stripe Request /////////////////////////
  // Future<Response?> getStripeRequest(
  //     {required BuildContext context,
  //       required String endPoint,
  //       Map<String, dynamic>? queryParameters,
  //       int connectTimeOut = 20000,
  //       bool isErrorToast = true,
  //       VoidCallback? onFailure}) async {
  //   Response? response;
  //
  //   if (await _connectivityManager!.isInternetConnected()) {
  //     try {
  //       _dio?.options.connectTimeout = connectTimeOut;
  //       response =
  //       await _dio!.get(NetworkStrings.STRIPE_API_BASE_URL + endPoint,
  //           queryParameters: queryParameters,
  //           cancelToken: _cancelRequestToken,
  //           options: Options(
  //               contentType: Headers.formUrlEncodedContentType,
  //               headers: {
  //                 'Authorization':
  //                 "Bearer ${NetworkStrings.STRIPE_SECRET_KEY}",
  //               },
  //               sendTimeout: connectTimeOut,
  //               receiveTimeout: connectTimeOut));
  //       //print(response);
  //     } on DioError catch (e) {
  //       _validateException(
  //           response: e.response,
  //           context: context,
  //           message: e.message,
  //           normalRequest: false,
  //           onFailure: onFailure,
  //           isErrorToast: isErrorToast);
  //       print("$endPoint Dio: " + e.message);
  //     }
  //   } else {
  //     _noInternetConnection(onFailure: onFailure);
  //   }
  //
  //   return response;
  // }

  ////////////////// Post Stripe Request /////////////////////////
  // Future<Response?> postStripeRequest(
  //     {required BuildContext context,
  //       required String endPoint,
  //       Map<String, dynamic>? formEncodedData,
  //       int connectTimeOut = 20000,
  //       bool isErrorToast = true,
  //       VoidCallback? onFailure}) async {
  //   Response? response;
  //   if (await _connectivityManager!.isInternetConnected()) {
  //     try {
  //       _dio?.options.connectTimeout = connectTimeOut;
  //       response =
  //       await _dio!.post(NetworkStrings.STRIPE_API_BASE_URL + endPoint,
  //           data: formEncodedData,
  //           cancelToken: _cancelRequestToken,
  //           options: Options(
  //               contentType: Headers.formUrlEncodedContentType,
  //               headers: {
  //                 'Authorization':
  //                 "Bearer ${NetworkStrings.STRIPE_SECRET_KEY}",
  //               },
  //               sendTimeout: connectTimeOut,
  //               receiveTimeout: connectTimeOut));
  //       // print("Response body:"+response.toString());
  //       print("Response Status code:" + response.statusCode.toString());
  //     } on DioError catch (e) {
  //       _validateException(
  //           response: e.response,
  //           context: context,
  //           message: e.message,
  //           normalRequest: false,
  //           onFailure: onFailure,
  //           isErrorToast: isErrorToast);
  //       print("$endPoint Dio: " + e.message.toString());
  //     }
  //   } else {
  //     _noInternetConnection(onFailure: onFailure);
  //   }
  //   return response;
  // }

  ////////////////// Delete Stripe Request /////////////////////////
  // Future<Response?> deleteStripeRequest(
  //     {required BuildContext context,
  //       required String endPoint,
  //       Map<String, dynamic>? queryParameters,
  //       int connectTimeOut = 20000,
  //       bool isErrorToast = true,
  //       VoidCallback? onFailure}) async {
  //   Response? response;
  //   if (await _connectivityManager!.isInternetConnected()) {
  //     try {
  //       _dio?.options.connectTimeout = connectTimeOut;
  //       response =
  //       await _dio!.delete(NetworkStrings.STRIPE_API_BASE_URL + endPoint,
  //           queryParameters: queryParameters,
  //           cancelToken: _cancelRequestToken,
  //           options: Options(
  //               contentType: Headers.formUrlEncodedContentType,
  //               headers: {
  //                 'Authorization':
  //                 "Bearer ${NetworkStrings.STRIPE_SECRET_KEY}",
  //               },
  //               sendTimeout: connectTimeOut,
  //               receiveTimeout: connectTimeOut));
  //       //print(response.toString());
  //     } on DioError catch (e) {
  //       _validateException(
  //         response: e.response,
  //         context: context,
  //         message: e.message,
  //         normalRequest: false,
  //         onFailure: onFailure,
  //       );
  //       print("$endPoint Dio: " + e.message);
  //     }
  //   } else {
  //     _noInternetConnection(onFailure: onFailure);
  //   }
  //   return response;
  // }

  ////////////////// Get Request /////////////////////////
  Future<Response?> getGifRequest({
    required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    bool isErrorToast = true,
    int connectTimeOut = 20000,
  }) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.get(endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
              sendTimeout: connectTimeOut,
              receiveTimeout: connectTimeOut,
            ));
        //print(response);
      } on DioError catch (e) {
        log("Error:${e.response.toString()}");
        _validateException(
            response: e.response,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        print("$endPoint Dio: " + e.message);
      }
    } else {
      _noInternetConnection(onFailure: onFailure,isErrorToast: isErrorToast);
    }

    return response;
  }

  ////////////////// Set Header /////////////////////
  _setHeader({required bool isHeaderRequire}) {
    if (isHeaderRequire == true) {
      String token = SharedPreference().getBearerToken() ?? "";
      return {
        'Accept': NetworkStrings.ACCEPT,
        'Authorization': "Bearer $token",
      };
    } else {
      return {
        'Accept': NetworkStrings.ACCEPT,
      };
    }
  }

  ////////////////// Validate Response /////////////////////
  void validateResponse(
      {Response? response,
      VoidCallback? onSuccess,
      VoidCallback? onFailure,
      bool isToast = true}) {
    var validateResponseData = response?.data;

    if (validateResponseData != null) {
      isToast
          ? AppDialogs.showToast(message: validateResponseData['message'] ?? "")
          : null;

      if (response!.statusCode == NetworkStrings.SUCCESS_CODE) {
        if (onSuccess != null) {
          onSuccess();
        }
        // if (validateResponseData['status'] ==
        //     NetworkStrings.API_SUCCESS_STATUS) {
        //   if (onSuccess != null) {
        //     onSuccess();
        //   }
        // } else {
        //   if (onFailure != null) {
        //     onFailure();
        //   }
        // }
      } else {
        if (onFailure != null) {
          onFailure();
        }
        //log(response.statusCode.toString());
      }
    }
  }

  ////////////////// Stripe Validate Response /////////////////////
  // void stripeValidateResponse(
  //     {Response? response, VoidCallback? onSuccess, VoidCallback? onFailure}) {
  //   var validateResponseData = response?.data;
  //
  //   if (validateResponseData != null) {
  //     if (response!.statusCode == NetworkStrings.SUCCESS_CODE) {
  //       if (onSuccess != null) {
  //         onSuccess();
  //       }
  //     } else {
  //       if (onFailure != null) {
  //         onFailure();
  //       }
  //       //log(response.statusCode.toString());
  //     }
  //   }
  // }

  ////////////////// Validate Response /////////////////////
  // void validateGifResponse(
  //     {Response? response, VoidCallback? onSuccess, VoidCallback? onFailure}) {
  //   var validateResponseData = response?.data;
  //
  //   if (validateResponseData != null) {
  //     if (response!.statusCode == NetworkStrings.SUCCESS_CODE) {
  //       if (onSuccess != null) {
  //         onSuccess();
  //       }
  //     }
  //   } else {
  //     if (onFailure != null) {
  //       onFailure();
  //     }
  //     //log(response!.statusCode!.toString());
  //   }
  // }

  ////////////////// Validate Exception /////////////////////
  void _validateException(
      {Response? response,
      String? message,
      bool normalRequest = true,
      bool isToast = true,
      bool isErrorToast = true,
        bool isStandingsApi = false,
        VoidCallback? onFailure}) {
    log("Response:${response.toString()}");

    if (onFailure != null) {
      onFailure();
    }
    if (response?.statusCode == NetworkStrings.CARD_ERROR_CODE) {
      AppDialogs.showToast(
          message: response?.data["error"]["message"] != null
              ? response?.data["error"]["message"]
              : NetworkStrings.INVALID_CARD_ERROR);
    } else if (response?.statusCode == NetworkStrings.BAD_REQUEST_CODE) {
      //to check normal api or stripe bad request error
      if (normalRequest == true) {
        //for normal api request error
        isToast
            ? AppDialogs.showToast(message: response?.data["message"] ?? "")
            : null;
      } else {
        //for stripe bad request error
        AppDialogs.showToast(
            message: response?.data["error"]["message"] != null
                ? response?.data["error"]["message"]
                : NetworkStrings.INVALID_BANK_ACCOUNT_DETAILS_ERROR);
      }
    } else if (response?.statusCode == NetworkStrings.FORBIDDEN_CODE) {
      //to check normal api or stripe bad request error
      AppDialogs.showToast(message: response?.data["message"] ?? "");
    } else {
      isErrorToast
          ? AppDialogs.showToast(
              message: response?.statusMessage ?? message.toString())
          : null;
    }
    if (response?.statusCode == NetworkStrings.UNAUTHORIZED_CODE && isStandingsApi == false) {
      StaticData.clearAllAppData(
          context: StaticData.navigatorKey.currentContext!);
    }
  }

  ////////////////// No Internet Connection /////////////////////
  void _noInternetConnection({VoidCallback? onFailure, bool? isErrorToast}) {
    if (onFailure != null) {
      onFailure();
    }
    isErrorToast == true
        ? AppDialogs.showToast(message: NetworkStrings.NO_INTERNET_CONNECTION)
        : null;
  }

// ////////////////// On TimeOut /////////////////////
// void _onTimeOut({String message, onFailure}) {
//   if (onFailure != null) {
//     onFailure();
//   }
//   AppDialogs.showToast(message: message);
// }
}

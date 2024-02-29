import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locks_hybrid/auth/blocs/social_login_bloc.dart';
import 'package:locks_hybrid/auth/routing_arguments/otp_arguments.dart';
import 'package:locks_hybrid/utils/app_dialogs.dart';
import 'package:locks_hybrid/utils/app_navigation.dart';
import 'package:locks_hybrid/utils/app_route_name.dart';
import 'package:locks_hybrid/utils/app_strings.dart';
import 'package:locks_hybrid/utils/enums.dart';
import 'package:locks_hybrid/utils/extension.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthBloc {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  User? _user;
  SocialLoginBloc _socialLoginBloc = SocialLoginBloc();

  ///-------------------- Google Sign In -------------------- ///
  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

      if (_googleSignInAccount != null) {
        await _googleSignIn.signOut();

        // log("First name:${_googleSignInAccount.displayName?.splitName()[0]}");
        // log("Last name:${_googleSignInAccount.displayName?.splitName()[1]}");
        // log("Social id:${_googleSignInAccount.id}");
        // log("Social email:${_googleSignInAccount.email}");

        _socialLoginMethod(
          context: context,
          socialToken: _googleSignInAccount.id,
          socialType: SocialType.google.name,
          firstName: _googleSignInAccount.displayName?.splitName()[0],
          lastName: _googleSignInAccount.displayName?.splitName()[1],
        );
      }
    } catch (error) {
      log(error.toString());
      AppDialogs.showToast(message: error.toString());
    }
  }

  // ///-------------------- Facebook Sign In -------------------- ///
  // Future<void> signInWithFacebook({required BuildContext context}) async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login(
  //       permissions: ['public_profile', 'email'],
  //     );
  //     if (result.status == LoginStatus.success) {
  //       // log("Graph response body" + graphResponse.body.toString());
  //       Map<String, dynamic> facebookUserData =
  //       await FacebookAuth.instance.getUserData();
  //
  //       await FacebookAuth.instance.logOut();
  //
  //       if (facebookUserData != null) {
  //         log("Facebook User Data:${facebookUserData.toString()}");
  //         _facebookUserName = facebookUserData["name"];
  //         _socialLoginMethod(
  //             context: context,
  //             firstName: _facebookUserName?.splitName()[0],
  //             lastName: _facebookUserName?.splitName()[1],
  //             email: facebookUserData["email"],
  //             socialToken: facebookUserData["id"],
  //             socialType: AppStrings.FACEBOOK_SOCIAL_TYPE);
  //       }
  //     } else if (result.status == LoginStatus.failed) {
  //       AppDialogs.showToast(message: result.message.toString());
  //       //print(result.message.toString());
  //     } else if (result.status == LoginStatus.cancelled) {
  //       AppDialogs.showToast(message: result.message.toString());
  //       //print(result.message.toString());
  //     }
  //   } catch (error) {
  //     // print(error.toString());
  //     AppDialogs.showToast(message: error.toString());
  //   }
  // }

  //-------------------- Apple Sign In -------------------- //

  Future<void> signInWithApple({required BuildContext context}) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential != null) {
        _socialLoginMethod(
          context: context,
          socialToken: credential.userIdentifier,
          socialType: SocialType.apple.name,
          firstName: credential.givenName,
          lastName: credential.familyName,
        );
      }
    } catch (error) {
      //print(error.toString());
      AppDialogs.showToast(message: error.toString());
    }
  }

  ////////////////////////// Phone Sign In //////////////////////////////////
  Future<void> signInWithPhone({
    required BuildContext context,
    required String phoneCode,
    required String countryCode,
    required String phoneNumber,
    required VoidCallback setProgressBar,
    // required VoidCallback cancelProgressBar
  }) async {
    try {
      //setProgressBar();
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneCode + phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {
            print("verification completed");
          },
          verificationFailed: (FirebaseAuthException authException) {
            if (authException.code == AppStrings.INVALID_PHONE_NUMBER) {
              //cancelProgressBar();
              AppDialogs.showToast(
                  message: AppStrings.INVALID_PHONE_NUMBER_MESSAGE);
            } else {
              //cancelProgressBar();
              AppDialogs.showToast(message: authException.message);
            }
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            log("Verification Id:${verificationId}");
            //cancelProgressBar();

            AppNavigation.navigateTo(
                context, AppRouteName.VERIFICATION_SCREEN_ROUTE,
                arguments: OtpArguments(
                    otpType: OtpType.phone_login.name,
                    phoneNo: phoneNumber,
                    phoneCode: phoneCode,
                    countryCode: countryCode,
                    phoneVerificationId: verificationId));

            // AppNavigation.navigateTo(
            //     context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
            //     arguments: OtpArguments(
            //         otpType: AppStrings.PHONE_OTP_TYPE,
            //         countryCode: countryCode,
            //         phoneNo: phoneNumber,
            //         phoneVerificationId: verificationId));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log("Timeout Verification id:${verificationId.toString()}");
          });
    } catch (error) {
      log("error");
      //cancelProgressBar();
      AppDialogs.showToast(message: error.toString());
    }
  }

  //
  Future<void> verifyPhoneCode(
      {required BuildContext context,
      String? phoneCode,
      String? countryCode,
      String? phoneNumber,
      required String verificationId,
      required String verificationCode}) async {
    try {
      //print("Verify Phone Code Starts");

      AuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      _userCredential = await _firebaseAuth.signInWithCredential(_credential);

      _user = _userCredential?.user;

      if (_user != null) {
        await _firebaseUserSignOut();

        // API Call Here
        _socialLoginMethod(
          context: context,
          socialToken: _user?.uid,
          socialType: SocialType.phone.name,
          phoneNumber: phoneNumber,
          phoneCode: phoneCode,
          countryCode: countryCode,
        );
      }
    } catch (error) {
      AppDialogs.showToast(message: error.toString());
    }
  }

  //
  //
  //
  Future<void> resendPhoneCode(
      {required BuildContext context,
      required String phoneCode,
      required String phoneNumber,
      required ValueChanged<String?> getVerificationId,
      required VoidCallback setProgressBar}) async {
    //setProgressBar();
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneCode + phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            //cancelProgressBar();
            AppDialogs.showToast(message: authException.message);
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            //cancelProgressBar();
            getVerificationId(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log(verificationId.toString());
          });
    } catch (error) {
      //cancelProgressBar();
      AppDialogs.showToast(message: error.toString());
    }
  }

  ///-------------------- Sign Out -------------------- ///
  Future<void> _firebaseUserSignOut() async {
    await _firebaseAuth.signOut();
  }

  void _socialLoginMethod(
      {required BuildContext context,
      String? socialToken,
      String? socialType,
      String? firstName,
      String? lastName,
      String? phoneNumber,
      String? phoneCode,
      String? countryCode}) {
    print("Social token:${socialToken}");
    print("Social type:${socialType}");
    print("First Name:${firstName}");
    print("Last Name:${lastName}");
    print("Phone No:${phoneNumber}");
    print("Phone Code:${phoneCode}");
    print("Country Code:${countryCode}");

    _socialLoginBloc.socialLoginBlocMethod(
        context: context,
        socialToken: socialToken,
        socialType: socialType,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        phoneCode: phoneCode,
        countryCode: countryCode,
        setProgressBar: () {
          AppDialogs.circularProgressDialog(context: context);
        });
  }
}

import 'package:locks_hybrid/utils/constants.dart';
import 'package:locks_hybrid/utils/regular_expressions.dart';

import 'app_strings.dart';

extension FieldValidator on String {
  //-------------- Email Validator -------------------
  get validateEmail {
    if (!RegularExpressions.EMAIL_VALID_REGIX.hasMatch(this) && isNotEmpty) {
      return AppStrings.EMAIL_INVALID_ERROR;
    } else if (isEmpty) {
      return AppStrings.EMAIL_EMPTY_ERROR;
    }
    return null;
  }

  //---------------- Password Validator -----------------
  validatePassword({bool? isPatternCheck = true}) {
    if (isEmpty) {
      return AppStrings.PASSWORD_EMPTY_ERROR;
    }
    if (isPatternCheck!) {
      if (!RegularExpressions.PASSWORD_VALID_REGIX.hasMatch(this) &&
          isNotEmpty) {
        return AppStrings.PASSWORD_INVALID_ERROR;
      }
    }
    if (!isPatternCheck) {
      if (this.length < 8 && isNotEmpty) {
        return AppStrings.PASSWORD_INVALID_LENGTH_ERROR;
      }
    }
    return null;
  }

  //--------------------- old password -----------------
  get validateOldPassword {
    if (isEmpty) {
      return AppStrings.OLD_PASSWORD_EMPTY_ERROR;
    } /*else if (this.length < 8) {
      return AppStrings.PASSWORD_INVALID_LENGTH_ERROR;
    }*/
    else if (!RegularExpressions.PASSWORD_VALID_REGIX.hasMatch(this) &&
        isNotEmpty) {
      return AppStrings.PASSWORD_INVALID_LENGTH_ERROR;
    }
    return null;
  }

  //---------------- Empty Validator -----------------
  validateEmpty(String message) {
    if (isEmpty) {
      return '$message field can\'t be empty.';
    } else {
      return null;
    }
  }


  validatePhoneNumber() {
    if (this.isEmpty) {
      return AppStrings.PHONE_NO_EMPTY_ERROR;
    } else if(Constants.MASK_TEXT_FORMATTER_PHONE_NO.unmaskText(this).length != 10){
      return AppStrings.PHONE_NO_INVALID_LENGTH;
    }
    else {
      return null;
    }
  }


  //---------------- Phone Number Validator ----------
  // get validatePhoneNumber {
  //   print("Number : " + this);
  //   if (isEmpty) {
  //     return AppStrings.PHONE_NO_EMPTY_ERROR;
  //   }
  //   // if (length < 10) {
  //   //   return AppStrings.PHONE_NO_INVALID_LENGTH;
  //   // }
  //   else {
  //     return null;
  //   }
  // }

//--------------Confirm Password Validator--------//
  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return AppStrings.CONFIRM_PASSWORD_EMPTY_ERROR;
    } else if (!(password == confirmPassword)) {
      return AppStrings.PASSWORD_DIFFERENT_ERROR;
    } else {
      return null;
    }
  }

  get validateNewPassword {
    if (isEmpty) {
      return AppStrings.PASSWORD_EMPTY_ERROR;
    } /*else if (this.length < 8) {
      return AppStrings.PASSWORD_INVALID_LENGTH_ERROR;
    }*/
    else if (!RegularExpressions.PASSWORD_VALID_REGIX.hasMatch(this) &&
        isNotEmpty) {
      return AppStrings.PASSWORD_INVALID_ERROR;
    }
    return null;
  }

  String? validateChangeNewPassword(String oldPassword, String newPassword) {
    if (newPassword.isEmpty) {
      return AppStrings.NEW_PASSWORD_EMPTY_ERROR;
    } /*else if (newPassword.length < 8) {
      return AppStrings.PASSWORD_INVALID_LENGTH_ERROR;
    } */
    else if (!RegularExpressions.PASSWORD_VALID_REGIX.hasMatch(newPassword) &&
        isNotEmpty) {
      return AppStrings.PASSWORD_INVALID_ERROR;
    } else if (oldPassword == newPassword) {
      return AppStrings.PASSWORD_SAME_ERROR;
    } else {
      return null;
    }
  }

  //--------------New Confirm Password Validator--------//
  String? validateNewConfirmPassword(
      String newPassword, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return AppStrings.CONFIRM_PASSWORD_EMPTY_ERROR;
    } else if (!(newPassword == confirmPassword)) {
      return AppStrings.PASSWORD_DIFFERENT_ERROR;
    } else {
      return null;
    }
  }

  //--------------New Confirm Password Validator--------//
  String? validateChangeNewConfirmPassword(
      String newPassword, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return AppStrings.CONFIRM_NEW_PASSWORD_EMPTY_ERROR;
    } else if (!(newPassword == confirmPassword)) {
      return AppStrings.CONFIRM_NEW_PASSWORD_DIFFERENT_ERROR;
    } else {
      return null;
    }
  }

//---------------- OTP Validator ---------------
  String? validateOtp(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

//   String? validateEmpty(String value) {
//     if (value == '') {
//       return "Field can't be empty";
//     }
//     return null;
//   }

// get validateNewPassword {
//   if (isEmpty) {
//     return "New password field can't be empty";
//   } else if (!RegularExpressions.PASSWORD_VALID_REGIX.hasMatch(this) && isNotEmpty) {
//     return 'New ${AppStrings.PASSWORD_INVALID_ERROR_TEXT}';
//   }
//   return null;
// }

}

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegularExpressions {
  RegularExpressions._();
  static RegExp PASSWORD_VALID_REGIX = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp EMAIL_VALID_REGIX = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static MaskTextInputFormatter MASK_TEXT_FORMATTER_PHONE_NO = MaskTextInputFormatter(
    mask: '+1(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
}
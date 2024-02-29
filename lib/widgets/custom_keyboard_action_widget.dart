import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:locks_hybrid/utils/app_colors.dart';

class CustomKeyboardActionWidget extends StatelessWidget {
  final Widget child;
  final FocusNode focusNode;
  CustomKeyboardActionWidget({required this.child,required this.focusNode});
  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
        config: _buildConfig(context),
        disableScroll: true,
        child: child
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: AppColors.THEME_COLOR_WHITE,
      actions: [
        KeyboardActionsItem(
            focusNode: focusNode,
            displayArrows: false
        ),

      ],
    );
  }
}

import 'package:flutter/material.dart';

///焦点获取页面
class UnFocusWrapper extends StatelessWidget {
  final Widget child;
  const UnFocusWrapper(this.child, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (e) {
        final scope = FocusScope.of(context);
        if (scope.hasFocus) {
          scope.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

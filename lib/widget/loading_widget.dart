import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'circle_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.stop,
    this.progress = 0,
  }) : super(key: key);
  final bool stop;
  final double progress;
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: ScreenUtil().screenWidth,
        child: CircleIndicator(
          stop: stop,
          radius: 18,
          childRadius: 5,
          progress: progress,
          duration: const Duration(seconds: 1),
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade200,
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade500,
            Colors.grey.shade600,
            Colors.grey.shade700,
            Colors.grey.shade800,
            Colors.grey.shade900,
          ],
        ),
      ),
    );
  }
}

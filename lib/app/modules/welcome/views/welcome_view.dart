import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../index.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFF584F),
      child: Stack(
        children: [
          Center(
            child: _buildImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Icon(
      Icons.settings_applications_outlined,
      size: 48.w,
      color: Colors.white54,
    );
  }
}

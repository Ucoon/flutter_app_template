import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../index.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'home'.tr,
      ),
    );
  }
}

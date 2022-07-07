import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../index.dart';

class GlobalPurchasingPage extends GetView<GlobalPurchasingController> {
  const GlobalPurchasingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'global'.tr,
      ),
    );
  }
}

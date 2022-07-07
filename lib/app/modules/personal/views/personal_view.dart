import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../index.dart';

class PersonalPage extends GetView<PersonalController> {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'personal'.tr,
      ),
    );
  }
}

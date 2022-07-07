import 'package:flutter/material.dart';
import 'package:get/get.dart';

showEmptyDialog(){
  Get.dialog(
        Container(
          color: Colors.transparent,
        ),
        barrierColor: Colors.transparent);
}
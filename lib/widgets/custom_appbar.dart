import 'package:bluetooth/constants/assets.dart';
import 'package:bluetooth/constants/colors.dart';
import 'package:bluetooth/controllers/switch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBarWithSwitch extends StatelessWidget {
  final BluetoothController switchController = Get.put(BluetoothController());

  CustomAppBarWithSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(ImageAssets.drawerIcon, width: 16.w, height: 16.h),
        const Spacer(),

        Image.asset(ImageAssets.diamondIcon, width: 64.w, height: 56.h),
      ],
    );
  }
}

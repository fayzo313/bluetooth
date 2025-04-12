import 'package:bluetooth/constants/assets.dart';
import 'package:bluetooth/constants/colors.dart';
import 'package:bluetooth/constants/styles.dart';
import 'package:bluetooth/controllers/switch_controller.dart';
import 'package:bluetooth/widgets/custom_appbar.dart';
import 'package:bluetooth/widgets/custom_device_buttton.dart';
import 'package:bluetooth/widgets/custom_menu_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final SwitchController switchController = Get.put(SwitchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 51.h, horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBarWithSwitch(),

            Row(
              children: [
                Text(
                  'BLuetooth',
                  style: TextStyles.headingA.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                Spacer(),
                Obx(
                  () => Switch(
                    value: switchController.isSwitched.value,
                    onChanged: (value) {
                      switchController.toggleSwitch(value);
                    },
                    activeColor: AppColors.whiteColor,
                    activeTrackColor: AppColors.primaryColor,
                    // inactiveThumbColor: Colors.grey,
                    // inactiveTrackColor: Colors.black12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              width: double.infinity,
              height: 128.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Device",
                    style: TextStyles.headingB.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: DeviceButton(
                          text: 'Add Device',
                          icon: Icons.bluetooth,
                          isFilled: true,
                          onPressed: () {
                            print('Add Device pressed');
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DeviceButton(
                          text: 'Find Device',
                          icon: Icons.search,
                          isFilled: false,
                          onPressed: () {
                            print('Find Device pressed');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MenuItemRow(
              title: 'App Theme',
              iconPath: ImageAssets.contrastIcon,
              onTap: () {
                print('App Theme tapped');
              },
            ),
            const Divider(height: 1),
            MenuItemRow(
              title: 'Signal Strength',
              iconPath: ImageAssets.signalIcon,
              onTap: () {
                print('Signal Strength tapped');
              },
            ),
            const Divider(height: 1),
            MenuItemRow(
              title: 'History',
              iconPath: ImageAssets.historyIcon,
              onTap: () {
                print('History tapped');
              },
            ),
            SizedBox(height: 20.h),

            Text(
              'Recent Devices',
              style: TextStyles.headingA.copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }
}

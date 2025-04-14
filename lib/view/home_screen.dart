import 'package:bluetooth/constants/assets.dart';
import 'package:bluetooth/constants/colors.dart';
import 'package:bluetooth/constants/styles.dart';
import 'package:bluetooth/controllers/switch_controller.dart';
import 'package:bluetooth/widgets/custom_appbar.dart';
import 'package:bluetooth/widgets/custom_device_buttton.dart';
import 'package:bluetooth/widgets/custom_menu_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BluetoothController switchController = Get.put(BluetoothController());

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
            MenuItemRow(
              title: 'Signal Strength',
              iconPath: ImageAssets.signalIcon,
              onTap: () {
                print('Signal Strength tapped');
              },
            ),
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
            Obx(
              () =>
                  switchController.isScanning.value
                      ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Scanning for devices...'),
                          ],
                        ),
                      )
                      : SizedBox.shrink(),
            ),
            // Devices list
            Obx(
              () =>
                  switchController.isSwitched.value
                      ? Expanded(
                        child:
                            switchController.scanResults.isEmpty &&
                                    !switchController.isScanning.value
                                ? Center(child: Text('No devices found'))
                                : ListView.builder(
                                  itemCount:
                                      switchController.scanResults.length,
                                  itemBuilder: (context, index) {
                                    ScanResult result =
                                        switchController.scanResults[index];
                                    BluetoothDevice device = result.device;

                                    // Get device name using our improved function
                                    String deviceName = getDeviceName(result);

                                    return ListTile(
                                      leading: const Icon(Icons.bluetooth),
                                      title: Text(deviceName),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ID: ${device.remoteId.str}'),
                                          Text('RSSI: ${result.rssi} dBm'),
                                          // Debugging information
                                          Text(
                                            'Device Name (raw): ${result.device.name ?? "null"}',
                                          ),
                                          Text(
                                            'Local Name: ${result.advertisementData.localName.isEmpty ? "null" : result.advertisementData.localName}',
                                          ),
                                          if (result
                                              .advertisementData
                                              .manufacturerData
                                              .isNotEmpty)
                                            const Text(
                                              'Has Manufacturer Data: Yes',
                                            ),
                                          if (result
                                              .advertisementData
                                              .serviceData
                                              .isNotEmpty)
                                            const Text('Has Service Data: Yes'),
                                        ],
                                      ),
                                      trailing: Text(
                                        '${result.advertisementData.connectable ? 'Connectable' : 'Not Connectable'}',
                                      ),
                                      onTap: () {
                                        // Handle device selection
                                        Get.snackbar(
                                          'Device Selected',
                                          'Selected $deviceName',
                                        );
                                        // Here you would typically connect to the device
                                      },
                                    );
                                  },
                                ),
                      )
                      : Expanded(
                        child: Center(
                          child: Text(
                            'Turn on Bluetooth scanning to see devices',
                            style: TextStyles.headingC.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  String getDeviceName(ScanResult result) {
    // Try to get the platform name (preferred name on the platform)
    String? deviceName = result.device.platformName;

    // If platform name is null or empty, try the advertised name (localName)
    if (deviceName == null || deviceName.isEmpty) {
      deviceName = result.advertisementData.localName;
    }

    // If still empty, provide a fallback using the device ID
    if (deviceName == null || deviceName.isEmpty) {
      deviceName =
          'Unknown Device (${result.device.remoteId.str.substring(0, 8)})'; // Fallback with part of the device ID
    }

    return deviceName;
  }
}

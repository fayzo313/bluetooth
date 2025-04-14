import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  RxBool isSwitched = false.obs;
  RxList<ScanResult> scanResults = <ScanResult>[].obs;
  RxBool isScanning = false.obs;
  StreamSubscription<List<ScanResult>>? scanSubscription;

  @override
  void onInit() {
    super.onInit();
    requestPermissions();

    // Listen to scanning state changes
    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning.value = scanning;
    });
  }

  Future<void> requestPermissions() async {
    // Request permissions based on platform
    if (GetPlatform.isAndroid) {
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    } else if (GetPlatform.isIOS) {
      await Permission.bluetooth.request();
    }
  }

  void toggleSwitch(bool value) async {
    isSwitched.value = value;

    if (value) {
      await startScan();
    } else {
      stopScan();
    }
  }

  Future<void> startScan() async {
    // Clear previous results
    scanResults.clear();

    try {
      // Check if Bluetooth is on
      if (await FlutterBluePlus.adapterState.first ==
          BluetoothAdapterState.on) {
        // Start scanning
        await FlutterBluePlus.startScan(
          timeout: Duration(seconds: 15),
          androidScanMode: AndroidScanMode.lowLatency,
        );

        // Listen for scan results
        scanSubscription = FlutterBluePlus.scanResults.listen(
          (results) {
            scanResults.value = results;
          },
          onError: (error) {
            Get.snackbar('Error', 'Scan error: $error');
            isScanning.value = false;
          },
        );
      } else {
        // Request to turn on Bluetooth
        Get.snackbar('Bluetooth Off', 'Please turn on Bluetooth');
        if (GetPlatform.isAndroid) {
          await FlutterBluePlus.turnOn();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start scan: $e');
      isScanning.value = false;
    }
  }

  void stopScan() {
    try {
      FlutterBluePlus.stopScan();
      scanSubscription?.cancel();
      scanSubscription = null;
    } catch (e) {
      print('Error stopping scan: $e');
    }
  }

  @override
  void onClose() {
    stopScan();
    scanSubscription?.cancel();
    super.onClose();
  }
}

// import 'package:get/get.dart';

// class SwitchController extends GetxController {
//   RxBool isSwitched = false.obs;

//   void toggleSwitch(bool value) {
//     isSwitched.value = value;
//     print('Switch toggled: $value');
//   }
// }

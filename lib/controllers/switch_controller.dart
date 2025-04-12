import 'package:get/get.dart';

class SwitchController extends GetxController {
  RxBool isSwitched = false.obs;

  void toggleSwitch(bool value) {
    isSwitched.value = value;
    print('Switch toggled: $value');
  }
}

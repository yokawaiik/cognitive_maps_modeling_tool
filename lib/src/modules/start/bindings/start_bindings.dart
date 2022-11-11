import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/start/controllers/start_controller.dart';

class StartBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      StartController(),
    );
  }
}

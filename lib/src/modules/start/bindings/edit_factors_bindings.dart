import 'package:get/get.dart';

import '../controllers/edit_factors_controller.dart';

class EditFactorsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      EditFactorsController(),
    );
  }
}

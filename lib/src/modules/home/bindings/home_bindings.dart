import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/analysis_controller.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/home_controller.dart';

import '../controllers/cognitive_map_editor_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      CognitiveMapEditorController(),
      // permanent: true,
    );
    Get.put(
      AnalysisController(),
      // permanent: true,
    );

    Get.put(
      HomeController(),
      // permanent: true,
    );
  }
}

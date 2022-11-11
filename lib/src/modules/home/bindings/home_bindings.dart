import 'package:get/get.dart';

import '../controllers/cognitive_map_editor_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      CognitiveMapEditorController(),
      permanent: true,
    );
  }
}

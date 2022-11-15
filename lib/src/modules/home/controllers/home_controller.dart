import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/analysis_controller.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/cognitive_map_editor_controller.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final CMEC = Get.find<CognitiveMapEditorController>();
  final AC = Get.find<AnalysisController>();

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    super.onInit();
  }

  void onTap(int value) {
    // print('onTap - value : $value');
    if (!CMEC.isGridValid()) {
      Get.snackbar(
        "Error",
        "Analysis requires correct fill in the factor grid.",
      );
      return;
    }

    if (value == 1) {
      AC.matrixWUpdate();
    }
    tabController.animateTo(value);
  }

  void saveToFile() {
    CMEC.saveToFile();
  }

  Future<bool> closeMapEditor() async {
    bool result = false;
    await Get.dialog(AlertDialog(
      title: const Text('Do you want to close map editor?'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    result = false;
                    Get.back(closeOverlays: true);
                  },
                  child: Text(
                    'No',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    result = true;
                    Get.back(closeOverlays: true);
                  },
                  child: Text(
                    'Yes',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));

    return result;
  }
}

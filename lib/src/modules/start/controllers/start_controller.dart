import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/pages/home_page.dart';
import 'package:mdmwcm_app/src/modules/start/pages/edit_factors_page.dart';

class StartController extends GetxController {
  void setFactors() async {
    await Get.toNamed(EditFactorsPage.routeName);
  }

  // todo: loadFile
  void loadFile() {}

  void _goToHome() async {
    await Get.offAndToNamed(HomePage.routeName);
  }
}

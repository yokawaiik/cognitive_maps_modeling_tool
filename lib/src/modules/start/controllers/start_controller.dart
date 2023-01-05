import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/models/file_map_model.dart';
import 'package:mdmwcm_app/src/models/home_page_arguments.dart';
import 'package:mdmwcm_app/src/modules/home/pages/home_page.dart';
import 'package:mdmwcm_app/src/modules/start/pages/edit_factors_page.dart';

class StartController extends GetxController {
  void setFactors() async {
    await Get.toNamed(EditFactorsPage.routeName);
  }

  void loadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        Uint8List fileBytes;

        if (GetPlatform.isWindows) {
          final loadedFile = File(result.files.first.path!);

          fileBytes = await loadedFile.readAsBytes();
        } else {
          fileBytes = result.files.first.bytes!;
        }

        final fileMap = FileMapModel.fromUint8List(fileBytes);

        await Get.toNamed(
          HomePage.routeName,
          arguments: HomePageArguments(
            fileMapModel: fileMap,
            isNew: false,
          ),
        );
      } else {
        // User canceled the picker

        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('StartController - loadFile - e : $e');
      }

      if (e.toString().contains('Incorrect file structure.')) {
        Get.snackbar('Error', 'Incorrect file structure.');
      } else {
        Get.snackbar('Error', 'Something went wrong.');
      }
    }
  }
}

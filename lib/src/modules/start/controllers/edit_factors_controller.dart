import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/models/file_map_model.dart';
import 'package:mdmwcm_app/src/models/home_page_arguments.dart';
import 'package:mdmwcm_app/src/modules/home/pages/home_page.dart';
import '../../../models/item_entry.dart';
import 'package:collection/collection.dart';

class EditFactorsController extends GetxController {
  var factorsCount = RxInt(2);

  var textFieldControllers = RxList<TextEditingController>([]);

  late GlobalKey<FormState> factorsFormKey;

  var isTextFieldsValid = RxBool(false);

  late final TextEditingController mapNameTFC;

  @override
  void onInit() {
    factorsFormKey = GlobalKey<FormState>();
    mapNameTFC = TextEditingController();

    _setTextFieldsForFactors();

    super.onInit();
  }

  void pickFactorsCount() async {
    await showMaterialNumberPicker(
      context: Get.context!,
      title: 'Pick factor counts',
      maxNumber: 50,
      minNumber: 2,
      selectedNumber: factorsCount.value,
      onChanged: (value) => factorsCount.value = value,
    );
    _setTextFieldsForFactors();
  }

  void _setTextFieldsForFactors() {
    if (factorsCount.value > textFieldControllers.length) {
      for (var i = textFieldControllers.length; i < factorsCount.value; i++) {
        textFieldControllers.add(
          TextEditingController(),
        );
      }
    } else {
      print(
          'remove since ${factorsCount.value} to ${textFieldControllers.length}');
      textFieldControllers.removeRange(
        factorsCount.value,
        textFieldControllers.length,
      );
    }
    textFieldControllers.refresh();
  }

  void addTextFieldController() {
    factorsCount.value++;
    textFieldControllers.add(
      TextEditingController(),
    );
    textFieldControllers.refresh();
  }

  void removeLastTextFieldController() {
    if (factorsCount.value < 3) {
      return;
    }
    factorsCount.value--;
    textFieldControllers.removeLast();
    textFieldControllers.refresh();
  }

  void setFactors() {
    factorsFormKey.currentState?.save();
    if (!factorsFormKey.currentState!.validate()) {
      Get.snackbar(
        'Check filled data',
        "To continue you need to correct input data.",
      );
    }

    List<ItemEntry> factors = [];

    textFieldControllers
        .map((element) => element.text)
        .toList()
        .forEachIndexed((index, value) {
      if (factors.map((value) => value.title).toList().contains(value)) {
        factors.firstWhere((item) => item.title == value).positions.add(index);
      } else {
        factors.add(ItemEntry(value)..positions.add(index));
      }
    });

    // check if there are duplicates in fields
    if (factors.any((element) => element.positions.length > 1)) {
      final duplicatesSubString = factors
          .where((item) => item.positions.length > 1)
          .map((item) =>
              '${item.title} is duplicated in fields with indices - ${item.positions.toList().join(", ")}')
          .join('; ');

      final message = """
Factors can't be duplicated. 
\nDuplicate Factors: $duplicatesSubString.

""";

      print(message);

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.bottom,
      );

      return;
    }

    var handledFactors =
        textFieldControllers.map((element) => element.text).toList();

    final homePageArguments = HomePageArguments(
      fileMapModel: FileMapModel.onlyEditor(
        name: mapNameTFC.text,
        factorList: handledFactors,
        matrixW: <List<double>>[],
      ),
    );

    Get.offAndToNamed(
      HomePage.routeName,
      arguments: homePageArguments,
    );
  }

  void simpleCheckFactorsForm() {
    factorsFormKey.currentState?.save();

    if (factorsFormKey.currentState!.validate()) {
      isTextFieldsValid.value = true;
    } else {
      isTextFieldsValid.value = false;
    }
  }
}

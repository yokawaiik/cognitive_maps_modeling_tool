import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/item_entry.dart';

import 'package:collection/collection.dart';

class EditFactorsController extends GetxController {
  var textFieldControllers = RxList<TextEditingController>([]);

  late final GlobalKey<FormState> factorsFormKey;

  var isTextFieldsValid = RxBool(false);

  @override
  void onInit() {
    factorsFormKey = GlobalKey<FormState>();

    super.onInit();
  }

  void addTextFieldController() {
    textFieldControllers.add(
      TextEditingController(),
    );
    textFieldControllers.refresh();

    // print('addTextFieldController - ${textFieldControllers.length}');
  }

  void setFactors() {
    factorsFormKey.currentState?.save();
    if (factorsFormKey.currentState!.validate()) {
      Get.snackbar(
        'Check filled data',
        "To continue you need to correct input data.",
      );
    }

    List<ItemEntry> factors = [];

    // todo: error
    print(textFieldControllers.map((element) => element.text).toList());

    // textFieldControllers
    //     .map((element) => element.text)
    //     .toList()
    //     .forEachIndexed((index, value) {
    //   if (factors.map((value) => value.title).toList().contains(value)) {
    //     factors.firstWhere((item) => item.title == value).positions.add(index);
    //   } else {
    //     factors.add(ItemEntry(value));
    //   }
    // });

    // factors.forEachIndexed(
    //     (index, item) => {print('${item.title}, ${item.positions}')});
  }

  void simpleCheckFactorsForm() {
    factorsFormKey.currentState?.save();

    if (factorsFormKey.currentState!.validate()) {
      isTextFieldsValid.value = true;
    } else {
      isTextFieldsValid.value = false;
    }
    print(
        'simpleCheckFactorsForm - isTextFieldsValid.value : ${isTextFieldsValid.value}');
  }
}

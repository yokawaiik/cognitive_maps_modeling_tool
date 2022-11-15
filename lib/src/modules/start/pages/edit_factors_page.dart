import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/start/controllers/edit_factors_controller.dart';

class EditFactorsPage extends GetView<EditFactorsController> {
  static const routeName = '/edit-factors';
  EditFactorsPage({super.key});

  Widget _buildTextField(
    TextEditingController controller,
    int numberTextField,
  ) {
    return Container(
      key: Key('$numberTextField'),
      margin: const EdgeInsets.all(5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Factor $numberTextField',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "This field is required.";
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit factors'),
      ),
      body: Form(
        key: controller.factorsFormKey,
        onChanged: controller.simpleCheckFactorsForm,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.addTextFieldController,
                      icon: const Icon(Icons.add_box),
                      label: const Text('Add a new factor'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.factorsCount.value == 2
                            ? null
                            : controller.removeLastTextFieldController,
                        icon: const Icon(Icons.remove_circle),
                        label: const Text('Remove last factor'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: controller.pickFactorsCount,
                      icon: const Icon(Icons.format_list_numbered),
                      label: Text(
                        "Set factors count",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: controller.mapNameTFC,
                  decoration: InputDecoration(
                    labelText: 'Map name',
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "This field is required.";
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.textFieldControllers.length,
                    itemBuilder: (context, index) {
                      return _buildTextField(
                        controller.textFieldControllers[index],
                        index,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Obx(
                      () => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primaryContainer,
                          foregroundColor: cs.onPrimaryContainer,
                        ),
                        onPressed: controller.isTextFieldsValid.value
                            ? controller.setFactors
                            : null,
                        icon: const Icon(Icons.input),
                        label: const Text('Set factors'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

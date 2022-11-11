import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/start/controllers/edit_factors_controller.dart';

class EditFactorsPage extends GetView<EditFactorsController> {
  static const routeName = '/edit-factors';
  const EditFactorsPage({super.key});

  Widget _buildTextField(
    TextEditingController controller,
    int numberTextField,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      // child: TextField(
      //   decoration: InputDecoration(
      //     labelText: 'Factor $numberTextField',
      //   ),
      //   controller: controller,
      // ),
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
      body: Column(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.factorsFormKey,
              onChanged: controller.simpleCheckFactorsForm,
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
    );
  }
}

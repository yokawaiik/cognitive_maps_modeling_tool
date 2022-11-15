import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../controllers/cognitive_map_editor_controller.dart';

class TabMapEditor extends GetView<CognitiveMapEditorController> {
  TabMapEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PlutoGrid(
      key: UniqueKey(),
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          gridBorderColor: Colors.transparent,
          gridBackgroundColor: Colors.transparent,
          activatedBorderColor: colorScheme.primary,
          activatedColor: colorScheme.primaryContainer,
        ),
      ),
      columns: controller.columns,
      rows: controller.rows,
      onChanged: controller.plutoGridOnChanged,
      onLoaded: controller.plutoGridOnLoaded,
      createHeader: (stateManager) => _Header(),
    );
  }
}

class _Header extends GetView<CognitiveMapEditorController> {
  _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: controller.showAddFactorDialog,
              icon: Icon(Icons.table_rows),
              label: const Text('Add a new factor'),
            ),
            ElevatedButton.icon(
              onPressed: controller.handleSaveAll,
              icon: Icon(Icons.save),
              label: const Text('Save all'),
            ),
            ElevatedButton.icon(
              onPressed: controller.removeLastFactor,
              icon: Icon(Icons.remove_circle),
              label: const Text('Remove last factor'),
            ),
            ElevatedButton.icon(
              onPressed: controller.handleRemoveCurrentFactor,
              icon: Icon(Icons.code_rounded),
              label: const Text('Remove selected factor'),
            ),
            // ElevatedButton.icon(
            //   onPressed: controller.handleRemoveCurrentColumnButton,
            //   icon: Icon(Icons.view_column_outlined),
            //   label: const Text('Remove Current Column'),
            // ),
            // ElevatedButton.icon(
            //   onPressed: controller.handleRemoveCurrentRowButton,
            //   icon: Icon(Icons.table_rows_outlined),
            //   label: const Text('Remove Current Row'),
            // ),
            // ElevatedButton.icon(
            //   onPressed: controller.handleRemoveSelectedRowsButton,
            //   icon: Icon(Icons.remove_circle),
            //   label: const Text('Remove Selected Rows'),
            // ),
          ],
        ),
      ),
    );
  }
}

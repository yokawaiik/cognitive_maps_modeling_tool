import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/pluto_row_list_to_list.dart';

import 'package:uuid/uuid.dart';

class CognitiveMapEditorController extends GetxController {
  PlutoGridStateManager? stateManager;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  final columns = RxList<PlutoColumn>([]);

  final rows = RxList<PlutoRow>([]);

  @override
  void onInit() {
    super.onInit();

    columns.addAll([
      PlutoColumn(
        title: 'Factor',
        field: 'sytem_column_title',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableEditingMode: true,
        enableSorting: false,
        enableColumnDrag: false,
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'column1',
        field: 'column1',
        type: PlutoColumnType.number(format: '#.###'),
        enableEditingMode: true,
        enableSorting: false,
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'column2',
        field: 'column2',
        type: PlutoColumnType.number(format: '#.###'),
        enableEditingMode: true,
        enableSorting: false,
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'column3',
        field: 'column3',
        type: PlutoColumnType.number(format: '#.###'),
        enableEditingMode: true,
        enableSorting: false,
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'column4',
        field: 'column4',
        type: PlutoColumnType.number(format: '#.###'),
        enableEditingMode: true,
        enableSorting: false,
        enableFilterMenuItem: false,
      ),
    ]);

    rows.addAll(
      [
        PlutoRow(
          cells: {
            'sytem_column_title': PlutoCell(value: "row1"),
            'column1': PlutoCell(value: 0),
            'column2': PlutoCell(value: 2),
            'column3': PlutoCell(value: 0),
            'column4': PlutoCell(value: 1),
          },
        ),
        PlutoRow(
          cells: {
            'sytem_column_title': PlutoCell(value: "row2"),
            'column1': PlutoCell(value: -2),
            'column2': PlutoCell(value: 0),
            'column3': PlutoCell(value: 12),
            'column4': PlutoCell(value: 7),
          },
        ),
        PlutoRow(
          cells: {
            'sytem_column_title': PlutoCell(value: "row3"),
            'column1': PlutoCell(value: 0),
            'column2': PlutoCell(value: -1),
            'column3': PlutoCell(value: 0),
            'column4': PlutoCell(value: -3),
          },
        ),
        PlutoRow(
          cells: {
            'sytem_column_title': PlutoCell(value: "row4"),
            'column1': PlutoCell(value: 2),
            'column2': PlutoCell(value: 1.1),
            'column3': PlutoCell(value: 2),
            'column4': PlutoCell(value: 0),
          },
        ),
      ],
    );

    stateManager = PlutoGridStateManager(
      columns: columns,
      gridFocusNode: FocusNode(),
      rows: rows,
      scroll: PlutoGridScrollController(),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      stateManager?.setSelectingMode(gridSelectingMode);
    });
  }

  void plutoGridOnLoaded(PlutoGridOnLoadedEvent event) {
    stateManager = event.stateManager;
  }

  void plutoGridOnChanged(PlutoGridOnChangedEvent event) {
    print(event);

    stateManager?.notifyListeners();
  }

  // todo: setFactors
  void setFactors() {}

// todo: handlerInputMatrix
  void handlerInputMatrix() {}

  // todo: saveToFile
  void saveToFile() {
    print("__saveToFile__");
    final values = plutoRowListToList(stateManager!.refRows);
    print(values);
    print("__saveToFile__");
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    gridSelectingMode = mode;
    stateManager?.setSelectingMode(mode);
  }

  int addCount = 1;

  void handlerAddRows(String title) {
    final newRows = stateManager!.getNewRows(count: addCount);

    // !!!!f
    newRows.first.cells.values.first.value = title;

    stateManager!.appendRows(newRows);

    stateManager?.setCurrentCell(
      newRows.first.cells.entries.first.value,
      stateManager!.refRows.length - 1,
    );

    stateManager!.moveScrollByRow(
      PlutoMoveDirection.down,
      stateManager!.refRows.length - 2,
    );

    stateManager!.setKeepFocus(true);
  }

  void handlerAddColumns(String title) {
    final List<PlutoColumn> newColumns = [];
    final newColumnId = const Uuid().v4();

    final newColumn = PlutoColumn(
      title: title,
      field: newColumnId,
      type: PlutoColumnType.number(),
      enableSorting: false,
      enableFilterMenuItem: false,
      enableEditingMode: true,
    );

    newColumns.add(newColumn);

    stateManager!.insertColumns(
      stateManager!.bodyColumns.length,
      newColumns,
    );
  }

  void showAddFactorDialog() {
    Get.dialog(AlertDialog(
      title: Text('Add a new factor'),
      content: SizedBox(
        // height: 150,
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextField(
              onChanged: (value) {},
              controller: textFieldAddFactorController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: handlerCloseAddColumnAndRow,
                  child: Text(
                    'Close',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: handlerAddColumnAndRow,
                  child: Text(
                    'Add a new Factor',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  TextEditingController textFieldAddFactorController = TextEditingController();
  void handlerAddColumnAndRow() {
    if (textFieldAddFactorController.text.isEmpty ||
        textFieldAddFactorController.text == '') {
      Get.back(closeOverlays: true);
      Get.snackbar(
        "Warning",
        "This field requires fill in its.",
      );
    }

    final title = textFieldAddFactorController.text;
    addColumnAndRow(title);
    Get.back(closeOverlays: true);
  }

  void addColumnAndRow(String title) {
    handlerAddColumns(title);
    handlerAddRows(title);
  }

  void handlerCloseAddColumnAndRow() {
    Get.back(closeOverlays: true);
  }

  void handleSaveAll() {
    saveToFile();

    // widget.stateManager.setShowLoading(true);

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   for (var row in widget.stateManager.refRows) {
    //     if (row.cells['status']!.value != 'saved') {
    //       row.cells['status']!.value = 'saved';
    //     }

    //     if (row.cells['id']!.value == '') {
    //       row.cells['id']!.value = 'guest';
    //     }

    //     if (row.cells['name']!.value == '') {
    //       row.cells['name']!.value = 'anonymous';
    //     }
    //   }

    //   widget.stateManager.setShowLoading(false);
    // });
  }

  void handleRemoveCurrentColumnButton() {
    final currentColumn = stateManager!.currentColumn;

    if (currentColumn == null) {
      return;
    }

    stateManager!.removeColumns([currentColumn]);
  }

  void handleRemoveCurrentRowButton() {
    stateManager!.removeCurrentRow();
  }

  void handleRemoveSelectedRowsButton() {
    stateManager!.removeRows(stateManager!.currentSelectingRows);
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/models/file_map_model.dart';
import 'package:mdmwcm_app/src/models/home_page_arguments.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../utils/pluto_row_list_to_list.dart';
import 'package:uuid/uuid.dart';

class CognitiveMapEditorController extends GetxController {
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;
  final columns = RxList<PlutoColumn>([]);
  final rows = RxList<PlutoRow>([]);
  late Rx<FileMapModel> fileMapModel;
  int addCount = 1;
  TextEditingController textFieldAddFactorController = TextEditingController();

  @override
  void onInit() {
    final homePageArguments = Get.arguments as HomePageArguments?;

    if (homePageArguments == null) {
      Get.back();
    }

    // createCognitiveMap
    fileMapModel = Rx(homePageArguments!.fileMapModel);

    createCognitiveMap(
      isNew: homePageArguments.isNew,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      stateManager?.setSelectingMode(gridSelectingMode);
    });

    super.onInit();
  }

  void plutoGridOnLoaded(PlutoGridOnLoadedEvent event) {
    stateManager = event.stateManager;
  }

  void plutoGridOnChanged(PlutoGridOnChangedEvent event) {
    print(event);

    stateManager?.notifyListeners();
  }

  void saveToFile() async {
    try {
      print("__saveToFile__");
      final values = plutoRowListToList(stateManager!.rows);
      final factorsName = stateManager!.columns.map((e) => e.title).toList()
        ..removeAt(0);

      final fileMap = FileMapModel.onlyEditor(
        name: fileMapModel.value.name,
        factorList: factorsName,
        matrixW: values,
      );

      final fs = FileSaver.instance;

      if (GetPlatform.isAndroid) {
        await fs.saveAs(
          fileMap.name,
          fileMap.convertModelToUint8List(),
          'json',
          MimeType.JSON,
        );
      } else if (GetPlatform.isWindows) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Your File to desired location',
          fileName: '${fileMap.name}.json',
        );

        if (outputFile == null) {
          return;
        }

        File returnedFile = File('$outputFile');
        await returnedFile.writeAsBytes(fileMap.convertModelToUint8List());
      } else {
        await fs.saveFile(
          fileMap.name,
          fileMap.convertModelToUint8List(),
          'json',
          mimeType: MimeType.JSON,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('CognitiveMapEditorController - saveToFile - e : $e.');
      }
      Get.snackbar("Unexpectedly exception", "Something went wrong.");
    }
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    gridSelectingMode = mode;
    stateManager?.setSelectingMode(mode);
  }

  void handlerAddRows(String title) {
    final newRow = stateManager!.getNewRow();

    newRow.cells.values.first.value = title;

    stateManager!.appendRows([newRow]);

    stateManager?.setCurrentCell(
      newRow.cells.entries.first.value,
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
      // stateManager!.bodyColumns.length,
      stateManager!.bodyColumns.length + 1,
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

    textFieldAddFactorController.clear();
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

  void createCognitiveMap({isNew = true}) {
    List<PlutoColumn> newColumns = [];

    final factorsSytemColumn = _generateSytemColumn(
      "Factors",
      PlutoColumnType.text(),
      readOnly: true,
      frozen: PlutoColumnFrozen.start,
    );

    newColumns.add(factorsSytemColumn);

    for (var element in fileMapModel.value.factorList) {
      final factorColumn = _generateSytemColumn(
        element,
        PlutoColumnType.number(defaultValue: 0),
      );
      newColumns.add(factorColumn);
    }

    columns.addAll(newColumns);
    stateManager = PlutoGridStateManager(
      columns: columns,
      gridFocusNode: FocusNode(),
      rows: rows,
      scroll: PlutoGridScrollController(),
    );

    List<PlutoRow> newRows = [];

    if (isNew == false) {
      // todo: error
      for (var i = 0; i < fileMapModel.value.factorList.length; i++) {
        final newRow = _generateSytemRow(
          fileMapModel.value.factorList[i],
          data: fileMapModel.value.matrixW[i],
        );
        newRows.add(newRow);
      }
      rows.addAll(newRows);
    } else {
      for (var element in fileMapModel.value.factorList) {
        final newRow = _generateSytemRow(element);
        newRows.add(newRow);
      }

      rows.addAll(newRows);
    }
  }

  PlutoColumn _generateSytemColumn(
    String title,
    PlutoColumnType plutoColumnType, {
    bool readOnly = false,
    PlutoColumnFrozen frozen = PlutoColumnFrozen.none,
  }) {
    final newColumnId = const Uuid().v4();

    final newColumn = PlutoColumn(
      title: title,
      field: newColumnId,
      type: plutoColumnType,
      enableSorting: false,
      enableFilterMenuItem: false,
      enableEditingMode: true,
      enableColumnDrag: false,
      enableRowDrag: false,
      readOnly: readOnly,
      frozen: frozen,
    );

    return newColumn;
  }

  PlutoRow _generateSytemRow(String title, {List<double>? data}) {
    final newRow = stateManager!.getNewRows(count: addCount).first;

    newRow.cells.values.first.value = title;

    if (data != null) {
      for (var i = 1; i < newRow.cells.values.length; i++) {
        newRow.cells.values.elementAt(i).value = data[i - 1];
      }
    }

    return newRow;
  }

  void removeLastFactor() {
    final lastColumn = stateManager!.columns.last;

    if (lastColumn == null) {
      return;
    }

    stateManager!.removeColumns([lastColumn]);

    final lastRow = stateManager!.rows.last;

    stateManager!.removeRows([lastRow]);
  }

  void handleRemoveCurrentFactor() {
    final firstColumn = stateManager!.columns.first;

    final currentColumnFactor = stateManager!.currentColumn;

    if (currentColumnFactor == null) {
      return;
    }

    final currentRowFactor = stateManager!.rows.firstWhere((element) =>
        (element.cells.values.first.value as String) ==
        currentColumnFactor.title);

    if (currentColumnFactor.title == firstColumn.title) {
      Get.snackbar("Error", "You can't delete this system column.");
      return;
    }
    stateManager!.removeColumns([currentColumnFactor]);
    stateManager!.removeRows([currentRowFactor]);
  }

  bool isGridValid() {
    // if any cell is nullable
    for (var row in rows) {
      if (row.cells.values.any((element) => element.value == null) == true) {
        return false;
      }
    }

    // check if square
    if (rows.length != columns.length - 1) {
      return false;
    }

    return true;
  }
}

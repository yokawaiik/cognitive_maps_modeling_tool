import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:get/get.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/cognitive_map_editor_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../models/time_series_data_model.dart';
import '../../../utils/dynamics_of_controlled_factors.dart';
import '../../../utils/pluto_row_list_to_list.dart';

class AnalysisController extends GetxController {
  final CMEC = Get.find<CognitiveMapEditorController>();
  PlutoGridStateManager? matrixWstateManager;
  // ? info: vector S
  PlutoGridStateManager? vectorSstateManager;
  final vectorScolumns = RxList<PlutoColumn>([]);
  final vectorSrows = RxList<PlutoRow>([]);
  // ? info: vector U
  PlutoGridStateManager? vectorUstateManager;
  final vectorUcolumns = RxList<PlutoColumn>([]);
  final vectorUrows = RxList<PlutoRow>([]);
  var isVectorGridsBlocked = RxBool(true);
  // ? info: t - periods
  var periods = RxInt(2);
  List<String> _factorTitleRows = [];
  var timeSeriesList = <TimeSeriesDataModel>[].obs;
  @override
  void onInit() {
    _initMatrixW();
    _initVectorSGrid();
    _initVectorUGrid();
    super.onInit();
  }

  void _initMatrixW() {
    matrixWstateManager = PlutoGridStateManager(
      // columns: matrixWcolumns,
      // rows: matrixWrows,
      columns: [],
      rows: [],
      onRowChecked: handleOnRowChecked,
      gridFocusNode: FocusNode(),
      scroll: PlutoGridScrollController(),
    );
  }

  void _initVectorSGrid() {
    vectorSstateManager = PlutoGridStateManager(
      // columns: vectorScolumns,
      // rows: vectorSrows,
      columns: vectorScolumns,
      rows: vectorSrows,
      gridFocusNode: FocusNode(),
      scroll: PlutoGridScrollController(),
    );

    if (!isVectorGridsBlocked.value) {
      vectorSstateManager?.refColumns.clear();
      vectorSstateManager?.refRows.clear();

      // final factorTitleColumn = matrixWstateManager?.refColumns.first;

      final factorTitleColumn = PlutoColumn(
        title: "Factors",
        field: "system_factors",
        type: PlutoColumnType.text(),
        enableSorting: false,
        enableFilterMenuItem: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
      );

      _factorTitleRows.clear();
      final factorTitleRows = matrixWstateManager?.checkedRows
          .map((e) => e.cells.values.first.value as String)
          .toList();
      _factorTitleRows.addAll(factorTitleRows ?? []);

      // factorTitleColumn!.enableRowChecked = false;

      final zeroColumn = PlutoColumn(
        title: "S(0)",
        field: "s_0",
        type: PlutoColumnType.number(
          allowFirstDot: true,
          format: '#,###.##',
        ),
        enableSorting: false,
        enableFilterMenuItem: false,
        enableEditingMode: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: false,
      );

      vectorSstateManager?.refColumns.addAll([factorTitleColumn, zeroColumn]);

      List<PlutoRow> rows = [];
      for (var element in factorTitleRows!) {
        final newRow = vectorSstateManager!.getNewRows(count: 1).first;

        newRow.cells.values.first.value = element;
        rows.add(newRow);
      }
      vectorSstateManager!
          .insertRows(vectorSstateManager!.columns.length, rows);
    }
  }

  void _initVectorUGrid() {
    vectorUstateManager = PlutoGridStateManager(
      // columns: vectorUcolumns,
      // rows: vectorUrows,
      columns: vectorScolumns,
      rows: vectorUrows,
      gridFocusNode: FocusNode(),
      scroll: PlutoGridScrollController(),
    );

    if (!isVectorGridsBlocked.value) {
      vectorUstateManager!.refColumns.clear();
      vectorUstateManager!.refRows.clear();

      // final factorTitleColumn = matrixWstateManager!.refColumns.first;
      final factorTitleColumn = PlutoColumn(
        title: "Factors",
        field: "system_factors",
        type: PlutoColumnType.text(),
        enableSorting: false,
        enableFilterMenuItem: false,
        enableEditingMode: true,
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
      );
      final factorTitleRows = matrixWstateManager!.unCheckedRows
          .map((e) => e.cells.values.first.value as String)
          .toList();

      vectorUstateManager!.refColumns.add(factorTitleColumn);

      for (var i = 0; i < periods.value; i++) {
        final newColumn = PlutoColumn(
          title: "$i",
          field: "t_$i",
          type: PlutoColumnType.number(
            allowFirstDot: true,
            format: '#,###.##',
          ),
          enableSorting: false,
          enableFilterMenuItem: false,
          enableEditingMode: true,
          enableColumnDrag: false,
          enableRowDrag: false,
          readOnly: false,
        );
        vectorUstateManager!.refColumns.add(newColumn);
      }

      List<PlutoRow> rows = [];
      for (var element in factorTitleRows) {
        final newRow = vectorUstateManager!.getNewRows(count: 1).first;

        newRow.cells.values.first.value = element;
        rows.add(newRow);
      }
      vectorUstateManager!.insertRows(vectorUstateManager!.rows.length, rows);
    }
  }

  void _checkIfAllFactorsChoosed() {
    if (matrixWstateManager!.checkedRows.isEmpty) {
      isVectorGridsBlocked.value = true;
    } else if (matrixWstateManager?.checkedRows.length ==
        matrixWstateManager?.rows.length) {
      isVectorGridsBlocked.value = true;
    } else {
      isVectorGridsBlocked.value = false;
    }
  }

  // ? info : table selection
  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {
    // if (event.isRow) {
    //   print('Toggled Row: ${event.row?.cells.values.first.value}');
    // } else {
    //   print('Toggled All ${matrixWstateManager.checkedRows.length} Rows');
    //   // isVectorGridsBlocked.value = false;
    // }

    _checkIfAllFactorsChoosed();

    _initVectorSGrid();
    _initVectorUGrid();
    // print(
    //     'handleOnRowChecked - isVectorGridsBlocked.value : ${isVectorGridsBlocked.value}');
  }

  void pickPeriodCount() async {
    await showMaterialNumberPicker(
      context: Get.context!,
      title: 'Pick period counts',
      maxNumber: 50,
      minNumber: 2,
      selectedNumber: periods.value,
      onChanged: (value) => periods.value = value,
    );

    _initVectorUGrid();
  }

  // todo: loadedFromFile
  void matrixWUpdate({loadedFromFile = false}) {
    List<PlutoColumn> matrixWcolumns = [];

    for (var i = 0; i < CMEC.stateManager!.columns.length; i++) {
      final newColumn = PlutoColumn(
        // title: "$i",
        // field: "t_$i",
        title: CMEC.stateManager!.columns[i].title.toString(),
        field: CMEC.stateManager!.columns[i].field,
        // type: PlutoColumnType.number(),
        type: CMEC.stateManager!.columns[i].type,
        enableSorting: false,
        enableFilterMenuItem: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        enableRowDrag: false,
        readOnly: true,
      );
      matrixWcolumns.add(newColumn);
    }

    List<PlutoRow> matrixWrows = [];

    for (var element in CMEC.stateManager!.rows) {
      // final newRow = CMEC.stateManager!.getNewRows(count: 1).first;

      // newRow.cells.values.first.value = element;
      // // matrixWrows.add(newRow);
      // final newRow = CMEC.stateManager!.getNewRows(count: 1).first;

      // newRow.cells.values.first.value = element;

      matrixWrows.add(element);
    }
    // matrixWstateManager!
    //     .insertRows(CMEC.stateManager!.rows.length, matrixWrows);

    // for (var element in matrixWcolumns) {
    //   element.readOnly = true;F
    // }

    if (matrixWcolumns.isNotEmpty) {
      matrixWcolumns.first.enableRowChecked = true;
    }

    matrixWstateManager = PlutoGridStateManager(
      columns: matrixWcolumns,
      rows: matrixWrows,
      gridFocusNode: FocusNode(),
      scroll: PlutoGridScrollController(),
    );
  }

  void buildChart() {
    final rawMatrixW = plutoRowListToList(matrixWstateManager!.rows);

    final rawVectorS = plutoRowListToList(vectorSstateManager!.rows);
    final rawVectorSList = <double>[];
    for (var element in rawVectorS) {
      rawVectorSList.add(element[0]);
    }

    final rawVectorU = plutoRowListToList(vectorUstateManager!.refRows);

    final managedFactorIndexes =
        matrixWstateManager!.checkedRows.map((e) => e.sortIdx).toList();

    final result = dynamicsOfControlledFactors(
      w: rawMatrixW,
      managedFactorIndexes: managedFactorIndexes,
      rawVectorS: rawVectorSList,
      rawVectorU: rawVectorU,
      periodCount: periods.value,
    );

    _buildChart(result, _factorTitleRows);
  }

  void _buildChart(
    List<List<double>> chartLines,
    List<String> factorsTitleList,
  ) {
    timeSeriesList.clear();
    List<TimeSeriesDataModel> timeSeriesDataModelList = [];
    for (var i = 0; i < factorsTitleList.length; i++) {
      final timeSeriesLine = TimeSeriesDataModel.generateColor(
        title: factorsTitleList[i],
        dataList: chartLines[i],
      );

      timeSeriesDataModelList.add(timeSeriesLine);
    }
    timeSeriesList.addAll(timeSeriesDataModelList);
    timeSeriesList.refresh();
  }
}

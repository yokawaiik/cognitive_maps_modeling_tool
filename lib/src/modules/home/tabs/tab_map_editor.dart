import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/dynamics_of_controlled_factors.dart';

class TabMapEditor extends StatefulWidget {
  const TabMapEditor({super.key});

  @override
  State<TabMapEditor> createState() => _TabMapEditorState();
}

class _TabMapEditorState extends State<TabMapEditor> {
  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'system',
        field: 'system',
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
            'system': PlutoCell(value: "row1"),
            'column1': PlutoCell(value: 0),
            'column2': PlutoCell(value: 2),
            'column3': PlutoCell(value: 0),
            'column4': PlutoCell(value: 1),
          },
        ),
        PlutoRow(
          cells: {
            'system': PlutoCell(value: "row2"),
            'column1': PlutoCell(value: -2),
            'column2': PlutoCell(value: 0),
            'column3': PlutoCell(value: 12),
            'column4': PlutoCell(value: 7),
          },
        ),
        PlutoRow(
          cells: {
            'system': PlutoCell(value: "row3"),
            'column1': PlutoCell(value: 0),
            'column2': PlutoCell(value: -1),
            'column3': PlutoCell(value: 0),
            'column4': PlutoCell(value: -3),
          },
        ),
        PlutoRow(
          cells: {
            'system': PlutoCell(value: "row4"),
            'column1': PlutoCell(value: 2),
            'column2': PlutoCell(value: 1.1),
            'column3': PlutoCell(value: 2),
            'column4': PlutoCell(value: 0),
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            gridBorderColor: Colors.transparent,
            gridBackgroundColor: Colors.transparent,
            // oddRowColor: colorScheme.primary,
            activatedBorderColor: colorScheme.primary,
            activatedColor: colorScheme.primaryContainer,
          ),
        ),
        columns: columns,
        rows: rows,
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);

          // if (event.row.cells['status']!.value == 'saved') {
          //   event.row.cells['status']!.value = 'edited';
          // }

          stateManager.notifyListeners();
        },
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        createHeader: (stateManager) => _Header(stateManager: stateManager),
      ),
    );
  }

  void _handlerInputMatrix() {
    // final matrix = equations.RealMatrix.fromData(
    //   columns: 4,
    //   rows: 4,
    //   data: const [
    //     [0, 2, 0, 1],
    //     [-2, 0, 12, 7],
    //     [0, -1, 0, -3],
    //     [2, 1.1, 2, 0],
    //   ],
    // );

    // final eigenvalues = matrix.eigenvalues();

    // print('eigenvalues: ${eigenvalues.map((e) => e.real).toList()}');

    final w = <List<double>>[
      [0, 0.6, 0.3, 0.3, 0.5, 0.5],
      [0.9, 0, 0.7, 0.8, 0.2, 0.5],
      [0.2, 0.8, 0, 0.4, 0.6, 0.3],
      [0.1, 0.7, 0.6, 0, 0.7, 0.2],
      [0.9, 0.8, 0.5, 0.3, 0, 0.7],
      [0.8, 0.6, 0.3, 0.7, 0.7, 0],
    ];

    final managedFactorIndexes = [0, 1, 2];

    final rawVectorS = <double>[1, 2, 3];
    final rawVectorU = <List<double>>[
      [1, 2, 3],
      [1, 2, 3],
      [1, 2, 3],
    ];

    // final result = dynamicsOfControlledFactors(w, a, rawVectorS, rawVectorU, 2);
    final result = dynamicsOfControlledFactors(
      w: w,
      managedFactorIndexes: managedFactorIndexes,
      rawVectorS: rawVectorS,
      rawVectorU: rawVectorU,
      // periodCount: 1,
      periodCount: 2,
    );

    print(result);
  }
}

class _Header extends StatefulWidget {
  const _Header({
    required this.stateManager,
    Key? key,
  }) : super(key: key);

  final PlutoGridStateManager stateManager;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  int addCount = 1;

  int addedCount = 1;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.stateManager.setSelectingMode(gridSelectingMode);
    });
  }

  void handleAddColumns() {
    final List<PlutoColumn> addedColumns = [];
    final newColumnId = widget.stateManager.columns.length + 1;
    addedColumns.add(
      PlutoColumn(
        title: 'column$newColumnId',
        field: 'column$newColumnId',
        type: PlutoColumnType.number(),
        enableSorting: false,
        enableFilterMenuItem: false,
        enableEditingMode: true,
      ),
    );

    widget.stateManager.insertColumns(
      widget.stateManager.bodyColumns.length,
      addedColumns,
    );
  }

  void handleAddRows() {
    final newRows = widget.stateManager.getNewRows(count: addCount);

    widget.stateManager.appendRows(newRows);

    widget.stateManager.setCurrentCell(
      newRows.first.cells.entries.first.value,
      widget.stateManager.refRows.length - 1,
    );

    widget.stateManager.moveScrollByRow(
      PlutoMoveDirection.down,
      widget.stateManager.refRows.length - 2,
    );

    widget.stateManager.setKeepFocus(true);
  }

  void handleSaveAll() {
    widget.stateManager.setShowLoading(true);

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
    final currentColumn = widget.stateManager.currentColumn;

    if (currentColumn == null) {
      return;
    }

    widget.stateManager.removeColumns([currentColumn]);
  }

  void handleRemoveCurrentRowButton() {
    widget.stateManager.removeCurrentRow();
  }

  void handleRemoveSelectedRowsButton() {
    widget.stateManager.removeRows(widget.stateManager.currentSelectingRows);
  }

  // void handleFiltering() {
  //   widget.stateManager
  //       .setShowColumnFilter(!widget.stateManager.showColumnFilter);
  // }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      widget.stateManager.setSelectingMode(mode);
    });
  }

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
              onPressed: handleAddColumns,
              icon: Icon(Icons.view_column),
              label: const Text('Add columns'),
            ),
            ElevatedButton.icon(
              onPressed: handleAddRows,
              icon: Icon(Icons.table_rows),
              label: const Text('Add rows'),
            ),
            ElevatedButton.icon(
              onPressed: handleSaveAll,
              icon: Icon(Icons.save),
              label: const Text('Save all'),
            ),
            ElevatedButton.icon(
              onPressed: handleRemoveCurrentColumnButton,
              icon: Icon(Icons.view_column_outlined),
              label: const Text('Remove Current Column'),
            ),
            ElevatedButton.icon(
              onPressed: handleRemoveCurrentRowButton,
              icon: Icon(Icons.table_rows_outlined),
              label: const Text('Remove Current Row'),
            ),
            ElevatedButton.icon(
              onPressed: handleRemoveSelectedRowsButton,
              icon: Icon(Icons.remove_circle),
              label: const Text('Remove Selected Rows'),
            ),
          ],
        ),
      ),
    );
  }
}

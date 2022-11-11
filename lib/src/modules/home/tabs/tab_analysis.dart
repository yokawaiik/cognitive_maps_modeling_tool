import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:mdmwcm_app/src/widgets/compact_pluto_table.dart';
import 'package:mdmwcm_app/src/widgets/dynamics_chart_widget.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/time_series_data_model.dart';

class TabAnalysis extends StatefulWidget {
  const TabAnalysis({super.key});

  @override
  State<TabAnalysis> createState() => _TabAnalysisState();
}

class _TabAnalysisState extends State<TabAnalysis> {
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

    // PlutoGridStateManager stateManager = PlutoGridStateManager(scroll: null);
    stateManager = PlutoGridStateManager(
      columns: columns,
      gridFocusNode: FocusNode(),
      rows: rows,
      scroll: PlutoGridScrollController(),
    );
  }

  // todo: add to controller
  int periodCount = 0;

  void _pickPeriodCount(BuildContext context) async {
    await showMaterialNumberPicker(
      context: context,
      title: 'Pick period counts',
      maxNumber: 50,
      minNumber: 2,
      selectedNumber: periodCount,
      onChanged: (value) => setState(() => periodCount = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          CompactPlutoTable(
            stateManager: stateManager,
            header: Row(
              children: [
                Text(
                  "Selected factors",
                  style: textTheme.headline4,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Picked $periodCount periods.",
                  style: textTheme.headline5,
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => _pickPeriodCount(context),
                  child: Text(
                    "Pick period count",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CompactPlutoTable(
            stateManager: stateManager,
            header: Row(
              children: [
                Text(
                  "Dependent factors - S(0)",
                  style: textTheme.headline4,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CompactPlutoTable(
            stateManager: stateManager,
            header: Row(
              children: [
                Text(
                  "Сontrol factors - U",
                  style: textTheme.headline4,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _buildChart,
                child: Text("Build the chart"),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          DynamicsChartWidget(
            timeSeriesDataModelList: timeSeriesDataModelList,
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  List<TimeSeriesDataModel> timeSeriesDataModelList = [
    TimeSeriesDataModel.generateColor(
      title: "Factor 1",
      dataList: [5.9, 17.27, 43.991],
    ),
    TimeSeriesDataModel.generateColor(
      title: "Factor 2",
      dataList: [7.7, 20.61, 50.683],
    ),
    TimeSeriesDataModel.generateColor(
      title: "Factor 3",
      dataList: [7.3, 18.27, 44.825],
    ),
    TimeSeriesDataModel.generateColor(
      title: "Factor 4",
      dataList: [7.3, 18.27, 44.825],
    ),
  ];

// 5,9	17,27	43,991
// 7,7	20,61	50,683
// 7,3	18,27	44,825

// todo: realize _buildChart
  void _buildChart() {}
}

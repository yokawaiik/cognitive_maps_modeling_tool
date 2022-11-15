import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/analysis_controller.dart';
import 'package:mdmwcm_app/src/widgets/compact_pluto_table.dart';
import 'package:mdmwcm_app/src/widgets/dynamics_chart_widget.dart';

class TabAnalysis extends GetView<AnalysisController> {
  TabAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ElevatedButton(
          //   onPressed: controller.testDynamic,
          //   child: Text(
          //     "Test Dynamic",
          //   ),
          // ),
          CompactPlutoTable(
            stateManager: controller.matrixWstateManager!,
            onRowChecked: controller.handleOnRowChecked,
            header: Row(
              children: [
                Text(
                  "Select dependent factors",
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
                Obx(
                  () => Text(
                    "Picked ${controller.periods} periods.",
                    style: textTheme.headline5,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: !controller.isVectorGridsBlocked.value
                        ? controller.pickPeriodCount
                        : null,
                    child: Text(
                      "Pick period count",
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => CompactPlutoTable(
              stateManager: controller.vectorSstateManager!,
              isGridBlocked: controller.isVectorGridsBlocked.value,
              isGridBlockedMessage:
                  "You didn't choose any factors or choosed all factors.",
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
          ),
          SizedBox(
            height: 20,
          ),
          Obx(
            () => CompactPlutoTable(
              stateManager: controller.vectorUstateManager!,
              isGridBlocked: controller.isVectorGridsBlocked.value,
              isGridBlockedMessage:
                  "You didn't choose any factors or choosed all factors.",
              header: Row(
                children: [
                  Text(
                    "Сontrol factors - U(t)",
                    style: textTheme.headline4,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isVectorGridsBlocked.value
                      ? null
                      : controller.buildChart,
                  child: Text("Build the chart"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          DynamicsChartWidget(
              // timeSerieslList: controller.timeSeriesList,
              ),

          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  // List<TimeSeriesDataModel> timeSeriesDataModelList = [
  //   TimeSeriesDataModel.generateColor(
  //     title: "Factor 1",
  //     dataList: [5.9, 17.27, 43.991],
  //   ),
  //   TimeSeriesDataModel.generateColor(
  //     title: "Factor 2",
  //     dataList: [7.7, 20.61, 50.683],
  //   ),
  //   TimeSeriesDataModel.generateColor(
  //     title: "Factor 3",
  //     dataList: [7.3, 18.27, 44.825],
  //   ),
  //   TimeSeriesDataModel.generateColor(
  //     title: "Factor 4",
  //     dataList: [7.3, 18.27, 44.825],
  //   ),
  // ];

// 5,9	17,27	43,991
// 7,7	20,61	50,683
// 7,3	18,27	44,825

}

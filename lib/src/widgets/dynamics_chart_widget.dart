import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mdmwcm_app/src/models/time_series_data_model.dart';
import 'package:mdmwcm_app/src/modules/home/controllers/analysis_controller.dart';

class DynamicsChartWidget extends GetView<AnalysisController> {
  final double height;

  DynamicsChartWidget({
    super.key,
    this.height = 500,
  });

  // ? info: handling raw data
  List<FlSpot> _convertTimeSeriesToFlSpot(List<double> rawDataList) {
    final dataDotList = <FlSpot>[];

    for (var i = 0; i < rawDataList.length; i++) {
      dataDotList.add(FlSpot(i.toDouble(), rawDataList[i]));
    }

    return dataDotList;
  }

  LineChartBarData _convertTimeSeriesToLine(
    List<FlSpot> dataSpotList,
    Color color,
  ) {
    return LineChartBarData(
      spots: dataSpotList,
      color: color,
      isCurved: true,
    );
  }

  Widget _graph() {
    List<LineChartBarData> lineBarsData = [];

    for (var timeSeries in controller.timeSeriesList) {
      lineBarsData.add(
        _convertTimeSeriesToLine(
          _convertTimeSeriesToFlSpot(timeSeries.dataList),
          timeSeries.color,
        ),
      );
    }

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false), // grid
      ),

      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  @override
  Widget build(BuildContext context) {
    print('DynamicsChartWidget - rebuilt');
    return Obx(
      () => Padding(
        key: key,
        padding: const EdgeInsets.all(16),
        child: controller.timeSeriesList.isEmpty
            ? SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text("There is no data..."),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height,
                    child: _graph(),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: controller.timeSeriesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 6,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: controller.timeSeriesList[index].color,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          controller.timeSeriesList[index].title,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mdmwcm_app/src/models/time_series_data_model.dart';

class DynamicsChartWidget extends StatelessWidget {
  final double height;

  List<TimeSeriesDataModel> timeSeriesDataModelList;

  DynamicsChartWidget({
    super.key,
    required this.timeSeriesDataModelList,
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

    for (var timeSeries in timeSeriesDataModelList) {
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

      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            child: _graph(),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: timeSeriesDataModelList.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 6,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: timeSeriesDataModelList[index].color,
                  height: 24,
                  width: 24,
                ),
                SizedBox(
                  width: 24,
                ),
                Text(
                  timeSeriesDataModelList[index].title,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

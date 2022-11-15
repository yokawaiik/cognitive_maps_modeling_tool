import 'dart:math';

import 'package:flutter/material.dart';

class TimeSeriesDataModel {
  late final Color color;
  final String title;
  final List<double> dataList;

  TimeSeriesDataModel({
    required this.color,
    required this.title,
    required this.dataList,
  });

  TimeSeriesDataModel.generateColor({
    required this.title,
    required this.dataList,
  }) {
    color = _generateColor();
  }

  static Color _generateColor() {
    final random = Random();

    final randomColor = Color.fromARGB(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    return randomColor;
  }

  @override
  String toString() {
    return 'title : $title ; dataList : ${dataList.join(', ')}.';
  }
}

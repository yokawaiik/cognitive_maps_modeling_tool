import 'package:flutter/foundation.dart';

import 'dart:convert';

class FileMapModel {
  late String name;
  late List<String> factorList;
  late List<List<double>> matrixW;
  late List<int> selectedIndecies;
  late int periods;
  late List<List<double>> vectorS;
  late List<List<double>> vectorU;

  FileMapModel({
    required this.name,
    required this.factorList,
    required this.matrixW,
    required this.selectedIndecies,
    required this.periods,
    required this.vectorS,
    required this.vectorU,
  });

  @override
  String toString() {
    return _convertFromMapToString(toMap());
  }

  FileMapModel.onlyEditor({
    required this.name,
    required this.factorList,
    required this.matrixW,
  }) {
    periods = 2;
    vectorS = [];
    vectorU = [];
    selectedIndecies = [];
  }
  // FileMapModel.fromFile() {}

  Uint8List convertModelToUint8List() {
    final mapModel = toMap();

    return _convertFromStringToUint8List(
      _convertFromMapToString(mapModel),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "factorList": factorList,
      "matrixW": matrixW,
      "selectedIndecies": selectedIndecies,
      "periods": periods,
      "vectorS": vectorS,
      "vectorU": vectorU,
    };
  }

  String _convertFromMapToString(Map<String, dynamic> mapData) {
    return json.encode(mapData);
  }

  Map<String, dynamic> _convertStringToMap(String value) {
    return json.decode(value);
  }

  String _convertFromUint8ListToString(Uint8List uint8list) {
    return String.fromCharCodes(uint8list);
  }

  Uint8List _convertFromStringToUint8List(String value) {
    final List<int> codeUnits = value.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  FileMapModel.fromUint8List(Uint8List bytes) {
    try {
      final dataMap = _convertStringToMap(
        _convertFromUint8ListToString(bytes),
      );

      name = dataMap['name'] ?? "UnnameFd";
      factorList = (dataMap['factorList'] as List<dynamic>).cast<String>();

      matrixW = [];

      for (var row in dataMap['matrixW'] as List<dynamic>) {
        matrixW.add(
            (row as List<dynamic>).map((e) => double.parse('$e')).toList());
      }

      selectedIndecies =
          (dataMap['selectedIndecies'] as List<dynamic>).cast<int>();
      periods = dataMap['periods'] ?? 0;

      vectorS = [];
      for (var row in dataMap['vectorS'] as List<dynamic>) {
        vectorS.add(
            (row as List<dynamic>).map((e) => double.parse('$e')).toList());
      }

      vectorU = [];
      for (var row in dataMap['vectorU'] as List<dynamic>) {
        vectorU.add(
            (row as List<dynamic>).map((e) => double.parse('$e')).toList());
      }
    } catch (e) {
      if (kDebugMode) {
        print('FileMapModel.fromUint8List - e : $e');
      }
      throw Exception('Incorrect file structure.');
    }
  }
}

import 'package:pluto_grid/pluto_grid.dart';

List<List<double>> plutoRowListToList(List<PlutoRow> rows) {
  final List<List<double>> dataList = [];

  for (var i = 0; i < rows.length; i++) {
    var bufferRow = <double>[];
    for (var j = 1; j < rows[i].cells.values.length; j++) {
      // final value = rows[i].cells.values.toList()[j].value as double;
      final value =
          double.tryParse(rows[i].cells.values.toList()[j].value.toString()) ??
              0;
      bufferRow.add(value);
    }
    dataList.add(bufferRow);
  }

  return dataList;
}

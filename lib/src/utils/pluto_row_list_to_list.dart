import 'package:pluto_grid/pluto_grid.dart';

List<List<double>> plutoRowListToList(FilteredList<PlutoRow> inRefRows) {
  final List<List<double>> dataList = [];

  final refRows =
      inRefRows.map((row) => row.cells.remove(row.cells.keys.first)).toList();
  for (var refRow in refRows) {
    final rowValues =
        refRow!.row.cells.values.map((e) => e.value as double).toList();

    dataList.add(rowValues);
  }

  return dataList;
}

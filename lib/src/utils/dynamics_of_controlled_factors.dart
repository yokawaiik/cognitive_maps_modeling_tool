import 'package:equations/equations.dart' as equations;
import 'package:collection/collection.dart';

equations.Matrix<double> _selection(
  List<List<double>> source,
  List<int> rowIndexes,
  List<int> columnIndexes,
) {
  final rawMatrix = rowIndexes
      .mapIndexed((y, valueY) => columnIndexes
          .mapIndexed((x, valueX) => source[valueY][valueX])
          .toList())
      .toList();

  return equations.RealMatrix.fromData(
    rows: rowIndexes.length,
    columns: columnIndexes.length,
    data: rawMatrix,
  );
}

List<int> _otherIndexes(
  List<int> indexes,
  int matrixLength,
) {
  return List.generate(matrixLength, (int index) => index, growable: false)
      .where((value) => !indexes.contains(value))
      .toList();
}

equations.Matrix<double> _getMatrixA(
  List<List<double>> w, // Adjacency matrix (experts estimated)
  List<int> indexes, // Managed factor indexes
) {
  final matrix = _selection(
    w,
    indexes,
    indexes,
  );

  final identityMatrix = equations.RealMatrix.diagonal(
    rows: indexes.length,
    columns: indexes.length,
    diagonalValue: 1,
  );

  return matrix + identityMatrix;
}

equations.Matrix<double> _getMatrixB(
  List<List<double>> w, // Adjacency matrix (experts estimated)
  List<int> indexes, // Manage factor indexes
) {
  return _selection(
    w,
    indexes,
    _otherIndexes(indexes, w.length),
  );
}

List<List<double>> dynamicsOfControlledFactors({
  required List<List<double>> w, // Adjacency matrix (experts estimated)
  required List<int> managedFactorIndexes, // Managed factor indexes
  required List<double> rawVectorS,
  required List<List<double>> rawVectorU,
  int periodCount = 1,
  double eps = 0, // error
}) {
  for (var u in rawVectorU) {
    if (u.length - 1 != periodCount) {
      throw Exception("Period count and U matrix must be the same length.");
    }
  }

  if (managedFactorIndexes.length != rawVectorS.length) {
    throw Exception("Managed factors and vector S must be the same.");
  }

  if (w.length - managedFactorIndexes.length != rawVectorU.length) {
    throw Exception("Managed factors and vector U must be the same.");
  }

  // 1 Select matrix A and B from matrix W
  equations.Matrix<double> matrixA = _getMatrixA(w, managedFactorIndexes);
  equations.Matrix<double> matrixB = _getMatrixB(w, managedFactorIndexes);
  // print('matrixA: $matrixA');
  // print('matrixB: $matrixB');

  // 2 matrix S (timeSeriesList) calculation

  List<List<double>> timeSeriesList = []; // S

  timeSeriesList.add(rawVectorS);

  for (var t = 0; t < periodCount; t++) {
    List<double> currentRawVectorS;

    if (t < 1) {
      currentRawVectorS = timeSeriesList[t];
    } else {
      currentRawVectorS = timeSeriesList[timeSeriesList.length - 1];
    }

    final currentVectorS = equations.RealMatrix.fromData(
      rows: 1,
      columns: currentRawVectorS.length,
      data: [currentRawVectorS],
    ).transpose();

    final currentVectorU = equations.RealMatrix.fromData(
      rows: 1,
      columns: rawVectorU[t].length,
      data: [rawVectorU[t]],
    ).transpose();

    final multipliedAbyS = matrixA * currentVectorS;

    final multipliedBbyU = matrixB * currentVectorU;

    final nextS = (multipliedAbyS + multipliedBbyU).toList();

    timeSeriesList.add(nextS);
  }

  // each row is only one factor dynamic
  final timeSeriesListTransposed = equations.RealMatrix.fromData(
    rows: timeSeriesList.length,
    columns: timeSeriesList.first.length,
    data: timeSeriesList,
  ).transpose().toListOfList();

  // return timeSeriesList;
  return timeSeriesListTransposed;
}

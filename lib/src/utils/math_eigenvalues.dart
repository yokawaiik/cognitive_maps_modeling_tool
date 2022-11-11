import 'package:equations/equations.dart' as equations;

List<double> mathEigenvalues(List<List<double>> rawSquareMatrix) {
  final squareMatrix = equations.RealMatrix.fromData(
    columns: rawSquareMatrix.first.length,
    rows: rawSquareMatrix.length,
    data: rawSquareMatrix,
  );

  if (!squareMatrix.isSquareMatrix) {
    Exception("It isn't square matrix.");
  }

  final eigenvalues = squareMatrix.eigenvalues().map((e) => e.real).toList();

  return eigenvalues;
}

// class HomePageArguments {
//   String cognitiveMapName;
//   List<String> factorsList;

//   HomePageArguments({
//     required this.cognitiveMapName,
//     required this.factorsList,
//   });
// }
import 'package:mdmwcm_app/src/models/file_map_model.dart';

class HomePageArguments {
  FileMapModel fileMapModel;
  bool isNew;

  HomePageArguments({
    required this.fileMapModel,
    this.isNew = true,
  });
}

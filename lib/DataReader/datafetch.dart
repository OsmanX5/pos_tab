import 'dart:io';

import 'package:path_provider/path_provider.dart';

class dataFetch {
  Future<String> getItemsDataString() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/ItemsData.csv").readAsString();
  }
}

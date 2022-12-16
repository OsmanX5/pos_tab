import 'dart:ffi';

import 'package:pos_tab/DataReader/datafetch.dart';
import 'package:pos_tab/Items_screen_libs/item.dart';
import 'package:pos_tab/main.dart';

class CSV2Map {
  Future<Map<String, List<Item>>> getDataMap() async {
    String allDataString = await dataFetch().getItemsDataString();
    Map<String, List<Item>> tempMap = Map<String, List<Item>>();
    categories.forEach((category) {
      tempMap[category] = <Item>[];
    });
    List<String> lines = allDataString.split("\n");
    lines.removeAt(0);
    lines.forEach((line) {
      try {
        List<String> data = line.split(",");
        print(line);
        String Category = data[0];
        String name = data[1];
        Map<String, double> details = {};
        for (int i = 2; i < data.length; i += 2) {
          try {
            details[data[i]] = double.parse(data[i + 1]);
          } catch (e) {}
        }
        print("cat = " + Category + ".");
        print("name = " + name);
        details.forEach((key, value) {
          print(key + " " + value.toString());
        });
        print(tempMap[Category]!.length);
        tempMap[Category]!.add(Item(Category, name, details));
      } catch (e) {
        print("Lines end");
      }
    });
    return tempMap;
  }
}

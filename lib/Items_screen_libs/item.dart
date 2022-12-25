import 'package:pos_tab/Items_screen_libs/catedory.dart';

class Item {
  String category = "ICT";
  String name = " ";
  Map<String, double> details = {};
  bool available = true;
  bool inHome = false;
  int stock = 100000;
  int expYear = 2024;
  int expMonth = 12;
  Item(
      {this.category = "ICT",
      this.name = "Item",
      required this.details,
      this.available = true,
      this.inHome = false}) {}
}

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pos_tab/DataReader/csv2map.dart';
import 'package:pos_tab/Items_screen_libs/item.dart';
import 'package:pos_tab/main.dart';

class AddItemToDataBaseScreen extends StatefulWidget {
  Item newItem;
  bool checkBox_Available = true;
  bool checkBox_inHome = false;
  AddItemToDataBaseScreen({required this.newItem}) {
    checkBox_Available = newItem.available;
    checkBox_inHome = newItem.inHome;
  }

  @override
  State<AddItemToDataBaseScreen> createState() =>
      _AddItemToDataBaseScreenState();
}

class _AddItemToDataBaseScreenState extends State<AddItemToDataBaseScreen> {
  List<TextEditingController> CompaniesTextControllers = [];
  List<TextEditingController> PricesTextController = [];
  TextEditingController nameTextController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullScreenWidth / 1.5,
      height: fullScreenHeight / 1.1,
      child: AddNewItemScreenWidget(),
    );
  }

  Widget AddNewItemScreenWidget() {
    Widget screen = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          StockEditing(),
          Container(
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black,
              border: Border.all(color: Colors.amber, width: 3),
            ),
            child: ListView(
              children: allItems(),
            ),
          ),
        ],
      ),
    );

    return screen;
  }

  Widget CategoryName() {
    return Text(
      widget.newItem.category,
      style: TextStyle(
          color: Colors.amber, fontSize: 30, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget ItemName() {
    nameTextController.text = widget.newItem.name;
    return Container(
      width: 200,
      margin: EdgeInsets.only(top: 20, bottom: 10, right: 30, left: 30),
      child: TextField(
        controller: nameTextController,
        maxLength: 10,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize: XXLFont,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Item Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget CompAndPrice({int pos = 0}) {
    return Container(
      width: fullScreenWidth / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            margin: EdgeInsets.all(0),
            child: TextField(
              controller: CompaniesTextControllers[pos],
              maxLength: 12,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),

          ///Price
          Container(
            width: 100,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: PricesTextController[pos],
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget Actions() {
    return Container(
        width: fullScreenWidth / 3,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                deletItem();
              },
              child: Text(
                'Delet',
                style: TextStyle(fontSize: 50),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                saveItemToDataBase();
              },
              child: Text(
                'Save',
                style: TextStyle(fontSize: 50),
              ),
            )
          ],
        ));
  }

  List<Widget> compAndPriceArray() {
    List<Widget> temp = [];
    List<String> comps = [];
    List<double> prices = [];

    widget.newItem.details.forEach((key, value) {
      comps.add(key);
      prices.add(value);
    });
    int n = comps.length;
    for (int i = 0; i < 6; i++) {
      CompaniesTextControllers.add(TextEditingController());
      PricesTextController.add(TextEditingController());
      if (i < n) {
        CompaniesTextControllers[i].text = comps[i];

        PricesTextController[i].text = prices[i].toStringAsFixed(0);
      }
      temp.add(CompAndPrice(pos: i));
    }
    return temp;
  }

  List<Widget> allItems() {
    List<Widget> temp = [CategoryName(), ItemName()];
    compAndPriceArray().forEach((element) {
      temp.add(element);
    });
    temp.add(Actions());
    return temp;
  }

  int getItemIndex() {
    print(widget.newItem.category);
    for (int i = 0; i < allItemsData[widget.newItem.category]!.length; i++) {
      if (widget.newItem.name == allItemsData[widget.newItem.category]![i].name)
        return i;
    }
    return allItemsData[widget.newItem.category]!.length;
  }

  Item toSaveItem() {
    Map<String, double> details = {};
    for (int i = 0; i < 6; i++) {
      if (PricesTextController[i].text != "") {
        String priceEquation = PricesTextController[i].text;
        Parser p = new Parser();
        Expression exp = p.parse(priceEquation);
        double res = exp.evaluate(EvaluationType.REAL, ContextModel());
        details[CompaniesTextControllers[i].text] = res;
      }
    }
    if (details.length < 1) details = {"comp": 0};
    Item newItem = Item(
        category: widget.newItem.category,
        name: nameTextController.text,
        details: details);
    newItem.available = widget.checkBox_Available;
    newItem.inHome = widget.checkBox_inHome;
    return newItem;
  }

  void saveItemToDataBase() {
    int index = getItemIndex();
    if (index >= allItemsData[widget.newItem.category]!.length) {
      allItemsData[widget.newItem.category]!.add(toSaveItem());
    } else {
      allItemsData[widget.newItem.category]![index] = toSaveItem();
    }
    ItemsStreamController.add(true);
    CSV2Map().saveDataMap();
    Navigator.pop(context);
  }

  void deletItem() {
    int index = getItemIndex();
    if (index >= allItemsData[widget.newItem.category]!.length) {
      return;
    } else {
      allItemsData[widget.newItem.category]!.removeAt(index);
    }
    ItemsStreamController.add(true);
    Navigator.pop(context);
  }

  Widget StockEditing() {
    return Container(
      width: fullScreenWidth / 4.5,
      height: fullScreenHeight / 1.4,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Column(
        children: StockOptionsWidgets(),
      ),
    );
  }

  List<Widget> StockOptionsWidgets() {
    List<Widget> temp = [
      AvailableCheckBoxWidget(),
      AtHomeCheckBoxWidget(),
      StockSize(),
      ExpYear(),
      ExpMonth()
    ];
    return temp;
  }

  Widget AvailableCheckBoxWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Available",
            style: optionStyle(),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.all(Colors.blue),
            overlayColor: MaterialStateProperty.all(Colors.white),
            value: widget.checkBox_Available,
            onChanged: (value) {
              setState(() {
                widget.checkBox_Available = value!;
              });
            },
          )
        ],
      ),
    );
  }

  Widget AtHomeCheckBoxWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "In Home",
            style: optionStyle(),
          ),
          Checkbox(
            fillColor: MaterialStateProperty.all(Colors.blue),
            overlayColor: MaterialStateProperty.all(Colors.white),
            value: widget.checkBox_inHome,
            onChanged: (value) {
              setState(() {
                widget.checkBox_inHome = value!;
              });
            },
          )
        ],
      ),
    );
  }

  Widget StockSize() {
    stockController.text = widget.newItem.stock.toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Stock ",
            style: optionStyle(),
          ),
          Container(
            width: 100,
            child: TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget ExpYear() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ExpireYear ",
            style: optionStyle(),
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: DropdownButton(
              value: 2022,
              onChanged: (newVal) {},
              items: [for (int i = 2022; i < 2030; i++) i]
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          "${e}",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: XXLFont,
                              fontWeight: FontWeight.bold),
                        ),
                        value: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget ExpMonth() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ExpireYear ",
            style: optionStyle(),
          ),
          Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            alignment: Alignment.center,
            child: DropdownButton(
              value: 12,
              onChanged: (newVal) {},
              items: [for (int i = 1; i <= 12; i++) i]
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          "${e}",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: XXLFont,
                              fontWeight: FontWeight.bold),
                        ),
                        value: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle optionStyle() {
    return TextStyle(
      fontSize: XXXLFont,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    ;
  }
}

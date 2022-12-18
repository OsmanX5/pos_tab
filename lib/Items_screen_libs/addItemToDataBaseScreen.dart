import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pos_tab/DataReader/csv2map.dart';
import 'package:pos_tab/Items_screen_libs/item.dart';
import 'package:pos_tab/main.dart';

class AddItemToDataBaseScreen extends StatefulWidget {
  Item newItem;
  AddItemToDataBaseScreen({required this.newItem});

  @override
  State<AddItemToDataBaseScreen> createState() =>
      _AddItemToDataBaseScreenState();
}

class _AddItemToDataBaseScreenState extends State<AddItemToDataBaseScreen> {
  List<TextEditingController> CompaniesTextControllers = [];
  List<TextEditingController> PricesTextController = [];
  TextEditingController nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullScreenWidth / 3,
      height: fullScreenHeight / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black,
        border: Border.all(color: Colors.amber, width: 3),
      ),
      child: AddNewItemScreenWidget(),
    );
  }

  Widget AddNewItemScreenWidget() {
    Widget screen = Container(
      child: ListView(
        children: allItems(),
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
    return Item(widget.newItem.category, nameTextController.text, details);
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
}

import 'package:flutter/material.dart';
import '../Items_screen_libs/catedory.dart';
import '../Items_screen_libs/specificationScreen.dart';
import '../main.dart';

import 'item.dart';

//###########################################################
//#############  items screen to show all items #############
//###########################################################

//build with one column contain 2 raws each one with 3 columns called category
//####Category#####
//    class that get input(category name,number of horizental elemnts,number of Vertical elemnts,Color)

class ItemsWidget extends StatefulWidget {
  final Stream<bool> stream;
  const ItemsWidget({Key? key, required this.stream}) : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  Item toSaleItem = Item(details: {"Company": 0.0});

  callback(item) {
    setState(() {
      toSaleItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      refresh();
    });
  }

  refresh() {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Category(
                  name: "ICT",
                  h: 3,
                  w: 4,
                  color: Color.fromARGB(136, 255, 82, 82),
                  setItemFunction: callback,
                ),
                Category(
                  name: "Containers",
                  w: 5,
                  h: 3,
                  color: Color.fromARGB(120, 50, 170, 220),
                  setItemFunction: callback,
                ),
              ],
            ),
            Row(
              children: [
                Category(
                    name: "LAB",
                    w: 3,
                    h: 8,
                    color: Color.fromARGB(120, 15, 150, 109),
                    setItemFunction: callback),
                Category(
                    name: "Reagents",
                    w: 3,
                    h: 8,
                    color: Color.fromARGB(120, 233, 124, 0),
                    setItemFunction: callback),
                Category(
                    name: "Devices",
                    w: 3,
                    h: 8,
                    color: Color.fromARGB(120, 112, 112, 220),
                    setItemFunction: callback),
              ],
            )
          ],
        ),
      ),
    );
  }
}

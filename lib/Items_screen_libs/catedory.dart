import 'package:flutter/material.dart';
import 'package:pos_tab/Items_screen_libs/addNewItemToDataBase.dart';
import '../Items_screen_libs/item.dart';
import '../Items_screen_libs/item_widget.dart';
import '../Items_screen_libs/items_screen.dart';
import '../main.dart';

class Category extends StatefulWidget {
  int w, h;
  String name;
  Color color;
  List<Item>? items;
  Function setItemFunction;
  Category(
      {required this.name,
      required this.w,
      required this.h,
      required this.color,
      required this.setItemFunction}) {
    items = allItemsData[name];
  }
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // category name
        Text(
          widget.name,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 24,
            color: widget.color,
            fontFamily: 'Arial',
          ),
        ),

        //category body
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: widget.color,
          ),
          padding: EdgeInsets.all(10),
          width: 0.08 * fullScreenWidth * widget.w,
          height: 0.072 * fullScreenHeight * widget.h,

          //category Items
          child: GridView.count(
            controller: ScrollController(),
            crossAxisCount: widget.w,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 2,
            children: itemsBuilder(widget.items),
          ),
        )
      ],
    );
  }

  // a function convert list of items data to list of items widgets
  List<Widget> itemsBuilder(List<Item>? items) {
    List<Widget> itemsWidget = [];
    items?.forEach((item) {
      itemsWidget
          .add(ItemWidget(item: item, setItemFunction: widget.setItemFunction));
    });
    itemsWidget.add(AddNewItem2DataBaseWidget(
      category: widget.name,
    ));
    return itemsWidget;
  }
}

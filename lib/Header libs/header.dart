import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import '../Header%20libs/header_icon.dart';
import '../HotRestart.dart';
import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/item.dart';
import '../customer_screen.dart';
import '../main.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class Header extends StatefulWidget {
  Function dataBaseCallBack;
  Header({Key? key, required this.dataBaseCallBack}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  BuildContext? _context;
  bool databaseHover = false;
  String Emptyname = "";
  String Emptyprice = "0";
  String Emptyqty = "1";
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      width: fullScreenWidth,
      height: 30,
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          InkWell(
            onTap: () {
              FlutterWindowClose.closeWindow();
            },
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: Colors.red,
            ),
          ),
          const Icon(
            Icons.biotech,
            size: 30,
            color: Colors.white,
          ),
          const Text(
            "Lab-Med for Medical Equibments",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Expanded(child: SizedBox()),
          const Text(
            "برنامج التضريبات السريع ",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Expanded(child: SizedBox()),
          functionaIcons(),
        ],
      ),
    );
  }

  Widget functionaIcons() {
    return Container(
      width: fullScreenWidth / 2,
      padding: EdgeInsets.only(left: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        EmptyItemIcon(),
        dataBaseIcon(),
        saveIcon(),
        historyIcon(),
        AllItemsIcon(),
      ]),
    );
  }

  Widget dataBaseIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.edit,
        size: 24,
      ),
      tapFunction: openDataBase,
    );
  }

  Widget saveIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.check,
        size: 24,
      ),
      tapFunction: save,
    );
  }

  Widget historyIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.new_label,
        size: 24,
      ),
      tapFunction: showHistory,
    );
  }

  Widget AllItemsIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.all_inbox,
        size: 24,
      ),
      tapFunction: AllItems,
    );
  }

  Widget EmptyItemIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.add,
        size: 24,
      ),
      tapFunction: addEmpty,
    );
  }

  void openDataBase() {
    widget.dataBaseCallBack();
  }

  void save() {
    dataBox.clear();
    data.forEach((key, value) {
      dataBox.put(key, value);
    });
  }

  void showHistory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Text("choose customer order number"),
              content: CustomerScreen(),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "close",
                      style: TextStyle(fontSize: 32),
                    )),
              ],
            ));
  }

  void AllItems() {
    data.forEach((category, itemsList) {
      itemsList.forEach((item) {
        item.details.forEach((company, price) {
          currentCustomer.invoiceItems.add(
            new InvoiceItem(
                category: category,
                name: item.name,
                details: company,
                price: price,
                qty: 1),
          );
        });
      });
    });
    HotRestartController.performHotRestart(context);
  }

  void addEmpty() {
    showPopScreen(_context);
  }

  Future<void> showPopScreen(BuildContext) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: EmptyScreen(),
          actions: [
            HeaderIcon(
                tapFunction: addEmptyToInvoice,
                icon: Icon(
                  Icons.add,
                  size: 64,
                ))
          ],
        );
      },
    );
  }

  Widget EmptyScreen() {
    return Container(
      height: 280,
      child: Column(children: [
        // Name
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (x) {
              Emptyname = x;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ),

        // price
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (x) {
              Emptyprice = x;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.euro),
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ),

        // Quantity
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (x) {
              Emptyqty = x;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.numbers),
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.black,
            ),
          ),
        ),
      ]),
    );
  }

  void addEmptyToInvoice() {
    currentCustomer.invoiceItems.add(InvoiceItem(
      category: "LAB",
      name: Emptyname,
      details: "",
      price: double.parse(Emptyprice),
      qty: double.parse(Emptyqty),
    ));
    HotRestartController.performHotRestart(context);
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pos_tab/BlueToothPrinter/connection_screen.dart';
import '../Header%20libs/header_icon.dart';
import '../HotRestart.dart';
import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/item.dart';
import '../Customerslibs/customer_screen.dart';
import '../main.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class Header extends StatefulWidget {
  Header({Key? key}) : super(key: key);

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
        historyIcon(),
        ConnectIcon(),
        allPricesIcon()
      ]),
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

  Widget ConnectIcon() {
    return HeaderIcon(
      icon: Icon(
        Icons.bluetooth,
        color: isConnectedToBlueToothPrinter ? Colors.green : Colors.red,
        size: 24,
      ),
      tapFunction: OpenBluetoothConnection,
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

  void showHistory() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              content: CustomerScreen(),
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
            ));
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

  void OpenBluetoothConnection() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConnectionScreen(title: "connect to Bluettoth"),
    ));
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
      qty: int.parse(Emptyqty),
    ));
    HotRestartController.performHotRestart(context);
  }

  void GetAllItemsPrices() {
    AudioPlayer().play(AssetSource('audio/my_audio.mp3'));
    String temp =
        "prices for ${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}";
    categories.forEach((cat) {
      temp += "\n###### ${cat} ######\n";
      allItemsData[cat]!.forEach((item) {
        if (item.available) {
          item.details.forEach((comp, price) {
            temp += "\n ${item.name} [${comp}] = " + price.toStringAsFixed(0);
          });
        }
      });
    });
    Clipboard.setData(ClipboardData(text: temp));
  }

  Widget allPricesIcon() {
    return HeaderIcon(
      icon: const Icon(
        Icons.price_change,
        size: 24,
      ),
      tapFunction: GetAllItemsPrices,
    );
  }
}

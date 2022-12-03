import 'dart:async';
import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_tab/BlueToothPrinter/connection_screen.dart';
import 'HotRestart.dart';
import 'Invoice_libs/customer.dart';
import 'Invoice_libs/invoice_item.dart';
import 'Items_screen_libs/item.dart';
import 'home.dart';
import 'package:path_provider/path_provider.dart';

// Global variabels
Map<String, List<Item>> data = {};
String currentdate =
    "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";

StreamController<bool> streamController = StreamController<bool>.broadcast();
int orders = 1;
late Customer currentCustomer;
late Box dataBox;
List<String> categories = ["ICT", "LAB", "Containers", "Reagents", "Devices"];
late Box ordersHistory;
List<Customer> customerHistory = [];
double fullScreenWidth = 1080;
double fullScreenHeight = 1920;

final BluePrintPos bluePrintPos = BluePrintPos.instance;
Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ItemAdapter());
  dataBox = await Hive.openBox("data");
  ordersHistory = await Hive.openBox("ordersHistory");
  data = boxDataRead(dataBox);
  print(await getTemporaryDirectory());
  if (!ordersHistory.containsKey(currentdate))
    ordersHistory.put(currentdate, 1);
  orders = ordersHistory.get(currentdate);

  currentCustomer = new Customer(orderNo: orders);
  runApp(
    HotRestartController(
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Colors.black12,
            canvasColor: Colors.black,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)),
        home: ConnectionScreen(title: "Connection screen"),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );

  /* WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setFullScreen(true);
    // await windowManager.center();
    // await windowManager.show();
    await windowManager.setSkipTaskbar(true);
  });*/
}

//read all data inside a box
Map<String, List<Item>> boxDataRead(Box box) {
  Map<String, List<Item>> data = {};
  box.keys.forEach((key) {
    data[key] = List<Item>.from(box.get(key));
  });

  return data;
}

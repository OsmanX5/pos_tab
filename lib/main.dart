import 'dart:async';
import 'dart:io';
import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_tab/BlueToothPrinter/connection_screen.dart';
import 'package:pos_tab/DataReader/csv2map.dart';
import 'HotRestart.dart';
import 'Customerslibs/customer.dart';
import 'Invoice_libs/invoice_item.dart';
import 'Items_screen_libs/item.dart';
import 'MainScreens/home.dart';
import 'package:path_provider/path_provider.dart';

// Global variabels
double XSFont = 10;
double SFont = 12;
double MFont = 14;
double LFont = 16;
double XLFont = 18;
double XXLFont = 24;
double XXXLFont = 30;
Map<String, List<Item>> allItemsData = {};
String currentdate =
    "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";

StreamController<bool> InvoiceStreamController =
    StreamController<bool>.broadcast();
StreamController<bool> ItemsStreamController =
    StreamController<bool>.broadcast();
int orders = 1;
late Customer currentCustomer;
late Box dataBox;
List<String> categories = ["ICT", "LAB", "Containers", "Reagents", "Devices"];
late Box ordersHistory;
double fullScreenWidth = 1080;
double fullScreenHeight = 1920;
bool isConnectedToBlueToothPrinter = false;
final BluePrintPos bluePrintPos = BluePrintPos.instance;
Future<void> main() async {
  await Hive.initFlutter();
  String completeData = "";
  ordersHistory = await Hive.openBox("ordersHistory");
  print(await getTemporaryDirectory());
  if (!ordersHistory.containsKey(currentdate))
    ordersHistory.put(currentdate, 1);
  orders = ordersHistory.get(currentdate);

  final dataFromCSV = CSV2Map().getDataMap();
  allItemsData = await dataFromCSV;
  currentCustomer = new Customer();
  currentCustomer.orderNo = orders;
  runApp(
    HotRestartController(
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: Colors.black12,
            canvasColor: Colors.black,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)),
        home: Home(),
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

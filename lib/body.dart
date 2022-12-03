import 'package:flutter/material.dart';

import 'Invoice_libs/invoice.dart';
import 'Items_screen_libs/items_screen.dart';
import 'main.dart';

//###########################################################
//#############  application screen except app bar###########
//###########################################################

//build with one row contain 2 onjects
//###first#### items screen
//###second### Invoice screen

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: fullScreenWidth,
        color: Color.fromARGB(255, 20, 20, 20),
        child: Row(children: [
          ItemsWidget(),
          InvoiceWidget(
            stream: streamController.stream,
          ),
        ]),
      ),
    );
  }
}

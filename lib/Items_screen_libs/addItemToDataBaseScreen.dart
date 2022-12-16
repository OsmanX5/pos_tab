import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:pos_tab/main.dart';

class AddItemToDataBaseScreen extends StatefulWidget {
  const AddItemToDataBaseScreen({super.key});

  @override
  State<AddItemToDataBaseScreen> createState() =>
      _AddItemToDataBaseScreenState();
}

class _AddItemToDataBaseScreenState extends State<AddItemToDataBaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullScreenWidth / 3,
      height: fullScreenHeight / 1.2,
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
      child: Column(children: [Text("Name")]),
    );

    return screen;
  }
}

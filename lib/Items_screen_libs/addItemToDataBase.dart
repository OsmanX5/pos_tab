import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pos_tab/Items_screen_libs/addItemToDataBaseScreen.dart';
import 'package:pos_tab/main.dart';
import 'package:flutter/material.dart';

class AddItem2DataBase extends StatelessWidget {
  const AddItem2DataBase({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color.fromARGB(120, 20, 20, 20),
      ),
      child: InkWell(
        onDoubleTap: () {
          print("adding new item");
          showPopScreen(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> showPopScreen(BuildContext context) async {
    await showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          content: AddItemToDataBaseScreen(),
        );
      },
    );
  }
}

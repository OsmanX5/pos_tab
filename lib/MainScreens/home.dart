import 'package:flutter/material.dart';
import 'package:pos_tab/main.dart';
import '../DataReader/csv2map.dart';
import '../Header libs/header.dart';
import 'body.dart';
import 'package:flutter/services.dart';

//########################################################
//##################THe main application window###########
//########################################################
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool databaseOpen = false;
  Widget body = Body();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    fullScreenWidth = MediaQuery.of(context).size.width;
    fullScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: fullScreenWidth,
          height: fullScreenHeight,
          child: Column(children: [
            Header(),
            body,
          ]),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

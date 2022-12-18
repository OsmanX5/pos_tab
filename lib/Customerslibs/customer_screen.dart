import 'dart:collection';

import 'package:flutter/material.dart';

import 'custormer_widget.dart';
import 'main.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      child: ListView(children: customerscreenBuilder()),
    );
  }

  List<Widget> customerscreenBuilder() {
    List<Widget> result = [];
    HashSet<int> listed = HashSet();
    customerHistory.forEach((customer) {
      if (!listed.contains(customer.orderNo)) {
        listed.add(customer.orderNo);
        result.add(CustomerWidget(customer: customer));
      }
    });
    return result;
  }
}

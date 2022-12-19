import 'package:flutter/material.dart';

import '../HotRestart.dart';
import 'customer.dart';
import '../main.dart';

class CustomerWidget extends StatefulWidget {
  Customer customer;
  CustomerWidget({required this.customer});

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: ListTile(
          onTap: () {
            currentCustomer = widget.customer;
            Navigator.pop(context);
            setState(() {});
            InvoiceStreamController.add(true);
            print("start");
          },
          leading: Icon(
            Icons.person,
            color: Colors.black,
          ),
          title: Text(widget.customer.name + ItemsNames()),
          subtitle: Text(
            widget.customer.total.toStringAsFixed(0),
            style: TextStyle(fontSize: XXLFont, color: Colors.blueAccent),
          ),
          trailing: Text(widget.customer.orderNo.toStringAsFixed(0))),
    );
  }

  String ItemsNames() {
    String res = "";
    widget.customer.invoiceItems.forEach((item) {
      res += "-[${item.name}]";
    });
    return res;
  }
}

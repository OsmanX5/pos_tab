import 'package:flutter/material.dart';

import 'HotRestart.dart';
import 'Invoice_libs/customer.dart';
import 'main.dart';

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
      child: ListTile(
          onTap: () {
            currentCustomer = widget.customer;
            Navigator.pop(context);
            setState(() {});
            InvoiceStreamController.add(true);
            print("start");
          },
          leading: Icon(Icons.person),
          title: Text(widget.customer.name),
          subtitle: Text(widget.customer.total.toStringAsFixed(0)),
          trailing: Text(widget.customer.orderNo.toStringAsFixed(0))),
    );
  }
}

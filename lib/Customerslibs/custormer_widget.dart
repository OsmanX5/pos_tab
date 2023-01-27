import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Customer temp = Customer();
            temp.name = widget.customer.name;
            temp.invoiceItems = widget.customer.invoiceItems;
            temp.orderNo = widget.customer.orderNo;
            currentCustomer = temp;
            Navigator.pop(context);
            setState(() {});
            InvoiceStreamController.add(true);
            print("start");
          },
          leading: Text(
            widget.customer.orderNo.toString(),
            style: TextStyle(color: Colors.black, fontSize: XXLFont),
          ),
          title: Text(widget.customer.name + ItemsNames()),
          subtitle: Text(
            widget.customer.total.toStringAsFixed(0),
            style: TextStyle(fontSize: XXLFont, color: Colors.blueAccent),
          ),
          trailing: IconButton(
            onPressed: () {
              _launchWhatsapp();
            },
            icon: Icon(
              Icons.waving_hand,
              color: Colors.green,
            ),
          ),
        ));
  }

  String ItemsNames() {
    String res = "";
    widget.customer.invoiceItems.forEach((item) {
      res += "-[${item.name}]";
    });
    return res;
  }

  void CopyData() {
    Clipboard.setData(
        ClipboardData(text: widget.customer.GetInvoiceAsCSV(category: false)));
  }

  _launchWhatsapp() async {
    var whatsapp = "249127150708";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
}

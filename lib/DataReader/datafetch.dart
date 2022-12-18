import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_tab/Invoice_libs/customer.dart';

class dataFetch {
  Future<String> getItemsDataString() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/ItemsData.csv").readAsString();
  }

  Future<void> saveDataString(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    File("${directory.path}/ItemsData.csv").writeAsString(data, flush: true);
  }

  Future<void> saveCustomerData(Customer customer) async {
    final directory = await getApplicationDocumentsDirectory();

    String path =
        "${directory.path}/OldInvoices/${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/";
    String fileName =
        "${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}_${customer.orderNo}_${customer.name}_${customer.total}.csv";
    File(path + fileName)
        .create(recursive: true)
        .then((file) => file.writeAsString(customer.GetInvoiceAsCSV()));
  }
}

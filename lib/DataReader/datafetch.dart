import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_tab/Customerslibs/customer.dart';

class dataFetch {
  Future<String> getItemsDataString() async {
    final directory = await getApplicationDocumentsDirectory();
    print("the path is ${directory.path}");
    Future<String> data;
    data = File("${directory.path}/ItemsData.csv").readAsString();
    return data;
  }

  Future<void> saveDataString(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    File("${directory.path}/ItemsData.csv").writeAsString(data, flush: true);
  }

  Future<void> saveCustomerData(Customer customer) async {
    final directory = await getApplicationDocumentsDirectory();

    String path =
        "${directory.path}/OldInvoices/${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/";
    String fileName = customer.orderNo.toString() + ".csv";
    File(path + fileName)
        .create(recursive: true)
        .then((file) => file.writeAsString(customer.GetInvoiceAsCSV()));
  }

  Future<List<String>> getAllCustomerStringInDate(
      int year, int month, int day) async {
    List<String> res = [];
    final directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/OldInvoices/${year}/${month}/${day}";
    try {
      List<FileSystemEntity> allfiles = await Directory(path).list().toList();
      for (final file in allfiles) {
        if (await file.exists()) res.add(await (file as File).readAsString());
      }
    } catch (e) {
      print("no files");
    }

    return res;
  }
}

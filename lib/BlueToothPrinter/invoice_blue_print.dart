/*import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:pos_tab/Invoice_libs/invoice_item.dart';

import '../Customerslibs/customer.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class InvoiceBluePrint {
  Customer Mycustomer = new Customer();
  final ReceiptSectionText receiptText = ReceiptSectionText();
  final time = DateTime.now();
  int counter = 1;
  InvoiceBluePrint(Customer customer) {
    Mycustomer = customer;
    print(customer.name);
    print("l = " + "${customer.invoiceItems.length}");
    print("first = ${customer.invoiceItems[0].name}");
    _onPrintReceipt();
  }

  Future<void> _onPrintReceipt() async {
    /// Example for Print Text
    _printHeader();
    _printInvoice();
    _printTotal();
    await bluePrintPos.printReceiptText(receiptText);
  }

  Future<void> _printHeader() async {
    receiptText.addText(
      "LabMed for medical",
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(count: 1);
    receiptText.addLeftRightText(" Order No : ${Mycustomer.orderNo}",
        " Date : ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}",
        leftStyle: ReceiptTextStyleType.bold,
        leftSize: ReceiptTextSizeType.large);
    receiptText.addSpacer(count: 1);
    receiptText.addText("------------------------",
        size: ReceiptTextSizeType.extraLarge, style: ReceiptTextStyleType.bold);
    receiptText.addText("${Mycustomer.name} ",
        alignment: ReceiptAlignment.right,
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.large);
    receiptText.addText("------------------------",
        size: ReceiptTextSizeType.extraLarge, style: ReceiptTextStyleType.bold);
  }

  Future<void> _printInvoice() async {
    print("Now printing The Invoice ");
    String pastCategory = "";
    Mycustomer.GetSortItems().forEach((item) {
      print("Now on item " + item.name + "in cat" + item.category);
      if (item.category != pastCategory) {
        pastCategory = item.category;
        receiptText.addSpacer(count: 1);
        receiptText.addText(item.category, alignment: ReceiptAlignment.center);
      }
      _printInvoiceItem(item);
      counter += 1;
    });
    receiptText.addSpacer(count: 1);
  }

  Future<void> _printInvoiceItem(InvoiceItem item) async {
    print("Now printing invoice item" + item.name);
    receiptText.addSpacer(count: 1, useDashed: true);
    print(item.name);
    receiptText.addLeftRightText(
      "${counter} | ${item.name}(${item.details})  ",
      "  [ ${item.qty.toStringAsFixed(0)} ]  X ${item.price.toStringAsFixed(0)}= ${item.total.toStringAsFixed(0)}",
      leftStyle: ReceiptTextStyleType.bold,
      leftSize: ReceiptTextSizeType.medium,
      rightStyle: ReceiptTextStyleType.bold,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addSpacer(count: 2);
  }

  Future<void> _printTotal() async {
    receiptText.addText(
      "=====================================",
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addText(
      "Total : ${Mycustomer.total.toStringAsFixed(0)}",
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(count: 1);
    receiptText.addText(
      "=====================================",
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(count: 3);
  }
}
*/
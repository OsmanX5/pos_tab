import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:pos_tab/Invoice_libs/invoice_item.dart';

import '../Invoice_libs/customer.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class InvoiceBluePrint {
  Customer customer = new Customer(orderNo: 1);
  final ReceiptSectionText receiptText = ReceiptSectionText();
  final time = DateTime.now();
  int counter = 1;
  InvoiceBluePrint(this.customer) {
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
    receiptText.addLeftRightText(" Order No : ${customer.orderNo}",
        " Date : ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}",
        leftStyle: ReceiptTextStyleType.bold,
        leftSize: ReceiptTextSizeType.large);
    receiptText.addSpacer(count: 1);
    receiptText.addText("${customer.name} ",
        alignment: ReceiptAlignment.right,
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.large);
    receiptText.addSpacer(count: 2);
  }

  Future<void> _printInvoice() async {
    customer.invoiceItems.forEach((item) {
      _printInvoiceItem(item);
      counter += 1;
    });
    receiptText.addSpacer(count: 3);
  }

  Future<void> _printInvoiceItem(InvoiceItem item) async {
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
      "Total : ${customer.total.toStringAsFixed(0)}",
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptText.addSpacer(count: 1);
    receiptText.addLeftRightText(" Mbok : 1083065", " يوسف عثمان الفكي",
        leftStyle: ReceiptTextStyleType.bold,
        leftSize: ReceiptTextSizeType.large);
    receiptText.addSpacer(count: 5);
  }
}

import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/item.dart';

class Customer {
  String name = "";
  int orderNo = 0;
  List<InvoiceItem> invoiceItems = [];

  String payMethod = "";
  double get total {
    double sum = 0;
    invoiceItems.forEach((element) {
      sum += element.total;
    });
    return sum;
  }

  List<InvoiceItem> GetSortItems() {
    List<InvoiceItem> oldList = this.invoiceItems;
    List<InvoiceItem> temp = [];
    if (oldList.isEmpty) return [];
    oldList.forEach((item) {
      if (item.category == "ICT") {
        temp.add(item);
      }
    });
    oldList.forEach((item) {
      if (item.category == "LAB") {
        temp.add(item);
      }
    });
    oldList.forEach((item) {
      if (item.category == "Containers") {
        temp.add(item);
      }
    });
    oldList.forEach((item) {
      if (item.category == "Reagents") {
        temp.add(item);
      }
    });
    oldList.forEach((item) {
      if (item.category == "Devices") {
        temp.add(item);
      }
    });

    return temp;
  }

  String GetInvoiceAsCSV({bool category = true, bool price_andTotal = true}) {
    String temp = "${this.name},${this.orderNo}";

    this.GetSortItems().forEach((invoiceItem) {
      temp += "\n";
      temp += category ? invoiceItem.category + "," : "";
      temp += "${invoiceItem.name},${invoiceItem.details},${invoiceItem.qty}";
      temp +=
          price_andTotal ? ",${invoiceItem.price},${invoiceItem.total}" : "";
    });
    return temp;
  }

  Customer({String CustomerInfo = ""}) {
    UpdateCustomerDataFromCustomerInfo(CustomerInfo);
  }
  String getInvoiceString(
      {bool category = false,
      bool total = true,
      bool qty = true,
      bool price = true}) {
    String temp = "${this.name},${this.orderNo}";

    this.GetSortItems().forEach((invoiceItem) {
      temp += "\n";
      temp += category ? invoiceItem.category + " : " : "";
      temp += "${invoiceItem.name} (${invoiceItem.details})     ";
      temp += qty ? invoiceItem.qty.toString() + " X " : "";
      temp += price ? invoiceItem.price.toStringAsFixed(0) : "";
      temp += total ? " = " + invoiceItem.total.toStringAsFixed(0) : "";
    });
    temp += total ? "\n\n total = ${this.total.toStringAsFixed(0)} SDG" : " ";
    return temp;
  }

  void UpdateCustomerDataFromCustomerInfo(String info) {
    List<String> InvoiceLines = info.split("\n");
    List<String> mainData = InvoiceLines[0].split(",");
    try {
      this.name = mainData[0];
    } catch (e) {}
    InvoiceLines.removeAt(0);
    InvoiceLines.forEach((line) {
      List<String> data = line.split(",");
      InvoiceItem temp = InvoiceItem(
          category: data[0],
          name: data[1],
          details: data[2],
          qty: double.parse(data[3]).toInt(),
          price: double.parse(data[4]));
      this.invoiceItems.add(temp);
    });
  }
}

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

  String GetInvoiceAsCSV() {
    String temp = "${this.name},${this.orderNo}";

    this.GetSortItems().forEach((invoiceItem) {
      temp +=
          "\n${invoiceItem.category},${invoiceItem.name},${invoiceItem.details},${invoiceItem.qty},${invoiceItem.price},${invoiceItem.total}";
    });
    return temp;
  }

  Customer({String CustomerInfo = ""}) {
    UpdateCustomerDataFromCustomerInfo(CustomerInfo);
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

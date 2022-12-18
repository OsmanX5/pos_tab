import '../Invoice_libs/invoice_item.dart';
import '../Items_screen_libs/item.dart';

class Customer {
  String name = "";
  int orderNo;
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
    String temp = "";
    this.GetSortItems().forEach((invoiceItem) {
      temp +=
          "\n${invoiceItem.category},${invoiceItem.name},${invoiceItem.details},${invoiceItem.qty},${invoiceItem.price},${invoiceItem.total}";
    });
    return temp;
  }

  Customer({required this.orderNo});
}

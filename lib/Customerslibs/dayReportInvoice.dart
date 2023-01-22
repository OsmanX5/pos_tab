import 'package:pos_tab/Customerslibs/customer.dart';
import 'package:pos_tab/Invoice_libs/invoice_item.dart';
import 'package:pos_tab/main.dart';

class DayReport {
  List<Customer> thisDayCustomers = [];
  DayReport(this.thisDayCustomers);

  String GetDayReportAsCustomer() {
    Customer dayReport = Customer();
    dayReport.orderNo = 1000;
    thisDayCustomers.forEach((tempCustomer) {
      tempCustomer.invoiceItems.forEach((CustomerItem) {
        bool founded = false;
        for (int index = 0; index < dayReport.invoiceItems.length; index++) {
          if (CustomerItem.name == dayReport.invoiceItems[index].name &&
              CustomerItem.details == dayReport.invoiceItems[index].details) {
            founded = true;
            dayReport.invoiceItems[index].qty += CustomerItem.qty;
            break;
          }
        }
        if (founded == false) {
          dayReport.invoiceItems.add(CustomerItem);
        }
      });
    });
    return dayReport.getInvoiceString();
  }

  String GetHomeItems() {
    Customer dayReport = Customer();
    dayReport.orderNo = 1000;
    thisDayCustomers.forEach((tempCustomer) {
      tempCustomer.invoiceItems.forEach((CustomerItem) {
        bool founded = false;
        for (int index = 0; index < dayReport.invoiceItems.length; index++) {
          if (CustomerItem.name == dayReport.invoiceItems[index].name &&
              CustomerItem.details == dayReport.invoiceItems[index].details) {
            founded = true;
            dayReport.invoiceItems[index].qty += CustomerItem.qty;
            break;
          }
        }
        if (founded == false) {
          categories.forEach((cat) {
            allItemsData[cat]!.forEach((element) {
              if (element.name == CustomerItem.name && element.inHome) {
                dayReport.invoiceItems.add(CustomerItem);
              }
            });
          });
        }
      });
    });
    return dayReport.getInvoiceString(price: false, total: false);
  }
}

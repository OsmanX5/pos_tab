import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:pos_tab/Customerslibs/dayReportInvoice.dart';
import 'package:pos_tab/DataReader/datafetch.dart';
import 'customer.dart';
import 'custormer_widget.dart';
import '../main.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String toSearchDate = "";
  // "${DateTime.now().year}:${DateTime.now().month}:${DateTime.now().day}";
  TextEditingController ControlertoSearchDate = TextEditingController();
  List<Customer> toShowCustomersList = [];
  @override
  Widget build(BuildContext context) {
    print(
        "reBuilding with customer list of length ${toShowCustomersList.length}");
    return Container(
      width: fullScreenWidth / 3,
      height: fullScreenHeight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.black,
          border: Border.all(color: Colors.amber, width: 3)),
      child: Column(
        children: [
          getDateWidget(),
          Expanded(
              child: ListView(
                  children: customerscreenBuilder(toShowCustomersList))),
        ],
      ),
    );
  }

  List<Customer> thisDayCustomersList(int year, int month, int day) {
    List<Customer> temp = [];

    return temp;
  }

  List<Widget> customerscreenBuilder(List<Customer> customersList) {
    List<Widget> result = [];
    HashSet<int> listed = HashSet();
    customersList.forEach((customer) {
      if (!listed.contains(customer.orderNo)) {
        listed.add(customer.orderNo);
        result.add(CustomerWidget(customer: customer));
        print("new Customer widget builded");
      }
    });
    return result;
  }

  Widget getDateWidget() {
    ControlertoSearchDate.text = toSearchDate;
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              print("Pressed");
              print(DayReport(toShowCustomersList).GetDayReportAsCustomer());
            },
            child: Text("Get Day Report"),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.all(0),
            child: TextField(
              controller: ControlertoSearchDate,
              keyboardType: TextInputType.datetime,
              onSubmitted: (value) {
                List<String> temp = value.split(":");
                try {
                  int year = int.parse(temp[0]);
                  int month = int.parse(temp[1]);
                  int day = int.parse(temp[2]);
                  GetTheCustomersDataAtTheDate(year, month, day);
                } catch (e) {
                  print("inValid date");
                }
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> GetTheCustomersDataAtTheDate(
      int year, int month, int day) async {
    List<String> AllCustomers =
        await dataFetch().getAllCustomerStringInDate(year, month, day);
    print(AllCustomers.length);
    List<Customer> res = [];
    int counter = 1;
    AllCustomers.forEach((CustomerDataString) {
      try {
        //adding customer
        Customer temp = Customer(CustomerInfo: CustomerDataString);
        temp.orderNo = counter;
        res.add(temp);
        print("Customer Number${counter} added");
      } catch (e) {
        print("error in  adding this customer ${counter}");
      }
      counter += 1;
    });
    setState(() {
      toShowCustomersList = res;
    });
  }
}

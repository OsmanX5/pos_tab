import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:pdf/widgets.dart';

import '../Customerslibs/customer.dart';
import '../Invoice_libs/invoice_item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../main.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class PDFCreator {
  Customer? customer;
  final time = DateTime.now();
  PDFCreator({this.customer}) {}

  //############ #Functions  ############

  pw.Document generateInvoicePDF() {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
                width: 180,
                child: pw.Column(
                  children: [
                    invoiceHeader(),
                    invoiceListHeader(),
                    pw.SizedBox(height: 20),
                    invoiceList(),
                    pw.SizedBox(height: 50),
                    total(),
                    pw.SizedBox(height: 150),
                    pw.Text("ThankYou")
                  ],
                )),
          ); // Center
        }));
    return pdf;
  }

  Future<void> PrintInvoice() async {
    pw.Document doc = generateInvoicePDF();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Widget invoiceHeader() {
    pw.Widget header = pw.Container(
        width: 180,
        child: pw.Column(children: [
          //titel
          titel(),
          //space
          pw.SizedBox(height: 9),
          //order + permently invoice + date
          permentlyInvoice(),
          //agent name

          name(),
          //pay method
          payedMethod()
        ]));

    return header;
  }

  pw.Widget titel() {
    return pw.Container(
      child: pw.Text(
        "Lab-Med for Medical Equibments",
        style: pw.TextStyle(
          fontBold: pw.Font.helveticaBold(),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget permentlyInvoice() {
    return pw
        .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      // order
      pw.Container(
        alignment: pw.Alignment.center,
        width: 25,
        height: 25,
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(5)),
        child: pw.Text(orders.toString()),
      ),

      //permently Invoice
      pw.Container(
        child: pw.Text(
          "permently invoice",
          style: pw.TextStyle(
            fontBold: pw.Font.helveticaBold(),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      )

      //date and time
      ,
      pw.Container(
        child: pw.Column(
          children: [
            pw.Text(
              "${time.day}/${time.month}",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "${time.year}",
              style:
                  pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal),
            ),
            pw.Text(
              "${time.hour} : ${time.minute}",
              style:
                  pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal),
            ),
          ],
        ),
      ),
    ]);
  }

  pw.Widget name() {
    return pw.Container(
      height: 30,
      decoration: pw.BoxDecoration(
          border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(5)),
      padding: pw.EdgeInsets.only(left: 2),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text("name :" + customer!.name,
          style: pw.TextStyle(font: pw.Font.helveticaBold())),
    );
  }

  pw.Widget payedMethod() {
    return pw.Container(
        margin: pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Row(children: [
          pw.Text(
            "Pay method : ",
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal),
          ),
          pw.Text(
            "${customer!.payMethod}",
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          )
        ]));
  }

  pw.Widget invoiceList() {
    return pw.Container(
        width: 180,
        child: pw.Column(
            children: invoicePDFWidgetBuilder(customer!.GetSortItems())));
  }

  pw.Widget invoiceListHeader() {
    return pw.Container(
        width: 180,
        child: pw.Text(
          "      Item       price X QTY      Total",
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ));
  }

  pw.Widget invoicePDFWidget(InvoiceItem item, int order) {
    return pw.Container(
      height: 40,
      width: 180,
      decoration: pw.BoxDecoration(
        border: pw.Border.symmetric(horizontal: pw.BorderSide()),
      ),
      alignment: pw.Alignment.centerLeft,
      child: pw.Center(
        child: pw.Row(children: [
          pw.Container(child: pw.Text("${order}")),
          //NAME& COMPANY
          pw.Container(
            alignment: pw.Alignment.center,
            width: 60,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    item.name,
                    style: pw.TextStyle(
                        fontSize: 11,
                        fontBold: pw.Font.helveticaBold(),
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    item.details,
                    style: pw.TextStyle(
                        fontSize: 9,
                        fontBold: pw.Font.courier(),
                        fontWeight: pw.FontWeight.normal),
                  ),
                ]),
          ),

          //PRICE X QUANTATI
          pw.Container(
              width: 50,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      item.price.toStringAsFixed(0) + " x",
                      style: pw.TextStyle(
                          fontSize: 9,
                          fontBold: pw.Font.helvetica(),
                          fontWeight: pw.FontWeight.normal),
                    ),
                    pw.Text(
                      item.qty.toStringAsFixed(0) + "  ",
                      style: pw.TextStyle(
                          fontSize: 11,
                          fontBold: pw.Font.helveticaBold(),
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ])),

          //TOTAL
          pw.Container(
            width: 60,
            child: pw.Text(
              item.total.toStringAsFixed(0),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontBold: pw.Font.helveticaBold(),
                  fontWeight: pw.FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }

  List<pw.Widget> invoicePDFWidgetBuilder(List<InvoiceItem> items) {
    List<pw.Widget> result = [];
    int n = items.length;
    result.add(spacer(items[0].category));
    result.add(invoicePDFWidget(items[0], 1));
    int order = 1;
    for (int i = 1; i < n; i++) {
      order += 1;
      if (items[i].category != items[i - 1].category) {
        result.add(spacer(items[i].category));
      }
      result.add(invoicePDFWidget(items[i], order));
    }
    return result;
  }

  pw.Widget spacer(String text) {
    return pw.Container(
      height: 20,
      padding: pw.EdgeInsets.only(left: 2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 15,
          fontBold: pw.Font.helveticaBold(),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget total() {
    return pw.Container(
      height: 30,
      decoration: pw.BoxDecoration(
          border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(5)),
      padding: pw.EdgeInsets.only(left: 2),
      alignment: pw.Alignment.center,
      child: pw.Text(
        "Total :" + customer!.total.toStringAsFixed(0),
        style: pw.TextStyle(
          fontSize: 15,
          fontBold: pw.Font.helveticaBold(),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  void savePDF(pw.Document pdf) async {
    String path = "C:/labmedData/invoices/";
    //String name =
    //    "${time.year}_${time.month}_${time.day}___${orders}____${customer!.name}____${customer!.total}.pdf";
    String name = "item.pdf";
    final file = File(path + name);
    await file.writeAsBytes(await pdf.save());
    await Printing.layoutPdf(
        format: PdfPageFormat.roll80,
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

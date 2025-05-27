import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfDetailChecklistPage extends StatelessWidget {
  final Map<String, List<String>> lstData;
  final String well;
  final String doghouse;
  final DateTime date;
  final String title;
  const PdfDetailChecklistPage(
    this.lstData,
    this.well,
    this.doghouse,
    this.date,
    this.title, // add title parameter
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final font = pw.Font.ttf(await rootBundle.load('fonts/NotoSans-Regular.ttf'));
    final logo  = await rootBundle.load('images/logoDVL.png');
    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    final Uint8List byteList = logo.buffer.asUint8List();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 2, color: PdfColors.blueAccent),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        title,
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "Well: $well",
                      style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey800),
                    ),
                    pw.Text(
                      "Doghouse: $doghouse",
                      style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey800),
                    ),
                    pw.Text(
                      "Date: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
                      style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey800),
                    ),
                  ],
                ),
                pw.Container(
                  width: 60,
                  height: 60,
                  // decoration: pw.BoxDecoration(
                  //   color: PdfColors.blue50,
                  //   //borderRadius: pw.BorderRadius.circular(30),
                  // ),
                  alignment: pw.Alignment.center,
                  child: pw.Image(
                    pw.MemoryImage(byteList), width: 65,
                    height: 65,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),
          // Checklist sections
          ...lstData.entries.expand((entry) {
            final items = entry.value;
            final itemsPerCol = (items.length / 3).ceil();
            final columns = List.generate(3, (col) {
              final start = col * itemsPerCol;
              final end = (col + 1) * itemsPerCol;
              final colItems = items.sublist(
                start,
                end > items.length ? items.length : end,
              );
              return pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (var item in colItems)
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 8,
                            height: 8,
                            margin: const pw.EdgeInsets.only(top: 5, right: 6),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.blueAccent,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              item,
                              style: pw.TextStyle(font: font, fontSize: 13, color: PdfColors.grey900),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            });

            return [
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 16, bottom: 8),
                padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  entry.key,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: columns,
              ),
              pw.Divider(height: 32, thickness: 0.5, color: PdfColors.grey300),
            ];
          }),
          // Footer
          pw.Spacer(),
          pw.Divider(thickness: 1, color: PdfColors.blue50),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Generated by Checklist App",
              style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final String text;
  const PdfPreviewPage(this.text, {super.key});

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

    //final ByteData bytes = await rootBundle.load('assets/phone.png');
    //final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Header(text:"CHECKLIST", level: 1, textStyle: pw.TextStyle(font: font, fontSize: 30)),
              
                  //pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.fitHeight, height: 100, width: 100)
                ]
              ),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Paragraph(text: text.isNotEmpty ? text : "No content", style: pw.TextStyle(font: font, fontSize: 20)),
            ]
          );
        }
      )
    );
    return pdf.save();
  }
}
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String? qrCode;
  bool _dialogShown = false; // Add this flag
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  void _handleBarcode(BarcodeCapture capture) {
    final Barcode? barcode =
        capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    if (barcode?.rawValue != null && !_dialogShown) {
      setState(() {
        qrCode = barcode!.rawValue;
        _dialogShown = true;
      });
      // Optionally stop the camera
      // cameraController.stop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.qr_code_2, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Quét được thiết bị'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thiết bị:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                barcode?.rawValue ?? '',
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text('Bạn có muốn thêm thiết bị này vào checklist?'),
            ],
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text('Huỷ'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _dialogShown = false;
                });
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('Thêm vào checklist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _dialogShown = false;
                });
                Navigator.of(context).pop(qrCode);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: _handleBarcode,
      ),
    );
  }
}

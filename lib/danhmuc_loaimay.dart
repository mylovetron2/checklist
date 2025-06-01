import 'dart:convert';
import 'package:app_quanly_bomdau/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_quanly_bomdau/checklist_plt.dart';
import 'package:app_quanly_bomdau/model/detail_checklist.dart';
import 'package:app_quanly_bomdau/pdf_detail_checklist_screen.dart';
import 'package:app_quanly_bomdau/model/danhmuc_loai_may.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';

Future<List<DanhMucLoaiMay>> fetchDanhMucLoaiMay() async {
  final url = Uri.parse(
      'https://us-central1-checklist-447fd.cloudfunctions.net/fetchLoaiMay');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data
            .map(
                (item) => DanhMucLoaiMay.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception(
          'Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API: $e');
    return <DanhMucLoaiMay>[];
  }
}

class DanhMucLoaiMayScreen extends StatefulWidget {
  final Checklist checklist;
  const DanhMucLoaiMayScreen({super.key, required this.checklist});

  @override
  State<DanhMucLoaiMayScreen> createState() => _DanhMucLoaiMayScreenState();
}

class _DanhMucLoaiMayScreenState extends State<DanhMucLoaiMayScreen> {
  late Future<List<DanhMucLoaiMay>> _futureDanhMucLoaiMay;
  late Future<List<DetailCheckList>> _futureDetailCheckList;
  Map<String, List<String>> lstData = {};
  String text = '';

  @override
  void initState() {
    super.initState();
    _futureDanhMucLoaiMay = fetchDanhMucLoaiMay();
    _futureDetailCheckList =
        getDetailCheckListById(widget.checklist.id.toString());

    _futureDetailCheckList.then((onValue) {
      if (onValue.isNotEmpty) {
        final Map<String, List<String>> tempMap = {};
        for (var danhMucMay in onValue) {
          tempMap.putIfAbsent(danhMucMay.tenLoaiMay, () => []);
          tempMap[danhMucMay.tenLoaiMay]!
              .add('${danhMucMay.tenMay} (${danhMucMay.serialNumber})');
        }
        setState(() {
          lstData = tempMap;
          text = customLstDataToText(lstData);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DanhMucLoaiMay>>(
      future: _futureDanhMucLoaiMay,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: customAppBar(context, widget.checklist),
            body: Center(child: Text('${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: customAppBar(context, widget.checklist),
            body: const Center(child: Text('Không có dữ liệu')),
          );
        }
        final danhMucLoaiMays = snapshot.data!;
        return Scaffold(
          appBar: customAppBar(context, widget.checklist),
          body: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: danhMucLoaiMays.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final loaiMay = danhMucLoaiMays[index];
              return ChecklistCard(
                loaiMay: loaiMay,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PLT_page(
                        idDanhMucCheckList: widget.checklist.id.toString(),
                        idLoaiMay: int.parse(loaiMay.idLoaiMay),
                        tenLoaiMay: loaiMay.tenLoai,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  AppBar customAppBar(BuildContext context, Checklist checklist) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 4,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Checklist',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            '${_formatDate(checklist.date)} - ${checklist.well}',
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'refresh') {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DanhMucLoaiMayScreen(
                    checklist: checklist,
                  ),
                ),
              );
            }
            if (value == 'scanner') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRCodeScreen(),
                ),
              );
            }
            if (value == 'print') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfDetailChecklistPage(
                    lstData,
                    checklist.well,
                    checklist.doghouse,
                    DateTime.parse(checklist.date),
                    "CHECKLIST",
                  ),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'scanner',
              child: ListTile(
                leading: Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
                title: Text('QR code'),
              ),
            ),
            PopupMenuItem(
              value: 'print',
              child: ListTile(
                leading: Icon(Icons.print, color: Colors.green),
                title: Text('In Checklist'),
              ),
            ),
            PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh, color: Colors.orange),
                title: Text('Làm mới'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String date) {
    final d = DateTime.parse(date);
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class ChecklistCard extends StatelessWidget {
  final DanhMucLoaiMay loaiMay;
  final VoidCallback onTap;
  const ChecklistCard({super.key, required this.loaiMay, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.checklist, color: Colors.white),
        ),
        title: Text(
          loaiMay.tenLoai,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        subtitle: loaiMay.ghiChu.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  loaiMay.ghiChu,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: onTap,
      ),
    );
  }
}

Future<List<DetailCheckList>> getDetailCheckListById(
    String idDanhMucChecklist) async {
  final url = Uri.parse(
      'https://us-central1-checklist-447fd.cloudfunctions.net/getFetchDetailCheckListById?id_danhmuc_checklist=$idDanhMucChecklist');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data
            .map((item) =>
                DetailCheckList.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception(
          'Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API detail_checklist_api: $e');
    return <DetailCheckList>[];
  }
}

String customLstDataToText(Map<String, List<String>> lstData,
    {int itemsPerLine = 2}) {
  return lstData.entries.map((entry) {
    final values = entry.value;
    final buffer = StringBuffer('${entry.key}\n');
    for (int i = 0; i < values.length; i += itemsPerLine) {
      buffer.writeln(values.skip(i).take(itemsPerLine).join('\t'));
    }
    return buffer.toString().trimRight();
  }).join('\n');
}

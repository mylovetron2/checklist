import 'dart:convert';
import 'package:app_quanly_bomdau/pdf_detail_checklist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:app_quanly_bomdau/model/danhmuc_may.dart';
import 'package:flutter/material.dart';

class KhoTong extends StatefulWidget {
  const KhoTong({super.key});

  @override
  State<KhoTong> createState() => _KhoTongState();
}

class _KhoTongState extends State<KhoTong> {
  late Future<List<DanhMucMay>> fMayKhoTong;
  Map<String, List<String>> lstData = {};
  Map<String, List<String>> filteredData = {};
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fMayKhoTong = fetchViewOnShore();
    fMayKhoTong.then((danhMucMayList) {
      final Map<String, List<String>> tempMap = {};
      for (var danhMucMay in danhMucMayList) {
        tempMap.putIfAbsent(danhMucMay.tenLoaiMay, () => []);
        tempMap[danhMucMay.tenLoaiMay]!
            .add('${danhMucMay.tenMay}${danhMucMay.serialNumber}');
      }
      setState(() {
        lstData = tempMap;
        filteredData = Map.from(lstData);
      });
    }).catchError((error) {
      print('Error converting futureDanhMucMay to options: $error');
    });
  }

  void _filterData(String query) {
    final lowerQuery = query.toLowerCase();
    final Map<String, List<String>> temp = {};
    lstData.forEach((loaiMay, mayList) {
      // Lọc theo loại máy hoặc từng máy
      if (loaiMay.toLowerCase().contains(lowerQuery)) {
        temp[loaiMay] = List.from(mayList);
      } else {
        final filteredMay = mayList
            .where((may) => may.toLowerCase().contains(lowerQuery))
            .toList();
        if (filteredMay.isNotEmpty) {
          temp[loaiMay] = filteredMay;
        }
      }
    });
    setState(() {
      searchQuery = query;
      filteredData = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kho Tổng'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'print') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfDetailChecklistPage(
                        filteredData, '', '', DateTime.now(), 'Kho Tổng'),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'print',
                child: Text('Print'),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm loại máy, tên máy hoặc serial...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterData,
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : ListView(
                    padding: const EdgeInsets.all(8),
                    children: filteredData.entries.map((entry) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.blueAccent,
                            ),
                          ),
                          children: entry.value
                              .map((may) => ListTile(
                                    title: Text(
                                      may,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    leading: const Icon(Icons.memory,
                                        color: Colors.blueAccent),
                                    tileColor: Colors.blue[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.blue[50],
    );
  }
}

Future<List<DanhMucMay>> fetchViewOnShore() async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://us-central1-checklist-447fd.cloudfunctions.net/fetchViewOnShore'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => DanhMucMay.fromJson(item)).toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e);
    return <DanhMucMay>[];
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_quanly_bomdau/checklist_insert.dart';
import 'package:app_quanly_bomdau/danhmuc_loaimay.dart';
import 'package:app_quanly_bomdau/khotong_screen.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';
import 'package:app_quanly_bomdau/model/danhmuc_may.dart';
import 'package:app_quanly_bomdau/pdf_detail_checklist_screen.dart';

class DanhMuucCheckList extends StatefulWidget {
  const DanhMuucCheckList({super.key});

  @override
  State<DanhMuucCheckList> createState() => _DanhMuucCheckListState();
}

class _DanhMuucCheckListState extends State<DanhMuucCheckList> {
  late Future<List<Checklist>> _futureChecklist;
  late Future<List<DanhMucMay>> _futureDanhMucMayOnShore;
  Map<String, List<String>> lstData = {};
  String text = '';

  @override
  void initState() {
    super.initState();
    _futureChecklist = fetchCheckList();
    _futureDanhMucMayOnShore = fetchViewOnShore();
    _futureDanhMucMayOnShore.then((danhMucMayList) {
      final Map<String, List<String>> tempMap = {};
      for (var may in danhMucMayList) {
        tempMap.putIfAbsent(may.tenLoaiMay, () => []);
        tempMap[may.tenLoaiMay]!.add('${may.tenMay}${may.serialNumber}');
      }
      setState(() {
        lstData = tempMap;
        text = customLstDataToText(lstData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Checklist>>(
      future: _futureChecklist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu'));
        }
        final checklists = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Checklist',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            ),
            leading: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: Colors.white,
              onSelected: (value) {
                if (value == 'KhoTong') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KhoTong()),
                  );
                } else if (value == 'InKhoTong') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfDetailChecklistPage(
                          lstData, '', '', DateTime.now(), 'Kho Tổng'),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'KhoTong', child: Text('Kho Tổng')),
                //const PopupMenuItem(value: 'InKhoTong', child: Text('In Kho Tổng')),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _futureChecklist = fetchCheckList();
              });
              await Future.delayed(const Duration(seconds: 2));
            },
            child: CustomListView(checklists: checklists),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChecklistInsertForm()),
              );
              // Nếu thêm thành công (có thể trả về true từ ChecklistInsertForm), reload lại danh sách
              if (result == true) {
                setState(() {
                  _futureChecklist = fetchCheckList();
                });
              }
            },
            tooltip: 'Thêm mới',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class CustomListView extends StatelessWidget {
  final List<Checklist> checklists;
  const CustomListView({super.key, required this.checklists});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: checklists.length,
      itemBuilder: (context, index) {
        return createViewItem(checklists[index], context);
      },
    );
  }
}

Widget createViewItem(Checklist checklist, BuildContext context) {
  return Card(
    elevation: 8,
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DanhMucLoaiMayScreen(checklist: checklist),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
              Colors.teal.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          title: Text(
            checklist.well,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.7,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${DateTime.parse(checklist.date).day}/${DateTime.parse(checklist.date).month}/${DateTime.parse(checklist.date).year}',
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Doghouse: ${checklist.doghouse}',
                  style: const TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                icon: const Icon(Icons.print,
                    color: Colors.greenAccent, size: 26),
                tooltip: 'Print',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Print checklist: ${checklist.well}')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 26),
                tooltip: 'Delete',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Checklist'),
                      content: const Text(
                          'Are you sure you want to delete this checklist?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(ctx)
                                .pop(); // Đóng dialog xác nhận trước
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );
                            final success = await deleteChecklist(checklist.id);
                            Navigator.of(context).pop(); // Đóng progress dialog

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Checklist deleted successfully'
                                      : 'Failed to delete checklist ${checklist.id}',
                                ),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                              ),
                            );

                            if (success && context.mounted) {
                              final state = context.findAncestorStateOfType<
                                  _DanhMuucCheckListState>();
                              state?.setState(() {
                                state._futureChecklist = fetchCheckList();
                              });
                            }
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  );
                  if (confirm == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Deleted checklist: ${checklist.well}')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<List<Checklist>> fetchCheckList() async {
  final url = Uri.parse(
      'https://us-central1-checklist-447fd.cloudfunctions.net/fetchCheckList');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data
            .map((item) => Checklist.fromJson(item as Map<String, dynamic>))
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
    return <Checklist>[];
  }
}

Future<List<DanhMucMay>> fetchViewOnShore() async {
  try {
    final response = await http.get(Uri.parse(
        'https://us-central1-checklist-447fd.cloudfunctions.net/fetchViewOnShore'));
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

Future<bool> deleteChecklist(String checklistId) async {
  final url = Uri.parse('https://deletechecklist-nyeo6rl4xa-uc.a.run.app');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'checklist_id': checklistId}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['status'] == 'success';
    } else {
      return false;
    }
  } catch (e) {
    print('Error deleting checklist: $e');
    return false;
  }
}

/// Chuyển Map<String, List<String>> thành chuỗi đẹp để xuất PDF hoặc hiển thị
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

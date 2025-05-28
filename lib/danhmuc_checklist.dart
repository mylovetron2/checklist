import 'dart:convert';
import 'package:app_quanly_bomdau/checklist_insert.dart';
import 'package:app_quanly_bomdau/danhmuc_loaimay.dart';
import 'package:app_quanly_bomdau/khotong_screen.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';
import 'package:app_quanly_bomdau/model/danhmuc_may.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// Ensure the import for PdfDetailChecklistScreen exists and is correct
import 'package:app_quanly_bomdau/pdf_detail_checklist_screen.dart';


class CustomListView extends StatelessWidget {
  //final List<DanhMucMay> danhMucMayOnShore;
  final List<Checklist> checklists;

  const CustomListView({
    super.key,
    required this.checklists,
    //required this.danhMucMayOnShore,
  });

  
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: checklists.length,
      itemBuilder: (context, index) {
       return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              //MaterialPageRoute(builder: (context) => TypeEquipments(checklist: checklists[index],)),
              MaterialPageRoute(builder: (context) => DanhMucLoaiMayScreen(checklist: checklists[index],)),
            );
          },
          child: createViewItem(checklists[index], context),
        );
      },
      
    );
  }
}

Widget createViewItem(Checklist checklist, BuildContext context) {
  return Card(
    elevation: 8,
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Doghouse: ${checklist.doghouse}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                icon: const Icon(Icons.print, color: Colors.greenAccent, size: 26),
                tooltip: 'Print',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Print checklist: ${checklist.well}')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
                tooltip: 'Delete',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Checklist'),
                      content: const Text('Are you sure you want to delete this checklist?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop(false);
                            final success = await deleteChecklist(checklist.id);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Checklist deleted successfully')),
                              );
                              if (context.mounted) {
                                final state = context.findAncestorStateOfType<_DanhMuucCheckListState>();
                                state?.setState(() {
                                  state._futureChecklist = fetchCheckList();
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete checklist ${checklist.id}')),
                              );
                            }
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted checklist: ${checklist.well}')),
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
  //final url =  Uri.parse('http://diavatly.com/checklist/api/danhmuc_checklist_api.php');
  final url =  Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/fetchCheckList');
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //print(response.body);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response contains a "data" key
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => Checklist.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API: $e');
    return <Checklist>[];
  }
}


class DanhMuucCheckList extends StatefulWidget {
  const DanhMuucCheckList({super.key});

  @override
  State<DanhMuucCheckList> createState() => _DanhMuucCheckListState();
}

class _DanhMuucCheckListState extends State<DanhMuucCheckList> {
  late Future<List<Checklist>> _futureChecklist;
  late final Future<List<DanhMucMay>> _danhMucMayOnShore;
  Map<String, List<String>> lstData={};
  String text = '';
   @override
  void initState() {
    super.initState();
      _futureChecklist = fetchCheckList();
      _danhMucMayOnShore = fetchViewOnShore();
      _danhMucMayOnShore.then((onValue) {
      List<String> lstTemp = [];
      
      if (onValue.isNotEmpty) {
        lstData = {};
      for (var danhMucMay in onValue) {
        if (!lstData.containsKey(danhMucMay.tenLoaiMay)) {
          lstData[danhMucMay.tenLoaiMay] = []; // Create a new list for the key if it doesn't exist
        }
        lstData[danhMucMay.tenLoaiMay]!.add(danhMucMay.tenMay+danhMucMay.serialNumber); // Add the serial number to the list
      }
        print('DEBUG lstData: $lstData'); // Debug print statement
        setState(() {
                 
          //final merged = mergeLst(lstData.entries.toList());
           //text = customLstDataToText(merged);
          text = customLstDataToText(lstData);

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Checklist>>(
      future: _futureChecklist, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Checklist> checklists = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(
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
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
              ),
              leading:
                PopupMenuButton<String>(
                  // Adjust the offset to move the menu to the left
                icon: Icon(Icons.more_vert, color: Colors.white),
                color: Colors.white, // Set the background color to white
                onSelected: (value) {
                  // Handle menu item selection
                  if (value == 'KhoTong') {
                  // Navigate to settings page or perform action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KhoTong()),
                  );
                  } else if (value == 'InKhoTong') {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PdfDetailChecklistPage(lstData, '', '', DateTime.now(), 'Kho Tổng')),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                  PopupMenuItem(
                    value: 'KhoTong',
                    child: Text('Kho Tổng'),
                  ),
                  PopupMenuItem(
                    value: 'InKhoTong',
                    child: Text('In Kho Tổng'),
                  ),
                  ];
                },
                ),
              
              
            ),
            
            body: RefreshIndicator(
              onRefresh: () async {
              // Add your refresh logic here
              setState(() {
                _futureChecklist = fetchCheckList();
              });
              await Future.delayed(Duration(seconds: 2));
              },
              child: CustomListView(checklists: checklists),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChecklistInsertForm()),
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Future<bool> deleteChecklist(String checklistId) async {
  final url = Uri.parse(
      //'https://us-central1-checklist-447fd.cloudfunctions.net/deleteChecklist');
      'https://deletechecklist-nyeo6rl4xa-uc.a.run.app');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'checklist_id': checklistId}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return true;
      }
      //return jsonResponse['success'] == true;
      return false;
    } else {
      return false;
    }
  } catch (e) {
    print('Error deleting checklist: $e');
    return false;
  }
}

Future<List<DanhMucMay>> fetchViewOnShore() async {
     try {
      final response = await http.get(Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/fetchViewOnShore'));
      //print(response.body);
      if (response.statusCode == 200) {
       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if(jsonResponse.containsKey('data')) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => DanhMucMay.fromJson(item)).toList();
          //print('Data: $data');
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
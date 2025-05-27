import 'dart:convert';
import 'package:app_quanly_bomdau/checklist_plt.dart';
import 'package:app_quanly_bomdau/model/detail_checklist.dart';
import 'package:app_quanly_bomdau/pdf_detail_checklist_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_quanly_bomdau/model/danhmuc_loai_may.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';

Future<List<DanhMucLoaiMay>> fetchDanhMucLoaiMay() async {
  final url = Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/fetchLoaiMay');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => DanhMucLoaiMay.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
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
  Map<String, List<String>> lstData={};
  String text='';
  @override
  void initState() {
    super.initState();
    _futureDanhMucLoaiMay = fetchDanhMucLoaiMay();
    _futureDetailCheckList = getDetailCheckListById(widget.checklist.id.toString());
    
    _futureDetailCheckList.then((onValue) {
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
          //text = detailCheckListToText(onValue);
          
          final merged = mergeLst(lstData.entries.toList());
           text = customLstDataToText(merged);
           //text = lstDataToText(lstData);

        });
      }
    });
    //text=detailCheckListToText(_futureDetailCheckList as List<DetailCheckList>);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DanhMucLoaiMay>>(
      future: _futureDanhMucLoaiMay,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DanhMucLoaiMay> danhMucLoaiMays = snapshot.data!;
          return Scaffold(
            appBar: customAppBar(context, widget.checklist.id, widget.checklist.date, widget.checklist.well, widget.checklist.doghouse),
            body: ListView.builder(
              itemCount: danhMucLoaiMays.length,
              itemBuilder: (context, index) {
                final loaiMay = danhMucLoaiMays[index];
                return InkWell(
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
                  child: Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      title: Text(
                        loaiMay.tenLoai,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        loaiMay.ghiChu,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  AppBar customAppBar(BuildContext context, String id, String date, String well, String doghouse) {
  return AppBar(
      centerTitle: true,
      title: Text('Checklist', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.blue,
      leading: IconButton(
       onPressed: () {
        Navigator.pop(context);
       },
       icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
       PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onSelected: (value) {
          // Handle menu actions here
          if (value == 'refresh') {
           // Example: refresh the page
           Navigator.pop(context);
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DanhMucLoaiMayScreen(
               checklist: Checklist(
                id: id,
                date: date,
                well: well,
                doghouse: doghouse,
               ),
              ),
            ),
           );
          }
          // Add more actions if needed
          if (value == 'print') {
           // Example: navigate to print screen
           Navigator.push(
            context,
            MaterialPageRoute(
             builder: (context) => PdfDetailChecklistPage(lstData, well, doghouse, DateTime.parse(date),"CHECKLIST"),
            ),
           );
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
           value: 'print',
           child: Text('Print'),
          ),
          PopupMenuItem(
           value: 'refresh',
           child: Text('Refresh'),
          ),
          // Add more menu items here if needed
          
        ],
       ),
      ],
      bottom: PreferredSize(
       preferredSize: Size.fromHeight(30),
       child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SizedBox(height: 5),
           Align(
            alignment: Alignment.center,
            child: Text(
              '${DateTime.parse(date).day}/${DateTime.parse(date).month}/${DateTime.parse(date).year}',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
           ),
           Text(
            '-$well',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
           ),
           // Text(
           //   '-$doghouse',
           //   style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
           // ),
          ],
        ),
       ),
      ),
    );
 }

}



Future<List<DetailCheckList>> getDetailCheckListById(String idDanhMucChecklist) async {
  
  //final url = Uri.parse('http://diavatly.com/checklist/api/detail_checklist_api.php');
  final url = Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/getFetchDetailCheckListById?id_danhmuc_checklist=$idDanhMucChecklist');
  
  //final body = jsonEncode({'action': 'SELECT_BY_ID', 'id_danhmuc_checklist': idDanhMucChecklist});
  //final body = jsonEncode({'id_danhmuc_checklist': idDanhMucChecklist});

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //print(response.body);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response contains a "data" key
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => DetailCheckList.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API detail_checklist_api: $e');
    return <DetailCheckList>[];
  }
}

String optionsToText(Map<String, List<String>> options) {
  return options.entries
      .map((entry) => '${entry.key}: ${entry.value.join(", ")}')
      .join('\n');
}

String detailCheckListToText(List<DetailCheckList> details) {
  return details
      .map((item) => '${item.tenMay}: ${item.serialNumber}') // Adjust fields as needed
      .join('\n');
}

String lstDataToText(Map<String, List<String>> lstData) {
  return lstData.entries
      .map((entry) => '${entry.key}: ${entry.value.join(", ")}')
      .join('\n');
}

// String customLstDataToText(Map<String, List<String>> lstData) {
//   return lstData.entries.map((entry) {
//     return '${entry.key}\n${entry.value.join(" ")}';
//   }).join('\n');
// }

String customLstDataToText(Map<String, List<String>> lstData, {int itemsPerLine = 2}) {
  return lstData.entries.map((entry) {
    final values = entry.value;
    final buffer = StringBuffer('${entry.key}\n\n');
    for (int i = 0; i < values.length; i += itemsPerLine) {
      buffer.writeln(
        values.skip(i).take(itemsPerLine).join('\t\t\t\t')
      );
    }
    return buffer.toString().trimRight();
  }).join('\n\n\n');
}

Map<String, List<String>> mergeLst(List<MapEntry<String, List<String>>> lst) {
  final Map<String, List<String>> merged = {};
  for (var entry in lst) {
    merged.putIfAbsent(entry.key, () => []);
    merged[entry.key]!.addAll(entry.value);
  }
  return merged;
}
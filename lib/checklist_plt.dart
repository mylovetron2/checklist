import 'dart:convert';
import 'package:app_quanly_bomdau/content_widget.dart';
import 'package:app_quanly_bomdau/model/danhmuc_may.dart';
import 'package:app_quanly_bomdau/model/detail_checklist.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PLT_page extends StatefulWidget {
  const PLT_page({super.key, required this.idDanhMucCheckList, required this.idLoaiMay, required this.tenLoaiMay});
  //final List<DetailCheckList> detailChecklists;
  final String idDanhMucCheckList;
  final int idLoaiMay;
  final String tenLoaiMay;

  @override
  State<PLT_page> createState() => _PLT_pageState();
}

class _PLT_pageState extends State<PLT_page> {


  int tag = 3;
  
  // multiple choice value
  List<String> tags = [];

  late Future<List<DetailCheckList>> futureTags;
  late Future<List<DanhMucMay>> futureDanhMucMay;
  Map<String, List<String>> options={};

  @override
  void initState() {
    super.initState();
   // Fetch data from the API
    futureDanhMucMay = getDanhMucMayApi(widget.idLoaiMay);
    futureDanhMucMay.then((danhMucMayList) {
    setState(() {
      // Convert DanhMucMay to options
      options = {};
      for (var danhMucMay in danhMucMayList) {
        if (!options.containsKey(danhMucMay.tenMay)) {
          options[danhMucMay.tenMay] = []; // Create a new list for the key if it doesn't exist
        }
        options[danhMucMay.tenMay]!.add(danhMucMay.serialNumber); // Add the serial number to the list
      }
    });
  }).catchError((error) {
    print('Error converting futureDanhMucMay to options: $error');
  });
 
  futureTags = getDetailCheckListById(widget.idDanhMucCheckList)
    ..then((detailCheckList) {
      print('Fetched futureTags: $detailCheckList'); // Debugging output
    }).catchError((error) {
      print('Error fetching futureTags: $error'); // Debugging output
    });
  
  futureTags.then((detailCheckList) {
    setState(() {
      tags = detailCheckList.map((item) => item.serialNumber).toList();
      print('Converted futureTags to tags: $tags'); // Debugging output
    });
  }).catchError((error) {
    print('Error converting futureTags to tags: $error');
  });    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4.0,
        title: Text(
            widget.tenLoaiMay,
          style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
                showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                );
                await callSelectInsertApi(widget.idDanhMucCheckList, tags);
                Navigator.of(context).pop(); // Close the dialog
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: Row(
                  children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Lưu thành công!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                    //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ],
                ),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.green, width: 2),
                ),
                duration: Duration(seconds: 2),
                )
              
              );
            },
            icon: Icon(Icons.save, color: Colors.white, size: 30.0),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                 
                            ...options.entries.map((entry) => Content(
                              title: entry.key,
                              child: ChipsChoice<String>.multiple(
                                value: tags,
                                onChanged: (val) => setState(() => tags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: entry.value,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceCheckmark: true,
                                textDirection: TextDirection.ltr,
                                wrapped: true,
                                choiceStyle: C2ChipStyle.filled(
                                  foregroundStyle: const TextStyle(fontSize: 20),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  selectedStyle: C2ChipStyle.filled(),
                                ),
                              ),
                            ))
                           
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<DanhMucMay>> getDanhMucMayApi(int idLoaiMay) async {
  //final url = Uri.parse('http://diavatly.com/checklist/api/danhmuc_may_api.php');
  final url = Uri.parse('https://fetchdanhmucmay-nyeo6rl4xa-uc.a.run.app?id_loai_may=$idLoaiMay');
 
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //print(response.body);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response contains a "data" key
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => DanhMucMay.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API: $e');
    return <DanhMucMay>[];
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

Future<bool> callSelectInsertApi(String idDanhmucChecklist, List<String> tags) async {
  final url = Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/insertDetailCheckList');
  try{
    final body = {
      "action": "SELECT_INSERT",
      "id_danhmuc_checklist": idDanhmucChecklist,
      "ids": tags.toString(), // Pass the list directly without converting to a string
    };

    final response = await http.post(url, body:body);
    if (response.statusCode == 200) {
      //print(response.body);
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response contains a "data" key
      if (jsonResponse.containsKey('data')) {
        final List<dynamic> data = jsonResponse['data'];
        print('Data inserted successfully: $data');
        return true;
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API detail_checklist_api: $e');
    return false;
  }
}

String optionsToText(Map<String, List<String>> options) {
  return options.entries
      .map((entry) => '${entry.key}: ${entry.value.join(", ")}')
      .join('\n');
}
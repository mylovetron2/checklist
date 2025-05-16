import 'dart:convert';
import 'package:app_quanly_bomdau/content_widget.dart';
import 'package:app_quanly_bomdau/model/danhmuc_may.dart';
import 'package:app_quanly_bomdau/model/detail_checklist.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dio/dio.dart';
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
  // Map<String, List<String>> options = {'MPL 022': ['021293', '021219','011098'],
  //                                      'MPL 030': ['10024935'],
  //                                      'MPL 024':['020220','031353','Hunting SPS','LEE-509019'],
  //                                      'XTU 004':['218421','215996','217200','217201','AJG00068'],
  //                                      'QPC 004':['10427','021000','22801','212158','22550','212268','031355','021016','021017','Print 920',],

  //                                     };

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
        if (!options.containsKey(danhMucMay.tenMay  )) {
          options[danhMucMay.tenMay] = []; // Create a new list for the key if it doesn't exist
        }
        options[danhMucMay.tenMay]!.add(danhMucMay.serialNumber); // Add the serial number to the list
      }

      //print('Converted options: $options'); // Debugging output
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
            '${widget.tenLoaiMay}',
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
            onPressed: () {
              callSelectInsertApi(widget.idDanhMucCheckList, tags);
            },
            icon: Icon(Icons.cloud_sync, color: Colors.white, size: 40.0),
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
// Future<List<DanhMucMay>> getDanhMucMayApiWithParam(String param) async {
//   final url = Uri.parse('http://diavatly.com/checklist/api/danhmuc_may_api.php');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({'param': param}); // Include the parameter in the request body

//   try {
//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

//       // Check if the response contains a "data" key
//       if (jsonResponse.containsKey('data')) {
//         final List<dynamic> data = jsonResponse['data'];
//         return data.map((item) => DanhMucMay.fromJson(item as Map<String, dynamic>)).toList();
//       } else {
//         throw Exception('Invalid API response: Missing "data" key');
//       }
//     } else {
//       throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching data from API with parameter: $e');
//     return <DanhMucMay>[];
//   }
// }


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

void callSelectInsertApi(String idDanhmucChecklist, List<String> tags) async {
  //print(tags);
  //final url = Uri.parse('http://diavatly.com/checklist/api/temp_api.php');
  final url = Uri.parse('https://us-central1-checklist-447fd.cloudfunctions.net/insertDetailCheckList');
  
  try{
    // final response = await http.post(url, body: {
    //   "action": "SELECT_INSERT", 
    //   "id_danhmuc_checklist": idDanhmucChecklist, 
    //   "ids":tags.toString(), 
    // });
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
      } else {
        throw Exception('Invalid API response: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load data from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data from API detail_checklist_api: $e');
  }
}

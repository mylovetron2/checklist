import 'dart:convert';
import 'package:app_quanly_bomdau/pdf_screen.dart';
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
  List<String> lstTemp = [];
  Map<String, List<String>> lstData={};
    
  @override
  void initState() {
    super.initState();
    fMayKhoTong = fetchViewOnShore();
    fMayKhoTong.then((danhMucMayList) {
    setState(() {
      // Convert DanhMucMay to options
      lstData = {};
      for (var danhMucMay in danhMucMayList) {
        if (!lstData.containsKey(danhMucMay.tenLoaiMay)) {
          lstData[danhMucMay.tenLoaiMay] = []; // Create a new list for the key if it doesn't exist
        }
        lstData[danhMucMay.tenLoaiMay]!.add(danhMucMay.tenMay+danhMucMay.serialNumber); // Add the serial number to the list
      }

      //print('Converted options: $options'); // Debugging output
    });
  }).catchError((error) {
    print('Error converting futureDanhMucMay to options: $error');
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
              // Handle menu selection here
              if (value == 'print') {
                // Navigate to the print screen or perform print action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PdfPreviewPage('Kho Tong')),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'print',
                child: Text('Print'),
              ),
              // Add more menu items here if needed
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: lstData.entries.map((entry) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            title: Text(
          entry.key,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
            ),
            children: entry.value
            .map((may) => ListTile(
              title: Text(
                may,
                style: const TextStyle(fontSize: 16),
              ),
              leading: const Icon(Icons.memory, color: Colors.blueAccent),
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
      
    );
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
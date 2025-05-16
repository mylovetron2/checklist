import 'dart:convert';
import 'package:app_quanly_bomdau/checklist_plt.dart';
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

  @override
  void initState() {
    super.initState();
    _futureDanhMucLoaiMay = fetchDanhMucLoaiMay();
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
}


AppBar customAppBar(BuildContext context, String id, String date, String well, String doghouse) {
   return AppBar(
        centerTitle: true,
        title: Text('Checklist', style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
       
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


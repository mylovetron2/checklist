//import 'package:app_quanly_bomdau/checklist.dart';
//import 'package:app_quanly_bomdau/checklist2.dart';
import 'package:app_quanly_bomdau/danhmuc_checklist.dart';
import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checklist',
      theme: ThemeData(
        
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        //useMaterial3: true,
      ),
      // 
      //home: DanhMucLoaiMayScreen(checklistId: Checklist(id: 8, name: 'Sample Checklist')), // Replace with your actual Checklist object
    home: DanhMuucCheckList(),
    //home: KhoTong(), // Replace with your actual idDanhMucCheckList
    );}}
   
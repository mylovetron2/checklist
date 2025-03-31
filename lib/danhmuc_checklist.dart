import 'dart:convert';
import 'package:app_quanly_bomdau/checklist_insert.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';
import 'package:app_quanly_bomdau/type_equipments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CustomListView extends StatelessWidget {
  const CustomListView({super.key, required this.checklists});

  final List<Checklist> checklists;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: checklists.length,
      itemBuilder: (context, index) {
       return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TypeEquipments(checklist: checklists[index],)),
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
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrangeAccent, Colors.orangeAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(12),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: Text(
          checklist.well,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
                'Date: ${DateTime.parse(checklist.date).day}/${DateTime.parse(checklist.date).month}/${DateTime.parse(checklist.date).year}',
              style: TextStyle(
                fontSize: 16,fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Doghouse: ${checklist.doghouse}',
              style: TextStyle(
                fontSize: 16,fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.checklist_rtl_sharp,
            color: Colors.blueAccent,
            size: 36,
          ),
        ),
      ),
    ),
  );
}

Future<List<Checklist>> fetchCheckList() async {
  final url =  Uri.parse('http://diavatly.com/checklist/api/danhmuc_checklist_api.php');
  
 ///print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  
  
  
  
  // if (response.statusCode == 200) {
  //   List<dynamic> data = json.decode(response.body);
  //   return data.map((item) => Checklist.fromJson(item as Map<String, dynamic>)).toList();
  // } else {
  //   throw Exception('Failed to load checklist');
  // }

  //final url = Uri.parse('http://diavatly.com/checklist/api/danhmuc_may_api.php');
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
   @override
  void initState() {
    super.initState();
    _futureChecklist = fetchCheckList();
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
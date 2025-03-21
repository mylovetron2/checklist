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
    elevation: 5,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Text(
          checklist.well,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              'Date: ${checklist.date}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Doghouse: ${checklist.doghouse}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Text(
          checklist.id.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    ),
  );
}

Future<List<Checklist>> fetchCheckList() async {
  final jsonEndpoint = 'http://10.0.2.2/checklist/api/checklist_get.php';
  final response = await http.get(Uri.parse(jsonEndpoint));
 print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => Checklist.fromJson(item as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load checklist');
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
              title: Text('Checklist'),
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
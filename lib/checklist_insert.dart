import 'package:app_quanly_bomdau/danhmuc_checklist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChecklistInsertForm extends StatefulWidget {
  const ChecklistInsertForm({super.key});

  @override
  _ChecklistInsertFormState createState() => _ChecklistInsertFormState();
}

class _ChecklistInsertFormState extends State<ChecklistInsertForm> {
  final _formKey = GlobalKey<FormState>();
  
  
  final TextEditingController controllerDate = TextEditingController();  
  final TextEditingController controllerWell = TextEditingController();
  final TextEditingController controllerDoghouse = TextEditingController();
  
   @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    controllerDate.text =
      "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
 }
    
  void addData() {
    var url = Uri.parse("http://10.0.2.2/checklist/api/checklist_add.php");

    http.post(url, body: {
      "date": controllerDate.text,
      "well": controllerWell.text,
      "doghouse": controllerDoghouse.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
              title: Text(
              'New Checklist',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
          controller: controllerDate,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Date',
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                controllerDate.text =
              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
              });
            }
          },
              ),
              SizedBox(height: 16),
              TextFormField(
          controller: controllerWell,
          decoration: InputDecoration(
            labelText: 'Well',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a well';
            }
            return null;
          },
              ),
              SizedBox(height: 16),
              TextFormField(
          controller: controllerDoghouse,
          decoration: InputDecoration(
            labelText: 'Doghouse',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a doghouse';
            }
            return null;
          },
              ),
              SizedBox(height: 20),
              Center(
            child: ElevatedButton(
            onPressed: () {
             
              addData();
              Navigator.pop(
                context,
                MaterialPageRoute(
                builder: (context) => DanhMuucCheckList(),
                ),
              );
              
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            child: Text(
              'Add',
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            ),
            ),
          ),
              
            ],
          ),
        ),
          
        ),
    );
    
  }
}
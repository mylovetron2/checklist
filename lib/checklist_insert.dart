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
        title: Text('Insert Checklist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            
            TextFormField(
              controller: controllerDate,
              readOnly: true,
              decoration: InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.calendar_today),
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
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                });
              }
              },
            ),
            
                    
            TextFormField(
              controller: controllerWell,
            decoration: InputDecoration(labelText: 'Well'),
            validator: (value) {
              if (value == null || value.isEmpty) {
              return 'Please enter a well';
              }
              return null;
            },
            onSaved: (value) {
              // Save the well value
            },
            ),
            TextFormField(
              controller: controllerDoghouse,
            decoration: InputDecoration(labelText: 'Doghouse'),
            validator: (value) {
              if (value == null || value.isEmpty) {
              return 'Please enter a doghouse';
              }
              return null;
            },
            onSaved: (value) {
              // Save the doghouse value
            },
            ),
            SizedBox(height: 20),
            FloatingActionButton(
            onPressed: () {
               {
             
              // Handle the form submission logic here
              addData();
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => DanhMuucCheckList()),
              );
              }
            },
            child: Text('Insert'),
            ),]
          
          
          
        ),
                ),
    ));
  }
}
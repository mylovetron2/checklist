
import 'dart:convert';

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
    
  Future<bool> addData() async{
    //var url = Uri.parse("http://diavatly.com/checklist/api/checklist_add.php");
    var url = Uri.parse(
      "https://us-central1-checklist-447fd.cloudfunctions.net/insertCheckListPostApi");
    
    try {
      final response = await http.post(
        url,
        body: {
          "date": controllerDate.text,
          "well": controllerWell.text,
          "doghouse": controllerDoghouse.text
        },
      );
      if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        return true;
      }
      //return jsonResponse['success'] == true;
      return false;
    } else {
      return false;
    }
  } catch (e) {
    print('Error deleting checklist: $e');
    return false;
  }
   
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
            onPressed: () async {
              final success=await addData();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data added successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add data')),
                );
              }
              //addData();
              // Navigator.pop(
              //   context,
              //   MaterialPageRoute(
              //   builder: (context) => DanhMuucCheckList(),
              //   ),
              // );
             Navigator.of(context).pop();
              
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





// void addData() async{
//     //var url = Uri.parse("http://diavatly.com/checklist/api/checklist_add.php");
//     var url = Uri.parse(
//       "https://insertchecklistapi-nyeo6rl4xa-uc.a.run.app?date=${Uri.encodeComponent(controllerDate.text)}&well=${Uri.encodeComponent(controllerWell.text)}&doghouse=${Uri.encodeComponent(controllerDoghouse.text)}");
    
//     // http.post(url, body: {
//     //   "date": controllerDate.text,
//     //   "well": controllerWell.text,
//     //   "doghouse": controllerDoghouse.text
//     // });
//     try {
//       // final response = await http.post(
//       //   url,
//       //   body: jsonEncode({
//       //     "date": controllerDate.text,
//       //     "well": controllerWell.text,
//       //     "doghouse": controllerDoghouse.text,
//       //   }),
//         //headers: {"Content-Type": "application/json"},
//         final response = await http.get(url);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data added successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add data: ${response.reasonPhrase}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     }
   
//   }
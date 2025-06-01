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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    controllerDate.text =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
  }

  Future<bool> addData() async {
    final url = Uri.parse(
        "https://us-central1-checklist-447fd.cloudfunctions.net/insertCheckListPostApi");
    try {
      final response = await http.post(
        url,
        //headers: {'Content-Type': 'application/json'},
        // body: jsonEncode({
        //   "date": controllerDate.text,              body này lỗi CORDS
        //   "well": controllerWell.text,
        //   "doghouse": controllerDoghouse.text
        // }),
        body: {
          "date": controllerDate.text,
          "well": controllerWell.text,
          "doghouse": controllerDoghouse.text
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['status'] == 'success';
      }
      return false;
    } catch (e) {
      print('Error adding checklist: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Checklist',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Date Field
                  TextFormField(
                    controller: controllerDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      setState(() {
                        //   controllerDate.text =
                        //       "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Well Field
                  TextFormField(
                    controller: controllerWell,
                    decoration: InputDecoration(
                      labelText: 'Well',
                      prefixIcon: const Icon(Icons.water_drop),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a well';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Doghouse Field
                  TextFormField(
                    controller: controllerDoghouse,
                    decoration: InputDecoration(
                      labelText: 'Doghouse',
                      prefixIcon: const Icon(Icons.home_work),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a doghouse';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add Checklist',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);
                                final success = await addData();
                                setState(() => isLoading = false);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Data added successfully')),
                                  );
                                  Navigator.of(context).pop(true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Failed to add data')),
                                  );
                                }
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class BomDauWidget extends StatefulWidget {
  const BomDauWidget({super.key});

  @override
  State<BomDauWidget> createState() => _BomDauWidgetState();
}

class _BomDauWidgetState extends State<BomDauWidget> {
   String _msg="Message from API";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text('Quản lý bơm dầu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _msg,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                getThietBiAPI();
              },
              child: const Text('Get data from API'),
            ),
          ],
        ),
      ),
    );
  }
  void getThietBiAPI() async {
    String url = 'http://10.0.2.2/quanly_bomdau/thietbi_api.php';

    
      http.Response response = await http.get(Uri.parse(url));
      try {
        if (response.statusCode == 200) {
          setState(() {
            _msg = response.body;
          });
          //print(response.body);
        } else {
          print('Failed to load data');
        }
      } catch (e) {
        print('Failed to load data');
      }
    
  }
}

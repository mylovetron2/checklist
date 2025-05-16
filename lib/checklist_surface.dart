import 'package:app_quanly_bomdau/content_widget.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class MyCheckListSurface extends StatefulWidget {
  const MyCheckListSurface({super.key});

  @override
  State<MyCheckListSurface> createState() => _MyCheckListSurfaceState();
}

class _MyCheckListSurfaceState extends State<MyCheckListSurface> {
  int tag = 3;

  // multiple choice value
  List<String> tags = ['Education'];

  Map<String, List<String>> options = {
    'STIP_CPFC': ['CP26413', 'CP26591', 'CP25314', 'CP25349'],
    'HIP 002': ['001713', '001714'],
    'SHOOTING PANEL': ['0411-141', '0506-233', 'Hunting SPS', 'LEE-509019'],
    'HARD LOCK': ['W7_full', 'W7_comp', 'W8_full'],
    'PRINTREX': [
      '10427',
      '021000',
      '22801',
      '212158',
      '22550',
      '212268',
      '031355',
      '021016',
      '021017',
      'Print 920',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 4.0,
        title: const Text(
          'Wireline Surface Equipment',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...options.entries.map((entry) => Content(
                        title: entry.key,
                        child: ChipsChoice<String>.multiple(
                          value: tags,
                          onChanged: (val) => setState(() => tags = val),
                          choiceItems: C2Choice.listFrom<String, String>(
                            source: entry.value,
                            value: (i, v) => v,
                            label: (i, v) => v,
                          ),
                          choiceCheckmark: true,
                          textDirection: TextDirection.ltr,
                          wrapped: true,
                          choiceStyle: C2ChipStyle.filled(
                            foregroundStyle: const TextStyle(fontSize: 20),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            selectedStyle: C2ChipStyle.filled(),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class MyCheckLis extends StatefulWidget {
  const MyCheckLis({super.key});

  @override
  State<MyCheckLis> createState() => _MyCheckLisState();
}

class _MyCheckLisState extends State<MyCheckLis> {
  int tag = 3;

  // multiple choice value
  List<String> tags = ['Education'];

  // list of string options
  List<String> options2 = [
    '211854',
    '211856',
    '211050',
    '214193',
    '10008983',
    '10008985',
   
  ];
  List<String> options = [
    '021293',
    '021219',
    '011098',
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Checklist'),
        
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brightness_4),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Content(
                              title: 'MPL 022',
                              child: ChipsChoice<String>.multiple(
                                value: tags,
                                onChanged: (val) => setState(() => tags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: options,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceCheckmark: true,
                        //choiceStyle: C2ChipStyle.outlined(),
                         textDirection: TextDirection.ltr,
                        wrapped: true,

                        
                         choiceStyle: C2ChipStyle.filled(
                          foregroundStyle: const TextStyle(fontSize: 20),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          selectedStyle: C2ChipStyle.filled(),
                        ),



                              ),
                            ),
                            Content(
                              title: 'MIP(MCU)',
                              child: ChipsChoice<String>.multiple(
                                value: tags,
                                onChanged: (val) => setState(() => tags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: options2,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceCheckmark: true,
                        //choiceStyle: C2ChipStyle.outlined(),
                         textDirection: TextDirection.ltr,
                        wrapped: true,
                         choiceStyle: C2ChipStyle.filled(
                          foregroundStyle: const TextStyle(fontSize: 20),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          selectedStyle: C2ChipStyle.filled(),
                        ),
                              ),
                            ),
                             Content(
                              title: 'MPL 022',
                              child: ChipsChoice<String>.multiple(
                                value: tags,
                                onChanged: (val) => setState(() => tags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: options,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceCheckmark: true,
                        //choiceStyle: C2ChipStyle.outlined(),
                         textDirection: TextDirection.ltr,
                        wrapped: true,
                         choiceStyle: C2ChipStyle.filled(
                          foregroundStyle: const TextStyle(fontSize: 20),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          selectedStyle: C2ChipStyle.filled(),
                        ),
                              ),
                            ),
                            Content(
                              title: 'MIP(MCU)',
                              child: ChipsChoice<String>.multiple(
                                value: tags,
                                onChanged: (val) => setState(() => tags = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: options2,
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                ),
                                choiceCheckmark: true,
                        //choiceStyle: C2ChipStyle.outlined(),
                         textDirection: TextDirection.ltr,
                        wrapped: true,
                         choiceStyle: C2ChipStyle.filled(
                          foregroundStyle: const TextStyle(fontSize: 20),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          selectedStyle: C2ChipStyle.filled(),
                        ),
                              ),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Content extends StatefulWidget {
  final String title;
  final Widget child;

  const Content({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            // color: Colors.blueGrey[50],
            child: Text(
              widget.title,
              style: const TextStyle(
                // color: Colors.blueGrey,
                fontWeight: FontWeight.w900,
                fontSize: 25
              ),
            ),
          ),
          Flexible(fit: FlexFit.loose, child: widget.child),
        ],
      ),
    );
  }
}
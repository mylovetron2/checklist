import 'package:flutter/material.dart';

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
      elevation: 4,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          // decoration: const BoxDecoration(
          //         color: Colors.blueAccent,
          //         borderRadius: BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))
          //       ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.grey[50],
        child: Text(
          widget.title,
          style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          ),
        ),
        ),
        Flexible(fit: FlexFit.loose, child: widget.child),
      ],
      ),
    );
  }
}
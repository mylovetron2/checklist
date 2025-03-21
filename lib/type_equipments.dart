import 'package:app_quanly_bomdau/checklist_memory_surface.dart';
import 'package:app_quanly_bomdau/checklist_plt.dart';
import 'package:app_quanly_bomdau/checklist_surface.dart';
import 'package:app_quanly_bomdau/model/checklist.dart';
import 'package:flutter/material.dart';

class TypeEquipments extends StatelessWidget {
  const TypeEquipments({super.key, 
    required this.checklist,
  });

  final Checklist checklist;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     appBar: customAppBar(context, checklist.id, checklist.date, checklist.well, checklist.doghouse),
    
      body: ListView(
scrollDirection: Axis.vertical,
        children: <Widget>[
          CurvedListItem(
            title: 'Wireline surface equipment',
            time: '',
            color: Colors.red,
            nextColor: Colors.green,
            onPressed: () {
               
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCheckLis()),
              );
            
             
            },
          ),
          CurvedListItem(
            title: 'Memory surface equipment',
            time: '',
            color: Colors.green,
            nextColor: Colors.blue,
             onPressed: () {
               
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCheckListMemorySurface()),
              );
            
             
            },
          ),
          CurvedListItem(
            title: 'PLT downhole tools',
            time: '',
            color: Colors.blue,
            nextColor: Colors.orange,
             onPressed: () {
               
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PLT_page(idDanhMucCheckList: checklist.id.toString())),
              );}
          ),
          CurvedListItem(
            title: 'TCK & CBL Downhole tools',
            time: '',
            color: Colors.orange,
            nextColor: Colors.blue,
          ),
          CurvedListItem(
            title: 'Hunter PLT/RAS Downhole tools',
            time: '',
            color: Colors.blue,
            nextColor: Colors.green,
          ),
          CurvedListItem(
            title: 'Tools kit',
            time: '',
            color: Colors.green,
            nextColor: Colors.green,

          ),
         
          ]
  ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  

  final String title;
  final String time;
  //final String people;
  //final IconData icon;
  final Color color;
  final Color nextColor;
  final VoidCallback? onPressed;

   const CurvedListItem({super.key, 
    required this.title,
    required this.time,
    //required this.icon,
    //required this.people,
    required this.color,
    required this.nextColor,
    this.onPressed,
  });

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
       
        color: nextColor,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(80.0),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 32,
            top: 80.0,
            bottom: 50,
          ),
          child: Column(
             
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  time,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Row(),
              ]),
        ),
      ),
    );
  }
}

 AppBar customAppBar(BuildContext context, String id, String date, String well, String doghouse) {
   return AppBar(
        centerTitle: true,
        title: Text('Checklist', style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(Icons.cloud_sync, color: Colors.white, size: 40.0),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
            child: Container(
               margin: EdgeInsets.all(10),
            //padding: EdgeInsets.only(left: 1.0),
            // decoration: BoxDecoration(
            //   color: Colors.orange,
            //   borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20),
            //   topRight: Radius.circular(20),
            //   ),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
              SizedBox(height: 5),
                Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${DateTime.parse(date).day}/${DateTime.parse(date).month}/${DateTime.parse(date).year}',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ),
              
              //SizedBox(height: 1),
              Text(
                '$well',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              //SizedBox(height: 5),
              Text(
                '$doghouse',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              
              ],
            ),
            ),
          ),
       
      );
 }


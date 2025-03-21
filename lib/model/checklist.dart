class Checklist {
  final String id;
  final String date;
  final String well;
  final String doghouse;
  
  Checklist({
    required this.id,
    required this.date,
    required this.well,
    required this.doghouse,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id_danhmuc_checklist'],
      date: json['date'],
      well: json['well'],
      doghouse: json['doghouse'],
    );
  }
}
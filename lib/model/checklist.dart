class Checklist {
  final String id;
  final String date;
  final String well;
  final String doghouse;
  final String active;

  Checklist({
    required this.id,
    required this.date,
    required this.well,
    required this.doghouse,
    required this.active,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) {
    return Checklist(
      id: json['id_danhmuc_checklist'].toString(), // Convert to String
      date: json['date']?.toString() ??
          '', // Convert to String, default to empty string if null
      well: json['well']?.toString() ??
          '', // Convert to String, default to empty string if null
      doghouse: json['doghouse']?.toString() ??
          '', // Convert to String, default to empty string if null
      active: json['active']?.toString() ?? '',
    );
  }

  @override
  String toString() {
    return 'Checklist(id: $id, date: $date, well: $well, doghouse: $doghouse, active: $active)';
  }
}

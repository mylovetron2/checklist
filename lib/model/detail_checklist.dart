class DetailCheckList {
  final int id;
  final String idMay;
  final String tenMay;
  final String serialNumber;
  
  
  DetailCheckList({
    required this.id,
    required this.idMay,
    required this.tenMay,
    required this.serialNumber,
   
  });

  factory DetailCheckList.fromJson(Map<String, dynamic> json) {
    return DetailCheckList(
      id: json['id_danhmuc_checklist'],
      idMay: json['id_may'],
      tenMay: json['ten_may'],
      serialNumber: json['serial_number'],

    );
  }

  
}
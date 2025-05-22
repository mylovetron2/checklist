class DetailCheckList {
  final String id;
  final String tenLoaiMay;
  final String tenMay;
  final String serialNumber;
  
  
  DetailCheckList({
    required this.id,
    required this.tenLoaiMay,
    required this.tenMay,
    required this.serialNumber,
   
  });

  factory DetailCheckList.fromJson(Map<String, dynamic> json) {
    return DetailCheckList(
      id: json['id_danhmuc_checklist'].toString(), // Convert to String
      tenLoaiMay: json['ten_loai']?.toString() ?? '', // Convert to String, default to empty string if null
      tenMay: json['ten_may']?.toString() ?? '', // Convert to String, default to empty string if null
      serialNumber: json['serial_number']?.toString() ?? '', // Convert to String, default to empty string if null
    );
  }

  @override
  String toString() {
    return 'DetailCheckList(id: $id,tenLoaiMay:$tenLoaiMay, tenMay: $tenMay, serialNumber: $serialNumber)';
  }

  
}
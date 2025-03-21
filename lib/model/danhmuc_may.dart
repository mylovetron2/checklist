class DanhMucMay {
  final String idMay;
  final String tenMay;
  final String serialNumber;
  
  
  DanhMucMay({
    required this.idMay,
    required this.tenMay,
    required this.serialNumber,
    
  });

 factory DanhMucMay.fromJson(Map<String, dynamic> json) {
    return DanhMucMay(
      idMay: json['id_may'] ?? '', // Default to an empty string if null
      tenMay: json['ten_may'] ?? '', // Default to an empty string if null
      serialNumber: json['serial_number'] ?? '', // Default to an empty string if null
    );
  }
}
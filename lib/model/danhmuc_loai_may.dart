class DanhMucLoaiMay {
  final String idLoaiMay;
  final String tenLoai;
  final String ghiChu;

  DanhMucLoaiMay({
    required this.idLoaiMay,
    required this.tenLoai,
    required this.ghiChu,
  });

  factory DanhMucLoaiMay.fromJson(Map<String, dynamic> json) {
    return DanhMucLoaiMay(
      idLoaiMay: json['id_loai_may'] ?? '', // Default to an empty string if null
      tenLoai: json['ten_loai'] ?? '', // Default to an empty string if null
      ghiChu: json['ghi_chu'] ?? '', // Default to an empty string if null
    );
  }
}
class ComplaintModel {
  int? status, id, userId;
  String? message,
      aduan,
      tanggal,
      statusLaporan,
      bukti,
      createdAt,
      updatedAt;

  ComplaintModel({
    required this.status,
    required this.message,
    required this.id,
    required this.aduan,
    required this.tanggal,
    required this.statusLaporan,
    required this.bukti,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> object) {
    return ComplaintModel(
      status: object['status'],
      message: object['message'],
      id: object['data']['id'],
      aduan: object['data']['aduan'],
      tanggal: object['data']['tanggal'],
      statusLaporan: object['data']['status'],
      bukti: object['data']['bukti'],
      userId: object['data']['user_id'],
      createdAt: object['data']['created_at'],
      updatedAt: object['data']['updated_at'],
    );
  }
}

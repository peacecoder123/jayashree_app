import '../core/enums/status.dart';

class CertificateModel {
  final String id;
  final String requestedById;
  final String certificateType;
  final String? additionalDetails;
  final DateTime requestedDate;
  final RequestStatus status;

  const CertificateModel({
    required this.id,
    required this.requestedById,
    required this.certificateType,
    this.additionalDetails,
    required this.requestedDate,
    required this.status,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        id: json['id'] as String,
        requestedById: json['requestedById'] as String,
        certificateType: json['certificateType'] as String,
        additionalDetails: json['additionalDetails'] as String?,
        requestedDate: DateTime.parse(json['requestedDate'] as String),
        status: RequestStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => RequestStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'requestedById': requestedById,
        'certificateType': certificateType,
        'additionalDetails': additionalDetails,
        'requestedDate': requestedDate.toIso8601String(),
        'status': status.name,
      };

  CertificateModel copyWith({
    String? id,
    String? requestedById,
    String? certificateType,
    String? additionalDetails,
    DateTime? requestedDate,
    RequestStatus? status,
  }) =>
      CertificateModel(
        id: id ?? this.id,
        requestedById: requestedById ?? this.requestedById,
        certificateType: certificateType ?? this.certificateType,
        additionalDetails: additionalDetails ?? this.additionalDetails,
        requestedDate: requestedDate ?? this.requestedDate,
        status: status ?? this.status,
      );

  String get statusLabel {
    switch (status) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
    }
  }
}

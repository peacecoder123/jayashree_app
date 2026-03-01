import '../core/enums/status.dart';

class MouModel {
  final String id;
  final String patientName;
  final String disease;
  final String hospitalName;
  final String bloodGroup;
  final String phone;
  final String address;
  final String submittedById;
  final int patientAge;
  final DateTime submittedDate;
  final MouStatus status;

  const MouModel({
    required this.id,
    required this.patientName,
    required this.disease,
    required this.hospitalName,
    required this.bloodGroup,
    required this.phone,
    required this.address,
    required this.submittedById,
    required this.patientAge,
    required this.submittedDate,
    required this.status,
  });

  factory MouModel.fromJson(Map<String, dynamic> json) => MouModel(
        id: json['id'] as String,
        patientName: json['patientName'] as String,
        disease: json['disease'] as String,
        hospitalName: json['hospitalName'] as String,
        bloodGroup: json['bloodGroup'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        submittedById: json['submittedById'] as String,
        patientAge: json['patientAge'] as int,
        submittedDate: DateTime.parse(json['submittedDate'] as String),
        status: MouStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => MouStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'disease': disease,
        'hospitalName': hospitalName,
        'bloodGroup': bloodGroup,
        'phone': phone,
        'address': address,
        'submittedById': submittedById,
        'patientAge': patientAge,
        'submittedDate': submittedDate.toIso8601String(),
        'status': status.name,
      };

  MouModel copyWith({
    String? id,
    String? patientName,
    String? disease,
    String? hospitalName,
    String? bloodGroup,
    String? phone,
    String? address,
    String? submittedById,
    int? patientAge,
    DateTime? submittedDate,
    MouStatus? status,
  }) =>
      MouModel(
        id: id ?? this.id,
        patientName: patientName ?? this.patientName,
        disease: disease ?? this.disease,
        hospitalName: hospitalName ?? this.hospitalName,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        submittedById: submittedById ?? this.submittedById,
        patientAge: patientAge ?? this.patientAge,
        submittedDate: submittedDate ?? this.submittedDate,
        status: status ?? this.status,
      );

  String get statusLabel {
    switch (status) {
      case MouStatus.pending:
        return 'Pending';
      case MouStatus.approved:
        return 'Approved';
      case MouStatus.rejected:
        return 'Rejected';
    }
  }
}

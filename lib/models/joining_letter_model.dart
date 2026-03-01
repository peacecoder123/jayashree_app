import '../core/enums/status.dart';

class JoiningLetterModel {
  final String id;
  final String requestedById;
  final String tenureType; // Monthly or Annual
  final DateTime requestedDate;
  final String? month;
  final String? year;
  final String? generatedById;
  final RequestStatus status;

  const JoiningLetterModel({
    required this.id,
    required this.requestedById,
    required this.tenureType,
    required this.requestedDate,
    this.month,
    this.year,
    this.generatedById,
    required this.status,
  });

  factory JoiningLetterModel.fromJson(Map<String, dynamic> json) =>
      JoiningLetterModel(
        id: json['id'] as String,
        requestedById: json['requestedById'] as String,
        tenureType: json['tenureType'] as String,
        requestedDate: DateTime.parse(json['requestedDate'] as String),
        month: json['month'] as String?,
        year: json['year'] as String?,
        generatedById: json['generatedById'] as String?,
        status: RequestStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => RequestStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'requestedById': requestedById,
        'tenureType': tenureType,
        'requestedDate': requestedDate.toIso8601String(),
        'month': month,
        'year': year,
        'generatedById': generatedById,
        'status': status.name,
      };

  JoiningLetterModel copyWith({
    String? id,
    String? requestedById,
    String? tenureType,
    DateTime? requestedDate,
    String? month,
    String? year,
    String? generatedById,
    RequestStatus? status,
  }) =>
      JoiningLetterModel(
        id: id ?? this.id,
        requestedById: requestedById ?? this.requestedById,
        tenureType: tenureType ?? this.tenureType,
        requestedDate: requestedDate ?? this.requestedDate,
        month: month ?? this.month,
        year: year ?? this.year,
        generatedById: generatedById ?? this.generatedById,
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

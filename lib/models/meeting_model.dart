import '../core/enums/status.dart';

class MeetingModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final List<String> attendeeIds;
  final MeetingStatus status;
  final String? momSummary;
  final String? momSubmittedBy;

  const MeetingModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.attendeeIds,
    required this.status,
    this.momSummary,
    this.momSubmittedBy,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
        id: json['id'] as String,
        title: json['title'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        attendeeIds: List<String>.from(json['attendeeIds'] as List? ?? []),
        status: MeetingStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => MeetingStatus.scheduled,
        ),
        momSummary: json['momSummary'] as String?,
        momSubmittedBy: json['momSubmittedBy'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'attendeeIds': attendeeIds,
        'status': status.name,
        'momSummary': momSummary,
        'momSubmittedBy': momSubmittedBy,
      };

  MeetingModel copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    List<String>? attendeeIds,
    MeetingStatus? status,
    String? momSummary,
    String? momSubmittedBy,
  }) =>
      MeetingModel(
        id: id ?? this.id,
        title: title ?? this.title,
        dateTime: dateTime ?? this.dateTime,
        attendeeIds: attendeeIds ?? this.attendeeIds,
        status: status ?? this.status,
        momSummary: momSummary ?? this.momSummary,
        momSubmittedBy: momSubmittedBy ?? this.momSubmittedBy,
      );

  bool get isUpcoming => dateTime.isAfter(DateTime.now());

  String get statusLabel {
    switch (status) {
      case MeetingStatus.scheduled:
        return 'Scheduled';
      case MeetingStatus.completed:
        return 'Completed';
    }
  }
}

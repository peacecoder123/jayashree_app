import '../core/enums/status.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedToId;
  final String assignedById;
  final DateTime deadline;
  final DateTime createdAt;
  final TaskStatus status;
  final bool requiresPhotoUpload;
  final String? photoUrl;
  final String? adminComment;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedToId,
    required this.assignedById,
    required this.deadline,
    required this.createdAt,
    required this.status,
    required this.requiresPhotoUpload,
    this.photoUrl,
    this.adminComment,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        assignedToId: json['assignedToId'] as String,
        assignedById: json['assignedById'] as String,
        deadline: DateTime.parse(json['deadline'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: TaskStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => TaskStatus.pending,
        ),
        requiresPhotoUpload: json['requiresPhotoUpload'] as bool? ?? false,
        photoUrl: json['photoUrl'] as String?,
        adminComment: json['adminComment'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'assignedToId': assignedToId,
        'assignedById': assignedById,
        'deadline': deadline.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'requiresPhotoUpload': requiresPhotoUpload,
        'photoUrl': photoUrl,
        'adminComment': adminComment,
      };

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedToId,
    String? assignedById,
    DateTime? deadline,
    DateTime? createdAt,
    TaskStatus? status,
    bool? requiresPhotoUpload,
    String? photoUrl,
    String? adminComment,
  }) =>
      TaskModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        assignedToId: assignedToId ?? this.assignedToId,
        assignedById: assignedById ?? this.assignedById,
        deadline: deadline ?? this.deadline,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        requiresPhotoUpload: requiresPhotoUpload ?? this.requiresPhotoUpload,
        photoUrl: photoUrl ?? this.photoUrl,
        adminComment: adminComment ?? this.adminComment,
      );

  bool get isOverdue =>
      status == TaskStatus.pending && deadline.isBefore(DateTime.now());

  String get statusLabel {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.submitted:
        return 'Submitted';
      case TaskStatus.approved:
        return 'Approved';
      case TaskStatus.rejected:
        return 'Rejected';
    }
  }
}

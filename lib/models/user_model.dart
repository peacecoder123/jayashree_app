import '../core/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String avatar;
  final UserRole role;
  final String? assignedAdminId;
  final List<String> skills;
  final DateTime joinedDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.avatar,
    required this.role,
    this.assignedAdminId,
    required this.skills,
    required this.joinedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        location: json['location'] as String,
        avatar: json['avatar'] as String? ?? '',
        role: UserRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => UserRole.volunteer,
        ),
        assignedAdminId: json['assignedAdminId'] as String?,
        skills: List<String>.from(json['skills'] as List? ?? []),
        joinedDate: DateTime.parse(json['joinedDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'avatar': avatar,
        'role': role.name,
        'assignedAdminId': assignedAdminId,
        'skills': skills,
        'joinedDate': joinedDate.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? avatar,
    UserRole? role,
    String? assignedAdminId,
    List<String>? skills,
    DateTime? joinedDate,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        location: location ?? this.location,
        avatar: avatar ?? this.avatar,
        role: role ?? this.role,
        assignedAdminId: assignedAdminId ?? this.assignedAdminId,
        skills: skills ?? this.skills,
        joinedDate: joinedDate ?? this.joinedDate,
      );

  String get displayRole {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.member:
        return 'Member';
      case UserRole.volunteer:
        return 'Volunteer';
    }
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
